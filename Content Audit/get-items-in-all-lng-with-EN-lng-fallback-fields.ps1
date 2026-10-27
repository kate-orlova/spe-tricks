# ===== PARAMS =====
$database     = "web"
$rootPath = "{YOUR ROOT PATH}"
$templatePath = "{YOUR TEMPLATE PATH}"

$fallbackLanguage = "en"


# ===== GET TEMPLATE ITEM =====
$template = Get-Item -Path $templatePath
if (-not $template) {
    throw "Template not found at path: $templatePath"
}


# ===== STANDARD SYSTEM FIELDS =====
$standardSystemFields = @(
    "__Created",
    "__Created by",
    "__Final Renderings",
    "__Icon",
    "__ID",
    "__Item name",
    "__Language",
    "__Locked by",
    "__Modified",
    "__Modified by",
    "__Owner",
    "__Page Level Test Set Definition",
    "__Parent",
    "__Publishing groups",
    "__Renderings",
    "__Revision",
    "__Security",
    "__Semantics",
    "__Source",
    "__Standard values",
    "__Style",
    "__Subitems Sorting",
    "__Template",
    "__Thumbnail",
    "__Unpublish date",
    "__Valid from",
    "__Valid to",
    "__Version",
    "__Workflow",
    "__Workflow state"
)


# ===== GET BASE ITEMS =====
$items = Get-ChildItem -Path $rootPath -Recurse |
    Where-Object {
        $_.TemplateID -eq $template.ID
    }

# ===== RESULTS =====
$results = @()


foreach ($item in $items) {


    # Get every language/version combination for this item
    $variants = Get-Item -Path $item.ProviderPath -ID $item.ID -Language * -Version * -ErrorAction SilentlyContinue
    if (-not $variants) { continue }


    foreach ($variant in $variants) {


        if (-not $variant -or $variant.Version.Number -le 0) { continue }


        # Get the English item for fallback values
        $englishItem = $null
        if ($variant.Language.Name -ne $fallbackLanguage) {
            $englishItem = $variant.Database.GetItem(
                $variant.ID,
                [Sitecore.Globalization.Language]::Parse($fallbackLanguage)
            )
        }


        $data = [PSCustomObject]@{
            Id           = $item.ID.ToString()
            VariantId    = $variant.ID.ToString()
            Name         = $variant.Name
            Path         = $variant.Paths.FullPath
            Template     = $variant.TemplateName
            Language     = $variant.Language.Name
            Version      = $variant.Version.Number
            Fields       = [ordered]@{}
            SystemFields = [ordered]@{}
            Renderings   = @()
        }


        # ===== SYSTEM FIELDS =====
        # Include system fields available on the variant, plus standard system fields.
        $variantSystemFieldNames = $variant.Fields |
            Where-Object { $_.Name -and $_.Name.StartsWith("__") } |
            ForEach-Object { $_.Name }

        $systemFieldNames = @(
            $standardSystemFields
            $variantSystemFieldNames
        ) | Select-Object -Unique | Sort-Object

        foreach ($systemFieldName in $systemFieldNames) {
            $systemField = $variant.Fields[$systemFieldName]

            if ($systemField) {
                $data.SystemFields[$systemFieldName] = $systemField.Value
            }
            else {
                $data.SystemFields[$systemFieldName] = $null
            }
        }


        # ===== ITEM FIELDS =====
        # Build Fields from template field definitions so fallback-enabled fields
        # are always present, even when empty in the non-English variant.
        $templateFields = $variant.Template.Fields |
            Where-Object { $_.Name -and -not $_.Name.StartsWith("__") } |
            Sort-Object Name

        foreach ($templateField in $templateFields) {
            $fieldName = $templateField.Name

            # Get the field from the current language/version, if available
            $field = $variant.Fields[$fieldName]
            $fieldValue = $null

            if ($field) {
                $fieldValue = $field.Value
            }

            # Apply English fallback only for non-English variants
            if ($variant.Language.Name -ne $fallbackLanguage -and
                [string]::IsNullOrEmpty($fieldValue) -and
                $null -ne $englishItem) {

                # Resolve the field definition item from the template field
                $fieldDefinitionItem = $variant.Database.GetItem($templateField.ID)

                if ($fieldDefinitionItem -and
                    $fieldDefinitionItem["Enable Shared Language Fallback"] -eq "1") {

                    $englishField = $englishItem.Fields[$fieldName]

                    if ($englishField) {
                        $fieldValue = $englishField.Value
                    }
                }
            }

            # Always include the field in the Fields object
            $data.Fields[$fieldName] = $fieldValue
        }


        # ===== RENDERINGS =====
        $device = Get-LayoutDevice "Default"
        $renderings = Get-Rendering -Item $variant -Device $device -FinalLayout


        foreach ($rendering in $renderings) {
            if ($null -eq $rendering.ItemID) { continue }


            $renderingItem = Get-Item -Path ($database + ":") -ID $rendering.ItemID -ErrorAction SilentlyContinue
            if (-not $renderingItem) { continue }


            # ----- EXCLUSION LOGIC: FIELDS / DATASOURCE / CHILDREN -----
            $hasFields   = $renderingItem.Fields | Where-Object { -not $_.Name.StartsWith("__") } | Measure-Object | Select-Object -ExpandProperty Count
            $hasDatasourceConfig = -not [string]::IsNullOrEmpty($rendering.Datasource)
            $hasChildren = $renderingItem.Children | Measure-Object | Select-Object -ExpandProperty Count

            if ($hasFields -eq 0 -and -not $hasDatasourceConfig -and $hasChildren -eq 0) {
                continue
            }
            # -----------------------------------------------------------


            $datasourceData = $null


            if (-not [string]::IsNullOrEmpty($rendering.Datasource)) {
                $datasourceId = New-Object Sitecore.Data.ID($rendering.Datasource)
                $datasourceItem = Get-Item -Path ($database + ":") -ID $datasourceId -Language $variant.Language.Name -Version * -ErrorAction SilentlyContinue


                if ($datasourceItem) {
                    # Get English datasource item for fallback values
                    $englishDatasourceItem = $null
                    if ($datasourceItem.Language.Name -ne $fallbackLanguage) {
                        $englishDatasourceItem = $datasourceItem.Database.GetItem(
                            $datasourceItem.ID,
                            [Sitecore.Globalization.Language]::Parse($fallbackLanguage)
                        )
                    }


                    $datasourceFields = [ordered]@{}

                    # Build datasource Fields from template field definitions
                    $datasourceTemplateFields = $datasourceItem.Template.Fields |
                        Where-Object { $_.Name -and -not $_.Name.StartsWith("__") } |
                        Sort-Object Name

                    foreach ($templateField in $datasourceTemplateFields) {
                        $fieldName = $templateField.Name

                        # Get the field from the current language/version, if available
                        $field = $datasourceItem.Fields[$fieldName]
                        $fieldValue = $null

                        if ($field) {
                            $fieldValue = $field.Value
                        }

                        # Apply English fallback only for non-English datasource items
                        if ($datasourceItem.Language.Name -ne $fallbackLanguage -and
                            [string]::IsNullOrEmpty($fieldValue) -and
                            $null -ne $englishDatasourceItem) {

                            # Resolve the field definition item from the template field
                            $fieldDefinitionItem = $datasourceItem.Database.GetItem($templateField.ID)

                            if ($fieldDefinitionItem -and
                                $fieldDefinitionItem["Enable Shared Language Fallback"] -eq "1") {

                                $englishField = $englishDatasourceItem.Fields[$fieldName]

                                if ($englishField) {
                                    $fieldValue = $englishField.Value
                                }
                            }
                        }

                        # Always include the datasource field in the Fields object
                        $datasourceFields[$fieldName] = $fieldValue
                    }


                    $datasourceData = @{
                        Id       = $datasourceItem.ID.ToString()
                        Name     = $datasourceItem.Name
                        Path     = $datasourceItem.Paths.FullPath
                        Template = $datasourceItem.TemplateName
                        Language = $datasourceItem.Language.Name
                        Version  = $datasourceItem.Version.Number
                        Fields   = $datasourceFields
                    }
                }
            }


            # ----- EXCLUSION LOGIC: DATASOURCE & DATASOURCEITEM MUST EXIST -----
            # Skip renderings where Datasource is null/empty OR DatasourceItem resolved to null
            if ([string]::IsNullOrEmpty($rendering.Datasource) -or $null -eq $datasourceData) {
                continue
            }
            # ------------------------------------------------------------------


            $renderingObject = @{
                UniqueId              = $rendering.UniqueId
                ItemId                = $rendering.ItemID
                OwnerItemId           = $rendering.OwnerItemId
                RenderingName         = $renderingItem.Name
                RenderingTemplateName = $renderingItem.TemplateName
                Placeholder           = $rendering.Placeholder
                Parameters            = $rendering.Parameters
                Datasource            = $rendering.Datasource
                DatasourceItem        = $datasourceData
            }


            $data.Renderings += $renderingObject
        }


        $results += $data
    }
}


# ===== EXPORT =====
$json = $results | ConvertTo-Json -Depth 20
Out-Download -InputObject $json -Name "Schools-22102026.json" -ContentType "application/json"
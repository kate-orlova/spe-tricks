# ===== PARAMS =====
$database = "web"
$rootPath = "{YOUR ROOT PATH}"
$templatePath = "{YOUR TEMPLATE PATH}"

function Convert-SitecoreItemToObject {
    param(
        [Sitecore.Data.Items.Item]$Item
    )

    if (-not $Item) { return $null }

    $fields = [ordered]@{}
    foreach ($field in $Item.Fields) {
        if (-not $field.Name.StartsWith("__")) {
            $fields[$field.Name] = $field.Value
        }
    }

    $children = @()
    foreach ($child in $Item.Children) {
        $children += Convert-SitecoreItemToObject -Item $child
    }

    [PSCustomObject]@{
        Id       = $Item.ID.ToString()
        Name     = $Item.Name
        Path     = $Item.Paths.FullPath
        Template = $Item.TemplateName
        Language = $Item.Language.Name
        Version  = $Item.Version.Number
        Fields   = $fields
        Children = $children
    }
}

# ===== GET TEMPLATE ITEM =====
$template = Get-Item -Path $templatePath
if (-not $template) {
    throw "Template not found at path: $templatePath"
}

# ===== GET BASE ITEMS =====
$items = Get-ChildItem -Path $rootPath -Recurse |
Where-Object { $_.TemplateID -eq $template.ID }

# ===== RESULTS =====
$results = @()

foreach ($item in $items) {

    # Get every language/version combination for this item
    $variants = Get-Item -Path $item.ProviderPath -ID $item.ID -Language * -Version * -ErrorAction SilentlyContinue
    if (-not $variants) { continue }

    foreach ($variant in $variants) {

        if (-not $variant -or $variant.Version.Number -le 0) { continue }

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

        # ===== ITEM FIELDS =====
        $fieldNames = $variant.Fields | ForEach-Object { $_.Name } | Sort-Object
        foreach ($fieldName in $fieldNames) {
            $field = $variant.Fields[$fieldName]
            if ($fieldName.StartsWith("__")) {
                $data.SystemFields[$fieldName] = $field.Value
            }
            else {
                $data.Fields[$fieldName] = $field.Value
            }
        }

        # ===== RENDERINGS =====
        $device = Get-LayoutDevice "Default"
        $renderings = Get-Rendering -Item $variant -Device $device -FinalLayout

        foreach ($rendering in $renderings) {
            if ($null -eq $rendering.ItemID) { continue }

            $renderingItem = Get-Item -Path ($database + ":") -ID $rendering.ItemID -ErrorAction SilentlyContinue
            if (-not $renderingItem) { continue }

            $datasourceData = $null

            if (-not [string]::IsNullOrEmpty($rendering.Datasource)) {
                $datasourceId = New-Object Sitecore.Data.ID($rendering.Datasource)
                $datasourceItem = Get-Item -Path ($database + ":") -ID $datasourceId -Language $variant.Language.Name -Version * -ErrorAction SilentlyContinue

                if ($datasourceItem) {
                    $datasourceVariant = Get-Item -Path $datasourceItem.ProviderPath -Language $variant.Language.Name -Version * -ErrorAction SilentlyContinue |
                    Select-Object -First 1

                    if ($datasourceVariant) {
                        $datasourceData = Convert-SitecoreItemToObject -Item $datasourceVariant
                    }
                }
            }

            $renderingObject = [PSCustomObject]@{
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
$json = $results | ConvertTo-Json -Depth 30
Out-Download -InputObject $json -Name "items-by-template-all-language-versions-with-children.json" -ContentType "application/json"
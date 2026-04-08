# ===== PARAMS =====
$database = "master"
$lng = "{YOUR LANGUAGE}"
$rootPath = "{YOUR ROOT PATH}"
$templatePath = "{YOUR TEMPLATE PATH}"


# ===== GET TEMPLATE ITEM =====
$template = Get-Item -Path $templatePath

if (-not $template) {
    throw "Template not found at path: $templatePath"
}

# ===== GET ALL ITEMS BASED ON THIS TEMPLATE =====
$items = Get-ChildItem -Path $rootPath -Recurse -Language $lng |
Where-Object { $_.TemplateID -eq $template.ID }


# ===== COLLECT ALL ITEM OBJECTS =====
$results = @()

foreach ($item in $items) {

    $item = $item.Versions.GetLatestVersion()

    # ===== BUILD JSON OBJECT =====
    $data = [PSCustomObject]@{
        Id           = $item.ID.ToString()
        Name         = $item.Name
        Path         = $item.Paths.FullPath
        Template     = $item.TemplateName
        Language     = $item.Language.Name
        Version      = $item.Version.Number
        Fields       = [ordered]@{}
        SystemFields = [ordered]@{}
        Renderings   = @()
    }

    # ===== PAGE FIELDS =====
	$fieldNames = $item.Fields | ForEach-Object { $_.Name } | Sort-Object

	foreach ($fieldName in $fieldNames) {
		$field = $item.Fields[$fieldName]
		if (-not $fieldName.StartsWith("__")) {
			$data.Fields[$fieldName] = $field.Value
		}
		else {
			$data.SystemFields[$fieldName] = $field.Value
		}
	}
		

    # ===== GET RENDERINGS =====
    $device = Get-LayoutDevice "Default"
    $renderings = Get-Rendering -Item $item -Device $device -FinalLayout

    foreach ($rendering in $renderings) {

        if ($rendering.ItemID -eq $null) { continue }

        $renderingItem = Get-Item -Path ($database + ":") -ID $rendering.ItemID


        # ===== DATASOURCE DATA =====
        $datasourceData = $null

        if (![string]::IsNullOrEmpty($rendering.Datasource)) {
            
            $datasourceId = New-Object Sitecore.Data.ID($rendering.Datasource)
            $datasourceItem = Get-Item -Path ($database + ":") -ID $datasourceId -Language $lng -ErrorAction SilentlyContinue
	
            if ($datasourceItem) {

                $datasourceFields = @{}

                foreach ($field in $datasourceItem.Fields) {
                    if (-not $field.Name.StartsWith("__")) {
                        $datasourceFields[$field.Name] = $field.Value
                    }
                }

                $datasourceData = @{
                    Id       = $datasourceItem.ID.ToString()
                    Name     = $datasourceItem.Name
                    Path     = $datasourceItem.Paths.FullPath
                    Template = $datasourceItem.TemplateName
                    Fields   = $datasourceFields
                }
            }
        }

        # ===== RENDERING OBJECT =====
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

        # ADD TO ARRAY PRESERVING ORDER
        $data.Renderings += $renderingObject
    }

    # add this item object to results collection
    $results += $data
}

# ===== EXPORT COLLECTION =====
# $results is now an array of all items; ConvertTo-Json will serialize it as a JSON array
$json = $results | ConvertTo-Json -Depth 20

Out-Download -InputObject $json -Name "items-by-template-$lng.json" -ContentType "application/json"


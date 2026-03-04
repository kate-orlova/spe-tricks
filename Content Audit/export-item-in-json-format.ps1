# ===== PARAMS =====
$database     = "master"
$itemPath = "{YOUR ITEM PATH}"

$item = Get-Item ($database + ":" + $itemPath)
$item.Versions.GetLatestVersion()

if (-not $item) {
    throw "Item not found: $itemId"
}

# ===== BUILD JSON OBJECT =====
$data = [PSCustomObject]@{
    Id       = $item.ID.ToString()
    Name     = $item.Name
    Path     = $item.Paths.FullPath
    Template = $item.TemplateName
    Language = $item.Language.Name
    Version  = $item.Version.Number
    Fields   = @{}
}

foreach ($field in $item.Fields) {
    if (-not $field.Name.StartsWith("__")) {
        $data.Fields[$field.Name] = $field.Value
    }
}

# ===== EXPORT =====
$json = $data | ConvertTo-Json -Depth 10

Write-Host "JSON output (latest version $($item.Version.Number)):" -ForegroundColor Cyan
$json | Out-Download -Name ("item " + $item.ID + ".json") -ContentType "application/json"


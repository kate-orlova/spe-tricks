$sourcePath = "master:\sitecore\content\home\MyItems"
$itemTemplate = "Service"

$rendering = Get-Item "master:\sitecore\layout\Renderings\Modules\MyRendering"

$items = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.TemplateName -eq $itemTemplate }

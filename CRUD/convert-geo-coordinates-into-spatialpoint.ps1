using namespace Sitecore.ContentSearch.Spatial.DataTypes

$places = Get-ChildItem -Path "master:\sitecore\content\home\Places" -Recurse  | Where-Object { $_.TemplateName -eq "Place" }
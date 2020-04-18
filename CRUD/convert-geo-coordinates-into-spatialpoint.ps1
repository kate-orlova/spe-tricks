using namespace Sitecore.ContentSearch.Spatial.DataTypes

$places = Get-ChildItem -Path "master:\sitecore\content\home\Places" -Recurse  | Where-Object { $_.TemplateName -eq "Place" }
if ($places)
{
	Write-Host "Items to update: $($places.Length)"
	
	Write-Host "Finished"
}
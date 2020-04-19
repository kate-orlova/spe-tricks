using namespace Sitecore.ContentSearch.Spatial.DataTypes

$places = Get-ChildItem -Path "master:\sitecore\content\home\Places" -Recurse  | Where-Object { $_.TemplateName -eq "Place" }
if ($places)
{
	Write-Host "Items to update: $($places.Length)"
	
	$counter = 0
	$places | ForEach-Object {
		$place = $_
		$latitude = $place["Latitude"]
		$longitude = $place["Longitude"]
		$coordinates = $latitude + ',' + $longitude
		$place.Editing.BeginEdit()		
		
		$counter++
		Write-Host "Processed $($counter) items out of $($places.Length)"
	}
	
	Write-Host "Finished"
}
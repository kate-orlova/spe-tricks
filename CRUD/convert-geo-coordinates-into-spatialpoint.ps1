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
		$spatialPoint = New-Object -TypeName Sitecore.ContentSearch.Spatial.DataTypes.SpatialPoint -ArgumentList $coordinates
		$place.Editing.BeginEdit()
		$place["Coordinates"] = $spatialPoint.ToString()
		$place.Editing.EndEdit()		
		
		$counter++
		Write-Host "Processed $($counter) item out of $($places.Length) with $($spatialPoint.Lat), $($spatialPoint.Lon) coordinates"
	}
	
	Write-Host "Finished"
}
$sourcePath = "master:\sitecore\content\home\MyItems"
$targetPath = "master:\sitecore\content\home\MyNewItems"
 
$destinationItem = Get-Item $targetPath
$items = Get-ChildItem -Path $sourcePath -Recurse
 
if ($items)
{
    Write-Host "Copying $($items.Length) item(s) from '$($sourcePath)' to '$($targetPath)'"
     
    $items | ForEach-Object {
       Copy-Item $_.ItemPath -DestinationItem $destinationItem
    }
    Write-Host "Finished"
}
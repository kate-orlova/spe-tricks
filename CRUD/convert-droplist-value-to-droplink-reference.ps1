$products = Get-ChildItem -Path "master:\sitecore\content\home\Products" -Recurse  | Where-Object { $_.TemplateName -eq "Product" }
if ($products)
{
	Write-Host "Finished"
}
$products = Get-ChildItem -Path "master:\sitecore\content\home\Products" -Recurse  | Where-Object { $_.TemplateName -eq "Product" }
$productTypes = Get-ChildItem -Path "master:\sitecore\content\home\ProductTypes" -Recurse  | Where-Object { $_.TemplateName -eq "ProductType" }
if ($products)
{
	Write-Host "Finished"
}
$products = Get-ChildItem -Path "master:\sitecore\content\home\Products" -Recurse  | Where-Object { $_.TemplateName -eq "Product" }
$productTypes = Get-ChildItem -Path "master:\sitecore\content\home\ProductTypes" -Recurse  | Where-Object { $_.TemplateName -eq "ProductType" }
if ($products)
{
	Write-Host "Items to update: $($products.Length)"
	
	$counter = 0
	$products | ForEach-Object {
		$product = $_
		$strProductType = $product["ProductType"]
		
		$productTypeItem = $productTypes | Where-Object { $_.Name -eq $strProductType -or $_.DisplayName -eq $strProductType }
		if ($productTypeItem) {
			$productTypeId = $productTypeItem.ID
			$product.Editing.BeginEdit()
			$product["ProductType"] = $productTypeId
		}
	
		$counter++
		Write-Host "Processed $($counter) out of $($products.Length)"
	}
	
	Write-Host "Finished"
}
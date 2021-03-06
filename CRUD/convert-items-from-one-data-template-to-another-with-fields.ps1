$sourcePath = "master:\sitecore\content\home\MyItems"
$targetTemplate = "master:\sitecore\templates\User Defined\Project\My Page types\Data\FAQ"
$itemTemplate = "Service"

$targetTemplateItem = Get-Item $targetTemplate

$items = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.TemplateName -eq $itemTemplate }
 
if ($items)
{
	Write-Host "Converting $($items.Length) item(s) to '$($targetTemplate)'"
	$items | ForEach-Object {
        $metaTitle = $_["MetaTitle"]
		$metaDescription = $_["MetaDescription"]
		$metaKeywords = $_["MetaKeywords"]
		
		Unlock-Item -Item $_
        Remove-ItemLanguage -Item $_ -Language "en-GB"
        Set-ItemTemplate -Item $_ -TemplateItem $targetTemplateItem
		
		$_.Editing.BeginEdit()
		$_["MetaTitle"] = $metaTitle
		$_["MetaDescription"] = $metaDescription
		$_["MetaKeywords"] = $metaKeywords
		$_.Editing.EndEdit()
	}
    Write-Host "Finished"
}
$targetPath = "master:\sitecore\content\home\MyItems"

$items = Get-ChildItem -Path $targetPath -Recurse
if ($items)
{
    Write-Host "Adding 'en-GB' language to $($items.Length) item(s) from '$($targetPath)'"

    $items | ForEach-Object {
        Add-ItemLanguage $_ -Language "en-GB" -TargetLanguage "en" -IfExist OverwriteLatest
    }
    Write-Host "Finished"
}
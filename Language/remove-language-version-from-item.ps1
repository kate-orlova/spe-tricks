$targetPath = "master:\sitecore\content\home\MyItem"

$item = Get-Item -Path $targetPath -Recurse
if ($item)
{
    Write-Host "Removing 'en-GB' language to $($items.Length) item(s) from '$($targetPath)'"

       Unlock-Item -Item $_
       Remove-ItemLanguage -Item $_ -Language "en-GB"

    Write-Host "Finished"
}
$licenseFilePath = "{YOUR_LICENSE_PATH}\license.xml"

$expiredLicenses = Get-ChildItem -Path "C:\inetpub\wwwroot" -Filter "license.xml" -Recurse -ErrorAction Ignore
$backupStamp = get-date -format yyyy-MMM-dd

foreach($expiredLicense in $expiredLicenses)
{
    Write-Host "Replacing $($expiredLicense.FullName)"

    Move-Item $expiredLicense.FullName "$($expiredLicense.FullName).$($backupStamp).bak" -Force
    Copy-Item $licenseFilePath $expiredLicense.FullName
}



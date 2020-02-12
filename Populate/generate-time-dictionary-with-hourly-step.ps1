$systemDictionaryPath = "master:/sitecore/system/Dictionary"
$systemDictionaryFolderTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary folder"
$systemDictionaryEntryTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary entry"

$hoursDictionary = New-Item -Path $systemDictionaryPath -Name "Hours" -type $systemDictionaryFolderTemplate

$items = 0..24
$items | ForEach-Object {
	$step = $_
	$time = [System.TimeSpan]::FromHours($step)
}

Write-Host "Finished"
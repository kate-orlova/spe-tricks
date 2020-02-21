$systemDictionaryPath = "master:/sitecore/system/Dictionary"
$systemDictionaryFolderTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary folder"
$systemDictionaryEntryTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary entry"

$halfHoursDictionary = New-Item -Path $systemDictionaryPath -Name "HalfHours" -type $systemDictionaryFolderTemplate

$items = 0..47
$items | ForEach-Object {
	$step = $_
	$time = [System.TimeSpan]::FromHours(30*$step)
	$dateTime = [System.DateTime]::Today + $time
	$timeStr = $dateTime.ToString("HH:mm")
	$timeEntry = New-Item -Path $halfHoursDictionary.FullPath -Name $timeStr.Replace(":", "-") -type $systemDictionaryEntryTemplate
	$timeEntry.Editing.BeginEdit()
	$timeEntry["__Display name"] = $timeStr
	$timeEntry["Key"] = $timeStr
	$timeEntry["Phrase"] = $timeStr
	$timeEntry.Editing.EndEdit()
	Write-Host "Created '$timeStr' dictionary item"
}

Write-Host "Finished"
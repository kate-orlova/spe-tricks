$systemDictionaryPath = "master:/sitecore/system/Dictionary"
$systemDictionaryFolderTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary folder"
$systemDictionaryEntryTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary entry"

$hoursDictionary = New-Item -Path $systemDictionaryPath -Name "Hours" -type $systemDictionaryFolderTemplate

$items = 0..24
$items | ForEach-Object {
	$step = $_
	$time = [System.TimeSpan]::FromHours($step)
	$dateTime = [System.DateTime]::Today + $time
	$timeStr = $dateTime.ToString("HH:mm")
	$timeEntry = New-Item -Path $hoursDictionary.FullPath -Name $timeStr.Replace(":", "-") -type $systemDictionaryEntryTemplate
	$timeEntry.Editing.BeginEdit()
	$timeEntry["__Display name"] = $timeStr
	$timeEntry.Editing.EndEdit()
}

Write-Host "Finished"
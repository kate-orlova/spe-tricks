$colours = @(
    "Red",
    "Yellow",
    "Green",
    "Blue"
)

$systemDictionaryPath = "master:/sitecore/system/Dictionary"
$systemDictionaryFolderTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary folder"
$systemDictionaryEntryTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary entry"

$coloursDictionary = New-Item -Path $systemDictionaryPath -Name "Colours" -type $systemDictionaryFolderTemplate

$colours | ForEach-Object {
	$displayName = $_
	$itemName = $_
	
	$dictionaryEntry = New-Item -Path $coloursDictionary.FullPath -Name $itemName -type $systemDictionaryEntryTemplate
	$dictionaryEntry.Editing.BeginEdit()
	$dictionaryEntry["__Display name"] = $displayName
}

Write-Host "Finished"
$systemDictionaryPath = "master:/sitecore/system/Dictionary"
$systemDictionaryFolderTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary folder"
$systemDictionaryEntryTemplate = "master:/sitecore/templates/System/Dictionary/Dictionary entry"

$hoursDictionary = New-Item -Path $systemDictionaryPath -Name "Hours" -type $systemDictionaryFolderTemplate

Write-Host "Finished"
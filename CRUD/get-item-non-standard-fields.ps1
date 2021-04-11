$sourcePath = "master:\sitecore\content\home"
Get-Item $sourcePath | Get-ItemField -ReturnType Field -Name "*" | ft Name, DisplayName, SectionDisplayName, Description, Value -auto
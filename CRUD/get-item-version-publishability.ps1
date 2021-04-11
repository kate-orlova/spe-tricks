$sourcePath = "master:\sitecore\content\home"
Get-Item $sourcePath -Version 1 | Get-ItemField -IncludeStandardFields -ReturnType Field -Name "__Hide version"
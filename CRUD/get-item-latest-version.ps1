$sourcePath = "master:\sitecore\content\home"
$item = Get-Item $sourcePath
$item.Versions.GetLatestVersion()
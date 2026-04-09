$mediaitem = Get-Item -Path "web:{YOUR ITEM PATH}"
$siteName = "yoursitename"

$site = [Sitecore.Sites.SiteContextFactory]::GetSiteContext($siteName)
New-UsingBlock (New-Object Sitecore.Sites.SiteContextSwitcher $site) {
    [Sitecore.Resources.Media.MediaManager]::GetMediaUrl($mediaitem)
}

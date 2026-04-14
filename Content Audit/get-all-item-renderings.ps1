# ===== PARAMS =====
$database     = "master"
$rootPath = "{YOUR_ROOT_PATH}"

$device = Get-LayoutDevice "Default"

$result = @()

$items = Get-ChildItem -Path ($database + ":" + $rootPath) -Recurse
    

foreach ($item in $items) {

# ===== GET RENDERINGS =====
$renderings = Get-Rendering -Item $item -Device $device -FinalLayout
$RenderingList = @()


foreach ($rendering in $renderings) {

    if ($rendering.ItemID -eq $null) { continue }

    $renderingItem = Get-Item -Path ($database + ":") -ID $rendering.ItemID
	
	$RenderingList += $renderingItem
}



$result += [PSCustomObject]@{
        ItemName  = $item.Name
        ItemPath  = $item.FullPath
		TemplatePath = $item.Template.InnerItem.Paths.FullPath
        Renderings = ($RenderingList.Name -join ", ")
        RenderingCount     = $RenderingList.Count
    }


}


Write-Host "Pages scanned: $($items.Count)" -ForegroundColor Cyan

$result | Sort-Object ItemPath | Show-ListView `
    -Title "Renderings" `
    -Property ItemName, ItemPath, TemplatePath, Renderings, RenderingCount
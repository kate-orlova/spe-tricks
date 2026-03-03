# ===== PARAMS =====
$database     = "master"
$renderingID = "{YOUR_RENDERING_ID}"
$rootPath = "{YOUR_ROOT_PATH}"

$count = 0
$itemsUsingComponent = @()

# ===== FIND ITEMS USING THE CONCERNED RENDERING =====
$items = Get-ChildItem -Path ($database + ":" + $rootPath) -Recurse

foreach ($item in $items) {
    $renderings = Get-Rendering -Item $item -Device (Get-LayoutDevice "Default") -FinalLayout

    foreach ($rendering in $renderings) {

        if ($rendering.ItemID -eq $renderingID) {
            $count++
            $itemsUsingComponent += $item
            break # avoid double-counting the same item in case the same rendering is added multiple times
        }
    }
}

# ==========================
# OUTPUT
# ==========================

Write-Host "Total items using $renderingID rendering: $count" -ForegroundColor Green

# Optional: list item paths
$itemsUsingComponent | Select-Object Name, FullPath
# ===== PARAMS =====
$database     = "master"
$rootPath = "{YOUR_ROOT_PATH}"


$result = @()
$allLanguages = New-Object System.Collections.Generic.HashSet[string]

$items = Get-ChildItem -Path ($database + ":" + $rootPath) -Recurse

foreach ($item in $items) {

    # Get all languages that exist for this item
    $languages = $item.Languages |
        Where-Object {
            $item.Versions.GetVersions($_).Count -gt 0
        }

    if ($languages.Count -gt 0) {

        foreach ($lang in $languages) {
            $allLanguages.Add($lang.Name) | Out-Null
        }

        $result += [PSCustomObject]@{
            ItemName  = $item.Name
            ItemPath  = $item.FullPath
            Languages = ($languages.Name -join ", ")
            Count     = $languages.Count
        }
    }
}

# ==========================
# OUTPUT
# ==========================

Write-Host "Pages scanned: $($items.Count)" -ForegroundColor Cyan
Write-Host "Languages found: $($allLanguages -join ', ')" -ForegroundColor Green

$result | Sort-Object ItemPath | Show-ListView `
    -Title "Language Variants by Page" `
    -Property ItemName, ItemPath, Languages, Count
# ===== PARAMS =====
$database     = "master"
$templateID = "{YOUR_TEMPLATE_ID}"
$rootPath   = "{YOUR_ROOT_PATH}"

# ===== GET ALL ITEMS BASED ON THIS TEMPLATE =====
$items = Get-ChildItem -Path ($database + ":" + $rootPath) -Recurse |
    Where-Object { $_.TemplateID -eq $templateID }

$count = $items.Count

# ===== OUTPUT =====
Write-Host "Template:" $template.Name -ForegroundColor Cyan
Write-Host "Template ID:" $templateID
Write-Host "Root Path:" $rootPath
Write-Host "Total items:" $count -ForegroundColor Green

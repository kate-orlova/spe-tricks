# ===== PARAMS =====
$database     = "master"
$templatePath = "{YOUR_TEMPLATE_PATH}"
$rootPath     = "{YOUR_ROOT_PATH}"

# ===== GET TEMPLATE ITEM =====
$template = Get-Item -Path ($database + ":" + $templatePath)

if (-not $template) {
    throw "Template not found at path: $templatePath"
}

# ===== GET ALL ITEMS BASED ON THIS TEMPLATE =====
$items = Get-ChildItem -Path ($database + ":" + $rootPath) -Recurse |
    Where-Object { $_.TemplateID -eq $template.ID }

$count = $items.Count

# ===== OUTPUT =====
Write-Host "Template:" $template.Name -ForegroundColor Cyan
Write-Host "Template ID:" $template.ID
Write-Host "Root Path:" $rootPath
Write-Host "Total items:" $count -ForegroundColor Green

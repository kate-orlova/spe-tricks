# ===== PARAMS =====
$database     = "web"
$templatePath = "{YOUR TEMPLATE PATH}"
$filePath = "{YOUR FILE PATH}"
# -----------------------------------------------

$templateItem = Get-Item -Path $templatePath -ErrorAction Stop

if (-not $templateItem) {
    Write-Error "Template not found: $templatePath"
    return
}

# Cast to TemplateItem so .Fields includes inherited fields
$template = [Sitecore.Data.Items.TemplateItem]$templateItem

Write-Host "Template: $($template.Name)"
Write-Host "Path:     $($template.Paths.FullPath)"
Write-Host "Fields found (including inherited): $($template.Fields.Count)"

$results = foreach ($field in $template.Fields) {
    $fieldItem = $field.InnerItem

    if (-not $fieldItem) { continue }

    # Ignore Sitecore system fields
    if ($fieldItem.Paths.FullPath -like "/sitecore/templates/System/*") { continue }

    $sharedFallback = $fieldItem["Enable Shared Language Fallback"]

    if ($sharedFallback -eq "1") {
        # Field definition item structure:
        # /sitecore/templates/<...>/<Template>/<Section>/<Field>
        $owningTemplate = $fieldItem.Parent.Parent

        [PSCustomObject]@{
            Template                     = $owningTemplate.Name
            TemplatePath                 = $owningTemplate.Paths.FullPath
            FieldName                    = $fieldItem.Name
            FieldPath                    = $fieldItem.Paths.FullPath
            FieldId                      = $fieldItem.ID
            EnableSharedLanguageFallback = $true
        }
    }
}

$results = $results |
    Sort-Object TemplatePath, FieldName

Write-Host ""
Write-Host "Fields with field-level language fallback enabled: $($results.Count)"

$results |
    Format-Table Template, FieldName, EnableSharedLanguageFallback -AutoSize

# Export to CSV
$results | Export-Csv -Path $filePath -NoTypeInformation -Encoding UTF8
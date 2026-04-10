# ===== PARAMS =====
$database = "web"
$sourcePath = "{YOUR SOURCE ITEM PATH}"
$exportFolder = "{YOUR LOCAL FOLDER PATH}"

if (-not (Test-Path $exportFolder)) {
    New-Item -ItemType Directory -Path $exportFolder | Out-Null
}

# Get all media items skipping folders
$mediaItems = Get-ChildItem "$database`:$sourcePath" -Recurse | 
    Where-Object { $_.TemplateID -ne [Sitecore.TemplateIDs]::MediaFolder }

foreach ($item in $mediaItems) {
    
    $fileName = "$($item.Name).$($item.Extension)"
    $jsonPath = Join-Path $exportFolder "$($item.ID.ToString())-$fileName.json"
    $blobPath = Join-Path $exportFolder $fileName
    
    # Extract blob to file
    $blobField = $item.Fields['Blob']
    if ($blobField -and $blobField.HasBlobStream) {
        $blobStream = $blobField.GetBlobStream()
        try {
            $memoryStream = New-Object System.IO.MemoryStream
            $blobStream.CopyTo($memoryStream)
            $blobBytes = $memoryStream.ToArray()
            [System.IO.File]::WriteAllBytes($blobPath, $blobBytes)
        }
        finally {
            if ($blobStream) { $blobStream.Dispose() }
            if ($memoryStream) { $memoryStream.Dispose() }
        }
    }
    
	# ===== BUILD JSON OBJECT =====

	$data = [PSCustomObject]@{
        Id = $item.ID.ToString()
        Name = $item.Name
        Path = $item.Paths.FullPath
        Extension = $item.Extension
        MimeType = $item.Fields['M'].Value
        SizeBytes = if ($item.Fields['Size']) { $item.Fields['Size'].Value } else { 0 }
        Fields = [ordered]@{}
        SystemFields = [ordered]@{}
    }
    
    $item.Fields | Where-Object { -not $_.Name.StartsWith("__") } | 
        ForEach-Object { $data.Fields[$_.Name] = $_.Value }

    $item.Fields | Where-Object { $_.Name.StartsWith("__") } | 
        ForEach-Object { $data.SystemFields[$_.Name] = $_.Value }
    
    if ($jsonPath) {
        $data | ConvertTo-Json -Depth 10 | Set-Content $jsonPath -Encoding UTF8
    }
}

Write-Host "Exported $($mediaItems.Count) assets to $exportFolder" -ForegroundColor Green
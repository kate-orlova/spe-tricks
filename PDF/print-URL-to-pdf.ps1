$url = "{your desired page URL that you want to save as PDF}"
$destinationFolder = "{folder where your PDF will be stored}"
$outfile = 'URLtoPDF.pdf'
$outputPath = Join-Path -Path $destinationFolder -ChildPath $outfile
& '{full path}\Google\Chrome\Application\chrome.exe' --headless --print-to-pdf="$outputPath" "$url"
Start-Sleep -Seconds 10

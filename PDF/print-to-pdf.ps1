$sourceFile = "{source file containing all the URLs you want to convert}"
$destinationFolder = "{folder where PDFs will be stored}"
$num = 1

foreach ($url in [System.IO.File]::ReadLines($sourceFile))
{
	$outfile = $num.ToString() + '.pdf'
	$outputPath = Join-Path -Path $destinationFolder -ChildPath $outfile
	& '{full path}\Google\Chrome\Application\chrome.exe' --headless --print-to-pdf="$outputPath" "$url"
	Start-Sleep -Seconds 4
	$num++
}
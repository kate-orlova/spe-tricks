Add-Type -Path '..\HtmlAgilityPack.dll'    
$html_doc = New-Object HtmlAgilityPack.HtmlDocument


$tmp_str = @'
<p>test copy 1 <a href="https://somedomain1.com">some link 1</a></p>
<p>test copy 2 <a href="https://somedomain2.com">some link 2</a></p>
'@

$links = @()

$html_doc.LoadHtml($tmp_str)


foreach($link in $html_doc.DocumentNode.SelectNodes("//a")) {                
   $links +=$link.Attributes["href"].Value               
}

$links

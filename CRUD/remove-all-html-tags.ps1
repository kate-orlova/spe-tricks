$tmp_str = @'
test copy <a href="http://somedomain.com">some link</a>
'@

$tmp_str -replace "<.*?>", ""
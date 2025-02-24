Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq <YOUR_PORT> } | ForEach-Object { Get-Process -Id $_.OwningProcess }



	
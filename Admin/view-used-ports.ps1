Get-NetTCPConnection -State Listen | Select-Object -Property *, `
    @{'Name' = 'ProcessName';'Expression'={(Get-Process -Id $_.OwningProcess).Name}} `
    | select ProcessName,LocalAddress,LocalPort
	
	

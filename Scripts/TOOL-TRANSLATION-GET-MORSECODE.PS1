function Get-MorseCode {

<#
.SYNOPSIS
Convert text to morse code
.DESCRIPTION
Convertir du texte en code morse | convert text to morse code
.PARAMETER TEXT
TEXT to translate
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>

Param(   
         [string]$TEXT,
         [string]$MORSE
         
      )

if($text -ne ""){(Invoke-RestMethod -Uri "https://api.funtranslations.com/translate/morse.json?text=$TEXT" | Select-Object -ExpandProperty contents).translated}

if($morse -ne ""){(Invoke-RestMethod -Uri "http://api.funtranslations.com/translate/morse2english.json?text=$MORSE" | Select-Object -ExpandProperty contents).translated}

}

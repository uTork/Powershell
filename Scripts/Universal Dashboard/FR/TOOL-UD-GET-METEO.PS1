function Get-Meteo {
<#
.SYNOPSIS
Obtenir des informations météorologiques de base sur une ville dans le monde.
.DESCRIPTION
Ce script utilise l'API https://openweathermap.org/api. Vous devez créer un compte gratuit et obtenir un APPID.
Développé pour Universal Dashboard.
.PARAMETER City
Entrez le nom de la ville souhaitée pour obtenir les informations météo
.EXAMPLE
Get-Meteo -City "Jonquiere" -ApiKey "8d409c0358df4b499c11931e717f2561"
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

[CmdletBinding()]

param([string]$City,
      [string]$ApiKey


)



# URL de l'API
$query = "http://api.openweathermap.org/data/2.5/weather?q=$City&APPID=$ApiKey"

# Interroger Open Weather Map
$meteo = try{Invoke-RestMethod $query -ErrorAction Stop}catch{
                                                              $ErrorMessage = $_.ErrorDetails.message
                                                             
                                                              if($ErrorMessage -like "*API key*"){
                                                                                                   clear
                                                                                                   $message = "The API Key is invalid. Go to http://openweathermap.org and register to get your free API KEY"
                                                                                                   write-host $message -ForegroundColor Red
                                                                                                   break 
                                                                                                   }
                                                              if($ErrorMessage -like "*City*"){
                                                                                                   clear
                                                                                                   $message = 'City not found | Example: Get-Meteo -City "shipshaw" -Api_Key "8d409c0358df4b499c119399999f2561"'
                                                                                                   write-host $message -ForegroundColor Red
                                                                                                   break 
                                                                                                   }
                                                             }

# Température actuelle

$kelvin = "273.15"

[string]$current_temp =  [math]::Round($meteo.main.temp - $kelvin)
$current_temp = $current_temp + "°C"

# Température min
[string]$min_temp =  [math]::Round($meteo.main.temp_min - $kelvin)
$min_temp = $min_temp + "°C"

# Température max
[string]$max_temp =  [math]::Round($meteo.main.temp_max - $kelvin)
$max_temp = $max_temp + "°C"

# Humidité
[string]$humidity = $meteo.main.humidity
$humidity = $humidity   + "%"

# Pression
[string]$pressure = $meteo.main.pressure 
$pressure = $pressure  + "hPa"

# Visibilité
[string]$visibility = [math]::Round($meteo.visibility /1000)
$visibility = $visibility  + "Km"

# Nom de la ville
$city_name = $meteo.name


$obj = New-Object PSObject
$obj | Add-Member -type NoteProperty -Name 'City' -Value $city_name
$obj | Add-Member -type NoteProperty -Name 'Current Temperature' -Value $current_temp
$obj | Add-Member -type NoteProperty -Name 'Minumum Temperature' -Value $min_temp
$obj | Add-Member -type NoteProperty -Name 'Maximum Temperature' -Value $max_temp
$obj | Add-Member -type NoteProperty -Name 'Humidity' -Value $humidity
$obj | Add-Member -type NoteProperty -Name 'Pressure' -Value $pressure
$obj | Add-Member -type NoteProperty -Name 'Visibility' -Value $visibility

                                          
$obj

}

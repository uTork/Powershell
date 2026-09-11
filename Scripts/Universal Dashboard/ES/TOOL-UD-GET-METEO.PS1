function Get-Meteo {
<#
.SYNOPSIS
Obtener información meteorológica básica de una ciudad del mundo.
.DESCRIPTION
Este script usa la API https://openweathermap.org/api. Debe abrir una cuenta gratuita y obtener un APPID.
Desarrollado para Universal Dashboard.
.PARAMETER City
Introduzca el nombre de la ciudad deseada y obtenga la información meteorológica
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



# URL de la API
$query = "http://api.openweathermap.org/data/2.5/weather?q=$City&APPID=$ApiKey"

# Consultar Open Weather Map
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

# Temperatura actual

$kelvin = "273.15"

[string]$current_temp =  [math]::Round($meteo.main.temp - $kelvin)
$current_temp = $current_temp + "°C"

# Temperatura mín
[string]$min_temp =  [math]::Round($meteo.main.temp_min - $kelvin)
$min_temp = $min_temp + "°C"

# Temperatura máx
[string]$max_temp =  [math]::Round($meteo.main.temp_max - $kelvin)
$max_temp = $max_temp + "°C"

# Humedad
[string]$humidity = $meteo.main.humidity
$humidity = $humidity   + "%"

# Presión
[string]$pressure = $meteo.main.pressure 
$pressure = $pressure  + "hPa"

# Visibilidad
[string]$visibility = [math]::Round($meteo.visibility /1000)
$visibility = $visibility  + "Km"

# Nombre de la ciudad
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

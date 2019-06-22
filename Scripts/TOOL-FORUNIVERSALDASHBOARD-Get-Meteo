
function Get-Meteo {
<#
.SYNOPSIS
Get basic meteo information on a city in the world.
.DESCRIPTION
This script use the API https://openweathermap.org/api. You have to open a free account and get an APPID.
Developed for use with Universal Dashboard.
.PARAMETER City
Enter the name of the city you want and get the meteo information
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>
param([string]$City)

# ID provided by https://openweathermap.org/api
$api_id = "8d409c0358df4b499c119399999f2561"

# query the api
$query = "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=$api_id"

$meteo = try{Invoke-RestMethod $query -ErrorAction Stop}catch{$message = "City not found";Write-host $message;break}

# Current temp
[string]$current_temp =  [math]::Round($meteo.main.temp /10)
$current_temp = $current_temp + "°C"

# Min temp
[string]$min_temp =  [math]::Round($meteo.main.temp_min /10)
$min_temp = $min_temp + "°C"

# Max temp
[string]$max_temp =  [math]::Round($meteo.main.temp_max /10)
$max_temp = $max_temp + "°C"

# Humidity
[string]$humidity = $meteo.main.humidity
$humidity = $humidity   + "%"

# Pressure
[string]$pressure = $meteo.main.pressure /10
$pressure = $pressure  + "kPa"

# Visibility
[string]$visibility = [math]::Round($meteo.visibility /1000)
$visibility = $visibility  + "Km"

# City name
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

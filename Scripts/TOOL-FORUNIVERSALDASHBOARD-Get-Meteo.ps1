function Get-Meteo {
<#
.SYNOPSIS
Get basic meteo information on a city in the world.
.DESCRIPTION
This script use the API https://openweathermap.org/api. You have to open a free account and get an APPID.
Developed for use with Universal Dashboard.
.PARAMETER City
Enter the name of the city you want and get the meteo information
.EXAMPLE
Get-Meteo -City "montreal" -ApiKey "8d409c0358df4b499c11931e717f2561"
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



# API URL
$query = "http://api.openweathermap.org/data/2.5/weather?q=Shipshaw&APPID=8d409c0358df4b499c11931e717f2561"

# Query Open Weather Map
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

# Current temp

$kelvin = "273.15"

[string]$current_temp =  [math]::Round($meteo.main.temp - $kelvin)
$current_temp = $current_temp + "°C"

# Min temp
[string]$min_temp =  [math]::Round($meteo.main.temp_min - $kelvin)
$min_temp = $min_temp + "°C"

# Max temp
[string]$max_temp =  [math]::Round($meteo.main.temp_max - $kelvin)
$max_temp = $max_temp + "°C"

# Humidity
[string]$humidity = $meteo.main.humidity
$humidity = $humidity   + "%"

# Pressure
[string]$pressure = $meteo.main.pressure 
$pressure = $pressure  + "hPa"

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

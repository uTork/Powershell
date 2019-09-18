# SERVER ping script
# Sébastien Maltais
# sebastien_maltais@hotmail.com

# importation des listes de serveurs DH et Controlleur de domaine
$DH_liste = import-csv -Path "C:\ps\dh.txt" | sort-object name
$DR_liste = import-csv -Path "C:\ps\dc.txt" | sort-object name

# Couleur HTML
$fail_color = 'bgcolor="#FF0000"'
$success_color = 'bgcolor="#009933"'

# Nombre de count dans la sequence de ping
$ping_count = 4

# Création de la page HTML
$html_page = "<html>"
$html_page += "<body>"
$html_page += "<h2>Alerte | Ping | Dash Server | Controlleur de domaine</h2>"
$html_page += "</br>"
$html_page += '<table style="width:auto" border="1">'
$html_page += "<tr><td>DH Server Name</td><td>IP Address</td><td>DNS Ping Test</td><td>IP Address Ping Test</td></tr>"

# Traitement des serveur DH avec le ping DNS et IP
$DH_liste | foreach{

                        $IP = $_.ip
                        $DH = $_.name

                        $ping_ip = Test-Connection -ComputerName $IP -Count $ping_count -Quiet
                        $ping_name = Test-Connection -ComputerName $DH -Count $ping_count -Quiet
                        
                        if($ping_ip -eq $true -and $ping_name -eq $true){

                                                                        $html_page += "<tr><td $success_color>$DH</td><td $success_color>$IP</td><td $success_color>$ping_name</td><td $success_color>$ping_ip</td></tr>"

                                                                        }
                                                                    Else{

                                                                         $html_page += "<tr><td $fail_color>$DH</td><td $fail_color>$IP</td><td $fail_color>$ping_name</td><td $fail_color>$ping_ip</td></tr>"

                                                                         }


                   }
                    
$html_page += "</table>"
$html_page += "<hr>"
$html_page += "</br>"
$html_page += '<table style="width:auto" Border="1">'
$html_page += "<tr><td>DC Name</td><td>IP Address</td><td>DNS Ping Test</td><td>IP Address Ping Test</td></tr>"

# Traitement des serveurs controlleur de domaine avec le ping DNS et IP
$DR_liste | foreach{

                        $IP = $_.ip
                        $DC = $_.name

                        $ping_ip = Test-Connection -ComputerName $IP -Count $ping_count -Quiet
                        $ping_name = Test-Connection -ComputerName $DC -Count $ping_count -Quiet
                        
                        if($ping_ip -eq $true -and $ping_name -eq $true){

                                                                        $html_page += "<tr><td $success_color>$DC</td><td $success_color>$IP</td><td $success_color>$ping_name</td><td $success_color>$ping_ip</td></tr>"

                                                                        }
                                                                    Else{

                                                                         $html_page += "<tr><td $fail_color>$DC</td><td $fail_color>$IP</td><td $fail_color>$ping_name</td><td $fail_color>$ping_ip</td></tr>"

                                                                         }
                   }


$html_page += "</br>"
$html_page += "</body>"
$html_page += "</html>"


# Envoie du courriel par le serveur SMTP anonyme
$date_subjet = get-date

$server = "10.0.0.1"
$port = "25"
$recipient = "sebastien.maltais@Itruit.org"
$sender = "ALERTE_PING@itruit"
$subject = "Server Ping Report - $date_subjet"

Send-MailMessage -Body $html_page -Encoding UTF8 -From $sender -To $recipient -Subject $subject -SmtpServer $server -Port $port -BodyAsHtml

# Script de redémarrage des controleurs domaine avec 5 minutes d'intervalle entre chacun
# Le script liste les serveur qui contienne le mot de DC dans leur nom active directory
# Createur : Sébastien Maltais
# LinkedIn : https://www.linkedin.com/in/sebastienmaltais/


# List des controleurs de domaine baser sur la commande AD get-adcomputer
$dc = (get-adcomputer -filter * -Properties * | where-object {$_.name -like "*dc*"}).name

# Redémarrage des serveurs
$dc | foreach{
              $name = $_
              shutdown /r /f /m \\$name

              # Pause 5 minutes
              Start-Sleep -Seconds 300
              
              }

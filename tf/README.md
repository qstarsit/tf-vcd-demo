# Linux platform - OpenTofu code

[OpenTofu](https://opentofu.org/) wordt gebruikt voor het beheren van Linux servers in VMware vSphere. Het betreft dan de virtuele hardware, de Linux configuratie wordt immers gedaan met [Ansible](../ansible/) (nadat OpenTofu de servers heeft aangemaakt).

Voor het gebruik van OpenTofu heb je de volgende gegevens nodig:

* Je username en password voor vCenter
* je username en [access token](https://gitlab.klant.local/-/user_settings/personal_access_tokens) voor GitLab

## Tofu runnen

* Log met ssh in op de server `ubu-step-01`.
* Clone de git repository, indien nog niet aanwezig in je home directory:
  ``` sh
  git clone git@gitlab.klant.local:systeembeheer/linux-platform.git
  ```
  Indien deze al wel aanwezig is, pull je de laatste wijzigingen:
  ``` sh
  cd linux-platform
  git checkout main
  git pull
  ```
* Ga nu naar de `opentofu` directory in de uitgecheckte repo: `cd ~/linux-platform/opentofu`.
* Kijk met `ls` welke configuraties er zijn en gebruik `cd` om de gewenste configuratie te kiezen.
* Stel de volgende environment variabelen in, zet eventueel een spatie voor ieder `export` commando om te voorkomen dat deze wordt opgeslagen in je shell history:
  ``` sh
  export TF_VAR_vcenter_username="..."   # Vul op de puntjes je vCenter username in
   export TF_VAR_vcenter_password="..."  # vCenter wachtwoord
  export TF_VAR_gitlab_username="..."    # GitLab username
   export TF_VAR_gitlab_token="..."      # GitLab access token
  ```
* Initialiseer OpenTofu: `tofu init`
* Bekijk en controleer de geplande wijzigingen: `tofu plan`
* Voer de wijzigingen uit: `tofu apply`

## Server wijzigen

Soms wil je een server wijzigen, bijvoorbeeld meer capaciteit (cpu, memory, disk) geven. Dergelijke wijzigingen zijn eenvoudig, maar wil je bijvoorbeeld de naam wijzigen, dan zal de server verwijderd en opnieuw uitgerold worden. Het is dus verstandig om altijd goed te controleren wat het effect van de wijziging is.

* Voer de wijziging door in de betreffende `main.tf`.
* Initialiseer OpenTofu: `tofu init`
* Bekijk en controleer de geplande wijzigingen: `tofu plan`
* Voer de wijzigingen uit: `tofu apply`

## Server vervangen

Soms maak je een fout en wil je een server even opnieuw uitrollen. Dat kan, uiteraard krijg je dan wel weer een kale server terug. Dus alle data op de oude server raak je kwijt, tenzij je hier een backup van maakt.

* Bekijk de OpenTofu *state* om te bepalen welke naam OpenTofu gebruikt voor de server:
  ``` sh
  $ tofu state list
  module.ubu-ran-01.data.vsphere_compute_cluster.cluster
  module.ubu-ran-01.data.vsphere_datacenter.datacenter
  module.ubu-ran-01.data.vsphere_datastore.datastore
  module.ubu-ran-01.data.vsphere_network.network
  module.ubu-ran-01.data.vsphere_virtual_machine.template
  module.ubu-ran-01.vsphere_virtual_machine.vm
  module.ubu-step-01.data.vsphere_compute_cluster.cluster
  module.ubu-step-01.data.vsphere_datacenter.datacenter
  module.ubu-step-01.data.vsphere_datastore.datastore
  module.ubu-step-01.data.vsphere_network.network
  module.ubu-step-01.data.vsphere_virtual_machine.template
  module.ubu-step-01.vsphere_virtual_machine.vm
  module.vm_folder.data.vsphere_datacenter.datacenter
  module.vm_folder.vsphere_folder.vm_folder
  ```
* Je ziet in de *state list* dat er per server meerdere objecten bestaan in OpenTofu, ze beginnen allemaal met `module.*<hostname>*`. Die naam (prefix) gebruiken we om de server op te ruimen. In dit voorbeeld gaan we de server `ubu-ran-01` vervangen, dus dit is wat we dan doen:
  ``` sh
  tofu apply -replace=module.ubu-ran-01
  ```
* De server krijgt nu een shutdown (als hij nog aan zou staan), wordt vervolgens uit VMware vSphere verwijderd.
* Nu kunnen we de server opnieuw aanmaken met:
  ``` sh
  tofu apply -target=module.ubu-ran-01
  ```
* Verwijder de host keys uit je SSH configuratie, bijvoorbeeld:
  ``` sh
  ssh-keygen -f ~/.ssh/known_hosts -R 10.56.15.112
  ssh-keygen -f ~/.ssh/known_hosts -R ubu-ran-01
  ```
* Gebruik [Ansible](../ansible/) om de server verder te configureren.

## Server permanent verwijderen

Het verwijderen van een server doen we door de code in OpenTofu te verwijderen en vervolgens de gewijzigde OpenTofu configuratie uit te rollen.

* Verwijder de server uit de betreffende `main.tf`.
* Initialiseer OpenTofu: `tofu init`
* Bekijk en controleer de geplande wijzigingen: `tofu plan`
* Voer de wijzigingen uit: `tofu apply`

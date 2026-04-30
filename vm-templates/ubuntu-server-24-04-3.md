# Ubuntu Server 24.04.3 template

Dit document beschrijft het bouwen van een Ubuntu Server versie 24.04.3 voor VMware vSphere/vCenter. Dit maakt het mogelijk om eenvoudig nieuwe Linux servers uit te rollen.

Voor het bouwen van een image is ervoor gekozen om dit handmatig te doen, omdat dit hooguit eens per jaar gedaan hoeft te worden.

[[TOC]]

## Template aanmaken

1. Eerst downloaden we de benodigde ISO en uploaden deze in VMware vCenter:

* Open een browser en ga naar [https://launchpad.net/ubuntu/+cdmirrors](https://launchpad.net/ubuntu/+cdmirrors).
* Kies een Nederlandse mirror, bijvoorbeeld die van de [NLUUG](https://ftp.nluug.nl/os/Linux/distr/ubuntu-releases/).
* Klik op de map *24.04.3*.
* Download het bestand `ubuntu-24.04.3-live-server-amd64.iso`.
* Log in op [vCenter](https://vcenter.klant.local/).
* Ga naar *Inventory* --> *Datastores* (icoontje).
* Ga naar *DC1-VWMS-05* --> *ISO* --> *UBUNTU*.
* Klik bovenaan op *Upload files*, selecteer de zojuist gedownloade ISO en klik op *Open*.
* Het uploaden kan enige tijd duren.

2. Met deze ISO maken we een nieuwe VM aan in VMware vCenter:

* Ga naar *Inventory* --> *Virtual machines* (icoontje).
* Open de map *Templates*.
* Maak hier een nieuwe virtual machine aan (rechter muisknop op de *Templates* map).
* Kies *Create a new virtual machine* en klik op *Next*.
* Vul de naam van de VM in (*ubu-img-01*) en zorg dat de *Templates* folder is geselecteerd.
* Kies als compute resource de map *Datacenter1*.
* Selecteer een VMFS storage met voldoende capaciteit.
* Kies de meest actuele versie voor compatibility.
* Kies voor Guest OS Family voor *Linux* en Version *Ubuntu Linux (64-bit)*.
* VM configuratie:
  * CPU: 2 cores
  * Memory: 4 GB
  * New Hard Disk: 50GB
  * Disk provisioning: Thick provision lazy zeroed
  * New network: VLAN 15 MANAGEMENT
  * New CD/DVD Drive:
    * Datastore ISO File --> DC1-VWMS-05 --> ISO --> UBUNTU --> ubuntu-server-24.0-4.3-live-server-amd64.iso
    * Connect at power on: vinkje zetten
* Klik op *Finish* om de VM aan te maken.

3. Vervolgens gaan we de VM starten en configureren:

* Start de VM en open de console.
* Kies *Try or Install Ubuntu Server* en wacht tot de installer is opgestart.
* Kies *English* als taal.
* Kies 2x *English (US)*.
* Kies *Ubuntu Server* (niet de *minimized*).
* Configureer het netwerk, IPv4 method *Manual*:
  * Subnet: `10.56.15.0/24`
  * Address: `10.56.15.110`
  * Gateway: `10.56.15.254`
  * Name servers: `10.56.14.71, 10.56.14.72, 10.56.14.73`
  * Search domains: `klant.local, klant.nl`
* Geen proxy server nodig, kies *Done*.
* Nu gaan we LVM configureren, dus kies voor *Custom storage layout*.
  * Free space --> maak hier de volgende GPT file systems aan:
    * /boot, 1G, xfs
    * /boot/efi, 1G, fat32 (wordt automatisch toegevoegd)
    * overige diskruimte, *Leave unformatted* (deze gebruiken we voor LVM)
  * Create LVM volume group: name *root*, devices *partition 3 on /dev/sda*
  * Maak de volgende LVM logical volumes aan:
    * root, 8G, xfs, /
    * home, 2G, xfs, /home
    * var, 4G, xfs, /var
    * varlog, 4G, xfs, /var/log
    * varlogaudit, 10G, xfs, /var/log/audit
    * vartmp, 2G, xfs, /var/tmp
    * tmp, 2G, xfs, /tmp
  * Maak een user aan:
    * Your name: ansible
    * Your servers name: ubu-img-01
    * Pick a username: ansible
    * Password (2x):
  * *Ubuntu Pro* doen we nog even niet.
  * Vinkje bij *Install OpenSSH server*.
  * We installeren geen snaps.
  * De installatie wordt nu uitgevoerd, dit kan een paar minuten duren.

4. Na de installatie start de server opnieuw op. Nu doen we nog enkele aanpassingen:

* Log in op de console met de user `ansible`.
* Zorg dat je root wordt: `sudo su -`
* Zorg dat open-vm-tools en ssh zijn geactiveerd:
  ``` sh
  systemctl enable open-vm-tools
  systemctl enable ssh
  ```
* Verwijder het *machine ID*:
  ``` sh
  truncate -s0 /etc/machine-id
  rm /var/lib/dbus/machine-id
  ```
* Verwijder eventuele *cloud-init* configuratie: `cloud-init clean`
* Ruim de logging op: `rm -rf /var/log/*log /var/log/?tmp /var/log/journal/* `
* Ruim de netwerkconfiguratie op: `rm /etc/netplan/*`
* Ruim je shell history op:
  ``` sh
  truncate -s0 ~/.bash_history
  history -c
  ```
* Zet de machine nu uit: `shutdown -h now`

5. In vCenter moeten we nog even de ISO van de VM afkoppelen:

* Ga in vCenter naar de VM, en dan naar *Edit Settings*.
* Zet CD/DVD drive 1 op *Client Device*.

De template is nu klaar voor gebruik, je kunt nu met OpenTofu Linux servers uitrollen.

> **Opmerking:**
> Converteer de template _niet_ naar een VM template, omdat deze dan niet meegenomen wordt in de backup.

## Template wijzigen

In sommige gevallen wil je de template aanpassen.

* Maak altijd eerst een snapshot van de huidige template.
* Start de template (het is gewoon een VM).
* Log in op de VMware console als user `ansible`, daarna kun je `sudo su -` doen om root te worden.
* De template heeft geen netwerkconfiguratie. Als je netwerk nodig hebt, kun je hiermee het netwerk activeren:
  ``` sh
  ip a add dev ens33 10.56.15.110/24
  ip r add default via 10.56.15.254
  ip link set dev ens33 up
  ping 10.56.15.254  # om te testen of je netwerkconfiguratie werkt
  ```
* Voer nu je wijzigingen uit.
* Verwerk zonodig de wijzigingen ook in bovenstaande instructies om een nieuwe template aan te maken.
* Ben je klaar, dan maken we de template opnieuw schoon:
  * Verwijder het *machine ID*:
    ``` sh
    truncate -s0 /etc/machine-id
    rm /var/lib/dbus/machine-id
    ```
  * Verwijder eventuele *cloud-init* configuratie: `cloud-init clean`
  * Ruim de logging op: `rm -rf /var/log/*log /var/log/?tmp /var/log/journal/* `
  * Ruim de netwerkconfiguratie op: `rm /etc/netplan/*`
  * Ruim je shell history op:
    ``` sh
    truncate -s0 ~/.bash_history
    history -c
    ```
* Zet de machine nu uit: `shutdown -h now`


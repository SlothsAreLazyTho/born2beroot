# Born 2 be root
I hate this subject ;)

**this doc may be incorrect.**
All important notes have been written down in this document. All the other stuff has to be basic knowledge honestly.

I used debian 11.6.0(Bullseye) for this subject. [Click here]("debian-11.6.0-amd64-netinst.iso").
Funny enough all codenames from Debian are from the movie Toy Story. This is because the project leader on the Debian project actually used to work at pixar when they started Debian. [Referral]("https://www.debian.org/doc/manuals/debian-faq/ftparchives#sourceforcodenames")
# Password Policy:
	
Flags for the password policy:
``retry=3 minlen=10 maxrepeat=3 enforce_for_root ucredit=-1 lcredit=-1 dcredit=-1 usercheck=1 difok=7``

### Explaination:
-	minlen => Minimum length for the password
-	retry => Total retries before user failed on password
-	maxrepeat => Amount of characters that cannnot be repeated after each other.
-	enfore_for_root => Enforce the password policy for root.
-	usercheck => Cannot have username in the password
-	difok => Cannot have 7 identical characters from the last password used.

# Firewall
UFW Stands short for ``uncomplicated firewall``. UFW is firewall system to block outgoing and incoming traffic through ports/ip addresses. With this nice system you decide which ports may be used for your service(s).


### Commands:
- ufw enable => Enable firewall
- ufw disable => Disable the firewall
- ufw status => Gain the status on which ports are opened
- ufw allow => Allow ports through the firewall
- ufw delete ``{status}`` ``{port}`` => Removes rules regarding status and port.
	- status:
		- allow
		- reject
		- deny
	- port: Any port.

# Sudo policy

My policy:
```
Defaults	env_reset
Defaults	mail_badpass
Defaults	requiretty
Defaults	badpass_message="Wrong password buddy, Try again!"
Defaults	log_input,log_output
Defaults	iolog_dir="/var/log/sudo"
Defaults	secure_path="/usr/local/sbin:/bin:/snap/bin:..."
```

### Explaination:
- requiretty => Only allow sudo through tty(User logged in through SSH). Not through scripts.
- badpass_message => Display a customized message when sudo password is incorrect.
- log_input => Allow logging input to the ``iolog_dir``
- log_output => Allow logging output to the ``iolog_dir``
- iolog_dir => Log directory for amount of sudo commands being executed
- secure_path => Bin folders for sudo to look for scripts and executables...

# LVM

LVM stands for ``Logical Volume Manager``. It used to compact multiple hard drives to one harddrive.
With ``LVM`` you can create groups on your drive and create several partitions with mounting points to 
paths. For example my layout here maps several groups to points like ``/`` and ``/var/log``

### My layout:
```
NAME                         MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                            8:0    0 30.8G  0 disk
├─sda1                         8:1    0  487M  0 part  /boot
├─sda2                         8:2    0    1K  0 part
└─sda5                         8:5    0 30.3G  0 part
  └─sda5_crypt               254:0    0 30.3G  0 crypt
    ├─intra42--vg-root       254:1    0  9.3G  0 lvm   /
    ├─intra42--vg-swap       254:2    0  2.1G  0 lvm   [SWAP]
    ├─intra42--vg-home       254:3    0  4.7G  0 lvm   /home
    ├─intra42--vg-var        254:4    0  2.8G  0 lvm   /var
    ├─intra42--vg-srv        254:5    0  2.8G  0 lvm   /srv
    ├─intra42--vg-tmp        254:6    0  2.8G  0 lvm   /tmp
    └─intra42--vg-var--log   254:7    0  3.7G  0 lvm   /var/log
sr0                           11:0    1 1024M  0 rom
```

# Hostname:
Set hostname through ``hostnamectl`` to avoid networking errors. This command 
sets the localhost variable to the new hostname automatically (sometimes it doesn't)

### Commands:
- hostnamectl --set-hostname -> To set the hostname
- hostnamectl -> to see transient and updated hostname

# Monitoring script:
[Click here](https://github.com/SlothsAreLazyTho/born2beroot/blob/main/monitoring.sh) to view the script.

# Crontab
If you just started with 42 and read about a crontab bug, that bug doesn't exist anymore
use ``crontab -u {user} -e`` to edit crontab:

- ``user``
  - You're own user that you created on startup
  - root (Preferred for executing commands through sudo).

If you use ``crontab -e`` with sudo. crontab uses the ``root`` user for editing.

# Bonus:

## Wordpress:
  To setup wordpress you will need 5 packages:
  - php7.4-fpm
  - php7.4-cgi
  - php7.4-mysql
  - lighttpd
  - mariadb-server

With the 2 commands you can enable the php modules in lighttpd.
```bash
sudo lighty-enable-mod fastcgi 
sudo lighty-enable-mod fastcgi-php
```

After that has been done you will need to setup your mysql database with the following commands and queries:
```bash
sudo mysql_secure_installation
```

## Extra service:
Just setup peercoin. Its easy to setup and it counts as an extra service.


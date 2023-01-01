#! /bin/bash
# SME Server Setup Script

# FreePBX install https://wiki.koozali.org/FreePBX
yum install smeserver-extrarepositories-asterisk smeserver-extrarepositories-node smeserver-extrarepositories-rpmfusion   -y
db yum_repositories setprop node10 status enabled
db yum_repositories setprop asterisk-common status enabled
db yum_repositories setprop asterisk-13 status enabled
signal-event yum-modify
yum install yum-plugin-versionlock -y
yum versionlock  add freepbx-src-15.* --enablerepo=smetest,smecontribs
yum  install smeserver-freepbx --enablerepo=smecontribs,asterisk-common,asterisk-13,node10,smetest
fwconsole ma upgrade framework
fwconsole ma upgradeall
signal-event freepbx-update
config setprop freepbx PHPVersion 74
expand-template /etc/opt/remi/php74/php-fpm.d/www.conf
expand-template  /etc/httpd/fpbx-conf/httpd.conf
expand-template /opt/remi/php56/root/etc/php-fpm.d/www.conf
systemctl restart php56-php-fpm 
systemctl restart php74-php-fpm
systemctl restart httpd-fpbx
fwconsole versionupgrade --check
fwconsole versionupgrade --upgrade
# this one needs old php56 or you will not be able to update to 16:
/bin/php56 /var/lib/asterisk/bin/fwconsole  ma upgrade framework
fwconsole ma upgradeall
signal-event freepbx-update

# phpLDAPadmin install https://wiki.koozali.org/PhpLDAPadmin
yum --enablerepo=smecontribs install smeserver-phpldapadmin phpldapadmin
# https://[IP or NAME]/phpldapadmin

# Domain Psudonym install https://wiki.koozali.org/Domains
yum install smeserver-domains --enablerepo=smecontribs
yum install smeserver-domains smeserver-userpanel

# Dhcpmanager install https://wiki.koozali.org/Dhcpmanager
yum --enablerepo=smecontribs install smeserver-dhcpmanager
signal-event workgroup-update ; config set  UnsavedChanges no

# Lazy Admin Tools install https://wiki.koozali.org/Lazy_Admin_Tools
yum install --enablerepo=smecontribs smeserver-lazy_admin_tools smeserver-userpanel smeserver-mailsorting
signal-event post-upgrade

# Hardware Info install https://wiki.koozali.org/Hardware_Info
yum --enablerepo=smecontribs install smeserver-hwinfo

# Email Whitelist-Blacklist Control install https://wiki.koozali.org/Email_Whitelist-Blacklist_Control
yum install --enablerepo=smecontribs smeserver-wbl

# Postgresql install https://wiki.koozali.org/Postgresql
yum install smeserver-extrarepositories-pgsql -y
yum --enablerepo=smecontribs,pgsql13 install smeserver-postgresql 
db yum_repositories setprop pgsql13 status enabled
signal-event yum-modify
yum  update smeserver-postgresql --enablerepo=smecontribs

# Autodiscover install https://wiki.koozali.org/Autodiscover
yum --enablerepo=smecontribs install smeserver-autodiscover

# Wireguard install https://wiki.koozali.org/Wireguard
yum --enablerepo=smecontribs install smeserver-wireguard

# Webhosting install https://wiki.koozali.org/Webhosting
yum --enablerepo=smecontribs install smeserver-webhosting

# Diskusage install https://wiki.koozali.org/Diskusage
yum install --enablerepo=smecontribs smeserver-diskusage
signal-event console-save

# Fail2ban install https://wiki.koozali.org/Fail2ban
yum install --enablerepo=smecontribs smeserver-diskusage
signal-event console-save

# HylaFax install https://wiki.koozali.org/HylaFax
yum install smeserver-extrarepositories-epel 
yum --enablerepo=smecontribs,{epel} install smeserver-hylafax
signal-event smeserver-hylafax-update

# Madsonic install https://wiki.koozali.org/Madsonic
yum --enablerepo=smecontribs install smeserver-madsonic

# Mailman install https://wiki.koozali.org/Mailman
yum install smeserver-mailman --enablerepo=smecontribs 

# PXE install https://wiki.koozali.org/PXE
service dhcpd restart
yum --enablerepo=smecontribs install smeserver-pxe

# Dhcp-dns install https://wiki.koozali.org/Dhcp-dns
yum --enablerepo=smecontribs install smeserver-dhcp-dns

# Remoteuseraccess install https://wiki.koozali.org/Remoteuseraccess
yum --enablerepo=smecontribs install smeserver-remoteuseraccess

# Smbstatus install https://wiki.koozali.org/Smbstatus
yum --enablerepo=smecontribs install smeserver-smbstatus

# Vacation install https://wiki.koozali.org/Vacation
yum --enablerepo=smecontribs install smeserver-vacation

# Softethervpn install https://wiki.koozali.org/Softethervpn
yum install smeserver-bridge-interface --enablerepo=smecontribs
yum --enablerepo=smecontribs,smedev install smeserver-softethervpn-server 
config setprop bridge tapInterface tap0,tap_soft
config setprop ExternalInterface MTU 2000 
config setprop InternalInterface MTU 2000
config setprop bridge MTU 2000
service bridge start
expand-template /etc/raddb/users
signal-event remoteaccess-update

# Wsdd install https://wiki.koozali.org/Wsdd
yum install smeserver-wsdd --enablerepo=smecontribs
signal-event post-upgrade; signal-event reboot 

# rhubarb-geek-nz/rhubarb-pi-locales
The rhubarb-pi-locales package is designed to customise the /etc/locale.gen file and then run the configuration program if it has changed.

## Locale Management
UNIX/POSIX systems manage language using locales. Different flavours of operating system manage these differently.

## Debian
The basics of Debian is the /etc/locale.gen file and associated locale-gen program.

```
# vi /etc/locale.gen
# locale-gen
```

This also has a user interface tool

```
# dpkg-reconfigure locales
```

This is a manual process, It is desireable to have an automated process for managing multiple environments in a consistent manner.

The [rhubarb-pi-locales](package.sh) package is designed to customise the /etc/locale.gen file and then run the configuration program if it has changed.

## Centos and Fedora
The locales are managed as packages, for example

```
yum -y install dnf-plugins-core langpacks-de langpacks-es langpacks-fr langpacks-it
```

## Oracle Linux
Version 7 manages the locales with glibc

```
# yum reinstall -y glibc-common
```

Version 8 manages them with packages

```
# yum -y install curl glibc-langpack-en  glibc-langpack-de glibc-langpack-fr glibc-langpack-it glibc-langpack-es 
```

## Arch Linux
This uses the /etc/locale.gen file but its behaviour has been stripped from the Docker images

```
RUN pacman -Sy --noconfirm grep

RUN grep -v NoExtract < /etc/pacman.conf > /etc/pacman.conf.NoExtract && mv /etc/pacman.conf.NoExtract /etc/pacman.conf

RUN echo $'en_US.UTF-8 UTF-8\n\
de_DE.UTF-8 UTF-8\n\
de_DE ISO-8859-1\n\
es_ES.UTF-8 UTF-8\n\
es_ES ISO-8859-1\n\
fr_FR.UTF-8 UTF-8\n\
fr_FR ISO-8859-1\n\
it_IT.UTF-8 UTF-8\n\
it_IT ISO-8859-1' > /etc/locale.gen

RUN pacman -Sy --noconfirm glibc
```

## CBL Marina 2.0
This is stripped down to just en_US. The best option is to configure your /etc/locale-gen.conf and run locale-gen.sh.

You will need to install the glibc-i18n package. Contents of /etc/locale-gen.conf as follows

```
en_US ISO-8859-1
en_US.UTF-8 UTF-8
de_DE ISO-8859-1
de_DE.UTF-8 UTF-8
de_DE@euro ISO-8859-15
en_GB ISO-8859-1
en_GB.ISO-8859-15 ISO-8859-15
en_GB.UTF-8 UTF-8
en_NZ ISO-8859-1
en_NZ.UTF-8 UTF-8
en_US.ISO-8859-15 ISO-8859-15
es_ES ISO-8859-1
es_ES.UTF-8 UTF-8
es_ES@euro ISO-8859-15
fr_FR ISO-8859-1
fr_FR.UTF-8 UTF-8
fr_FR@euro ISO-8859-15
it_IT ISO-8859-1
it_IT.UTF-8 UTF-8
it_IT@euro ISO-8859-15
```

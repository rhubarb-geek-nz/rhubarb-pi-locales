#!/bin/sh -e
#
#  Copyright 2021, Roger Brown
#
#  This file is part of rhubarb pi.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# $Id: package.sh 82 2021-12-04 21:46:54Z rhubarb-geek-nz $
#

cleanup()
{
	rm -rf control.tar.* control data data.tar.* debian-binary 
}

cleanup

trap cleanup 0

SVNVER=$(echo $( svn log -q "$0" | grep -v "\-----------" | wc -l)-1 | bc)
VERSION="1.0.$SVNVER"
DPKGARCH=all
DEPENDS="locales"
APPNAME=rhubarb-pi-locales

mkdir control data

(
	cat << EOF
#!/bin/sh -e

test -f "/etc/locale.gen"

(
	umask 222

	(
		while read A
		do
			if test -n "\$A"
			then
				LANGCODE=\$(
					echo "\$A" | while read B C
					do
						if test "\$B" = "#"
						then
							echo "\$C"
						else
							echo "\$A"
						fi
					done
				)

				case "\$LANGCODE" in 
					de_DE* | en_NZ* | en_GB* | en_US* |  es_ES* | fr_FR* | it_IT* )
						echo "\$LANGCODE"
						;;
					* )
						echo "# \$LANGCODE"
						;;
				esac
			else
				echo
			fi

		done < "/etc/locale.gen"
	) > "/etc/locale.gen.tmp"
)

if diff "/etc/locale.gen" "/etc/locale.gen.tmp" --brief >/dev/null
then
	rm "/etc/locale.gen.tmp"
else
	mv "/etc/locale.gen.tmp" "/etc/locale.gen" 
	locale-gen
fi
EOF
) > control/postinst


chmod +x control/postinst

PACKAGE_NAME="$APPNAME"_"$VERSION"_"$DPKGARCH".deb

(
	cat <<EOF
Package: $APPNAME
Version: $VERSION
Architecture: $DPKGARCH
Maintainer: rhubarb-geek-nz@users.sourceforge.net
Section: devel
Priority: extra
Depends: $DEPENDS
Description: Set up locales
EOF
) > control/control

cat control/control

for d in control data
do
	(
		set -e
		cd $d
		if test -f control
		then
			tar --owner=0 --group=0 --create --gzip --file ../$d.tar.gz control postinst
		else
			tar --owner=0 --group=0 --create --gzip --file ../$d.tar.gz .
		fi
	)
done

rm -rf "$PACKAGE_NAME"

echo "2.0" >debian-binary

ar r "$PACKAGE_NAME" debian-binary control.tar.* data.tar.*

ar p "$PACKAGE_NAME" data.tar.* | tar tvfz -

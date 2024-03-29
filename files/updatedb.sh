#!/bin/bash

update_db() {
	local src=$1
	local dst=$2

	while read line ; do
		if [[ -z $(echo "${line}" | sed -re 's/(^#.*|^\w*$)//') ]]; then
			echo "${line}" >> "${dst}"
		fi

		id=$(echo "${line}" | grep -o '"[^"]*"')

		grep "${id}" "${dst}" 2>&1 >/dev/null || echo "${line}" >> "${dst}"
	done < "${src}"
}

die() {
	echo "$*"
	exit 1
}

wget http://download.savannah.nongnu.org/releases/hddtemp/hddtemp.db -O hddtemp.db -q || die "Failed to download new hddtemp.db file"

# Try to get the Gentoo HDD DB from WebCVS.  If that fails, just use the Gentoo HDD database
# that was installed by the ebuild.
if wget https://gitweb.gentoo.org/repo/gentoo.git/plain/app-admin/hddtemp/files/hddgentoo.db -O hddtmp.db -q; then
	mv -f hddtmp.db hddgentoo.db
fi

update_db "hddgentoo.db" "hddtemp.db"

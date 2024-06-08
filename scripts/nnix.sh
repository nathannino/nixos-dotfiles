#!/bin/sh

# deal with backups

f_badgit() {
	echo "${BUILD_DATE}" > "${FLAKE}/badgit"
}

f_askhmbak() {
	echo "Theses home-manager backup files will be deleted :"
	find ~ -name \*.hmbak -type f
}

f_delhmbak() {
	while true; do
		f_askhmbak
		#TODO : Break if no hmbak found
		read -rp $'Do you want to continue? (y/n)\n> ' yn
		case $yn in
			[Yy]* ) echo "ok"; break;;
			[Nn]* ) exit;;
			* ) echo "invalid anwser";
		esac
	done
	find ~ -name \*.hmbak -type f -delete
}

#f_getdiff() {
#	nixos-rebuild build --flake "${FLAKE}" && nvd diff /run/current-system result
#	unlink result
#}

f_nh() {
	nh os "${CHOSEN_COMMAND}"
}

BUILD_DATE=null
f_setdate() {
	BUILD_DATE="$(date '+%Y-%m-%d|%H:%M:%S')"
}

DONTCOMMIT=""
f_git() {
	cd "${FLAKE}"
	git add .
	git diff-index --quiet HEAD && DONTCOMMIT="y" || git commit -m "${CHOSEN_COMMAND} (Failed) - ${BUILD_DATE}"
	cd -
}


f_main() {
	f_setdate
	f_badgit
	#TODO : Don't run if dry-activate
	if [[ "${CHOSEN_COMMAND}" = "dry-activate" ]]; then
		f_git # TODO : wtf can we somehow trick nix into thinking this isn't dirty? I don't want to commit every dry-activate
		sudo nixos-rebuild dry-activate --flake "${FLAKE}"
		exit 0;
	fi
	cd "${FLAKE}"
	f_delhmbak
	cd -
	f_git # TODO : Still would like to have this at the end instead tbh... maybe we can delete the commit or annotate it if f_nh failed?
	#f_getdiff
	if [[ "${CHOSEN_COMMAND}" = "test" ]]; then
		nh os test
		exit 0;
	fi
	f_nh

	if [[ -z "${DONTCOMMIT}" ]]; then
		cd "${FLAKE}"
		git commit --append -m "${CHOSEN_COMMAND} (Success) - ${BUILD_DATE}"
		cd -
	else
		echo "Nothing added, not automatically commiting"
	fi
	exit 0;
}

# Runtime (not the right term, but I don't care enough to google the right term lol)

SUPPORTED_COMMANDS=('switch' 'boot' 'test' 'dry-activate')
CHOSEN_COMMAND="$1"


for i in "${SUPPORTED_COMMANDS[@]}"; do
	if [[ "${i}" = "${CHOSEN_COMMAND}" ]]; then
		f_main
	fi
done

echo 'Invalid command. List of supported commands : switch | boot | test | dry-activate'
exit 1;

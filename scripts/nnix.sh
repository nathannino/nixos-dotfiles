#!/bin/sh

# deal with backups

f_askhmbak() {
	echo "Theses home-manager backup files will be deleted :"
	find ~ -name \*.hmbak -type f
}

f_delhmbak() {
	while true; do
		f_askhmbak
		#TODO : Break if no hmbak found
		read -p $'Do you want to continue? (y/n)\n> ' yn
		case $yn in
			[Yy]* ) echo "ok"; break;;
			[Nn]* ) exit;;
			* ) echo "invalid anwser";
		esac
	done
	find ~ -name \*.hmbak -type f -delete
}

f_getdiff() {
	nixos-rebuild build --flake "${FLAKE}" && nvd diff /run/current-system result
	unlink result
}

f_nh() {
	nh os "${CHOSEN_COMMAND}"
}

BUILD_DATE=null
f_setdate() {
	BUILD_DATE="$(date '+%Y-%m-%d|%H:%M:%S')"
}

f_git() {
	cd "${FLAKE}"
	git add .
	git commit -m "${CHOSEN_COMMAND} - ${BUILD_DATE}"
	cd -
}


f_main() {
	#TODO : Don't run if dry-activate
	if [[ $CHOSEN_COMMAND = "dry-activate" ]]; then
		sudo nixos-rebuild dry-activate --flake "${FLAKE}"
		exit 0;
	fi
	f_delhmbak
	#f_getdiff
	if [[ $CHOSEN_COMMAND = "test" ]]; then
		nh os test
		exit 0;
	fi
	f_setdate
	f_nh
	f_git
}

# Runtime (not the right term, but I don't care enough to google the right term lol)

SUPPORTED_COMMANDS=('switch' 'boot' 'test' 'dry-activate')
CHOSEN_COMMAND="$1"


for i in ${SUPPORTED_COMMANDS[@]}; do
	if [[ $i = $CHOSEN_COMMAND ]]; then
		f_main
	fi
done

echo 'Invalid command. List of supported commands : switch | boot | test | dry-activate'
exit 1;

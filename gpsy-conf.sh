#!/bin/bash
install () {
	DIST_ASSETS="$(pwd)"
	cp -r $DIST_ASSETS/usr /
	[ ! -e $HOME/.ssh/rc ] && cp rc $HOME/.ssh/
}

uninstall () {
	ISGPSY=`which gpsy >> /dev/null; echo $?`
	if [[ "$ISGPSY" == "0" ]]; then
		rm -rf /usr/local/scr-profiles
		rm `which gpsy`
	else
		echo "gpsy is not currenltly installed"
	fi
}

case $1 in
	install)
		install
		;;
	uninstall)
		uninstall
		;;
	*)
		echo "$0 install|uninstall"
		;;
esac

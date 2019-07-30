#!/bin/bash

USER=`whoami`
SCREEN="/usr/bin/screen"
SCREENDIR="/home/$USER/.screen"

function scr () {
	PASS_SET=`grep -q password $SCREENDIR/secure; echo $?`
	if [[ $PASS_SET -eq 0 ]]; then
		DEFSEC=Y
	else
		DEFSEC=N
	fi
	
	file=$1
	name=$USER"_"$file
	case $1 in
		secure)
			$SCREEN -S $name -c $SCREENDIR/$file
			;;
		sftp)
			$SCREEN -S $name -c $SCREENDIR/$file
			;;
		extra)
			$SCREEN -S $name -c $SCREENDIR/$file
			;;
		nopass)
			$SCREEN -S $name -c $SCREENDIR/$file
			;;
		add)
			_addscr $2
			;;
		del)
			_delscr $2
			;;
		help)
			if [ $2 ]; then
				grep "^##" $SCREENDIR/$2 | sed -e 's/^##/#/'
			else
				printhelp
			fi
			;;
		set-default)
			if [ $2 ]; then
				if [ -e $SCREENDIR/$2 ]; then
					if [ -e $SCREENDIR/default ]; then
						unlink $SCREENDIR/default	
					fi
					ln -s $SCREENDIR/$2 $SCREENDIR/default
				else
					echo "Cannot find configuration $2"
				fi
			fi
			;;
		unset-default)
			if [ -e $SCREENDIR/default ]; then
				unlink $SCREENDIR/default
			fi
			;;
		list)
			_listall
			;;
		clean)
			_killscr
			;;
		kill)
			_killscr $2
			;;
		show)
			$SCREEN -ls
			;;
		join)
			$SCREEN -x $2
			;;
		*)
			if [ -e $SCREENDIR/default ]; then
				$SCREEN -S $USER"_default" -c $SCREENDIR/default
			else
				$SCREEN $@
			fi
			;;
	esac
}

function _addscr () {
	name=$1
	if [ -z $name ]; then echo "No configuration supplied" && exit 1; fi

	file=$SCREENDIR/$name
	if [ -e $file ]; then
		newstring="\\\t\t$name\)\n\t\t\t\$SCREEN \-S \$name \-c \$SCREENDIR\/\$file\n\t\t\t;;"
		sed -i "24i $newstring" $SCREENDIR/scr_function.sh
	else
		echo "Supplied configuration not found"
		exit 1
	fi

	source ~/.bashrc
}

function _delscr () {
	name=$1
	if [ -z $1 ]; then echo "No configuration supplied" && exit 1; fi
	var=$(_contains $1)
	if ["$var" != "0" ]; then
	       sed -i '/$1/+2d'	$SCREENDIR/scr_function.sh
	else
		echo "Cannot remove the configuration option"
		exit 1
	fi
}

function _contains () {
	permargs="add del help secure nopass"
	[[ $permargs =~ (^|[[:space:]])"$1"($|[[:space:]]) ]] && echo 0 | echo 1
	return $var
}

function _listall () {
	echo "available screens:"
	default=`ls -al $SCREENDIR | grep default | awk -F/ '{print $NF}' | sed -e 's/\n//'`
	for x in `grep -B1 '\$SCREEN -S \$name -c \$SCREENDIR/\$file' $SCREENDIR/scr_function.sh | grep \) | sed -e "s/)//" -e "s/^\s\+//"`; do
		if [[ "$x" == "$default" ]]; then
			echo "$x -- default"
		else
			echo $x
		fi
	done
}

function _killscr () {
	if [ $1 ]; then
		$SCREEN kill $1
	else
		for x in `$SCREEN -ls | grep '\.' | grep -v '\.$'`; do
			$SCREEN kill $(echo $x | awk -F'.' '{print $1}' | grep -vi det)
		done
	fi
}

function printhelp() {
	message="
	Screen Configuration Run Utility: scr

	Drew Foulks

	About:

		The Screen Configuration Run Utility (scr for short), is a frontend utility designed to manage multiple screen configurations for bash's screen. screenrc files to be managed by this utility should be located in ~/.screen along with this script.

	Usage:
		Print General Help:
			scr help

		Print screenrc comments:
			scr help <config name>

		Add a new screen config:
			scr add <config name>
			NOTE:

			scr does not recognize screenrc configurations outside of the ~/.screen directory

			scr does not support the addition of screenrc files symbolically linked to the ~/.screen directory.


		Removing a screen config:
			scr del <config name>

			NOTE:

			scr will unregister the configuration from the scr function making it inaccessible, but will NOT delete the file.

		Listing Available screen configurations:
			scr list

			NOTE:

			This will only list the screen configurations available to the scr function.

		Setting and Unsetting the default screen configuration:

			scr set-default <config name>

			NOTE: This will enable a particular config to be invoked with no option i.e. 'scr'

			scr unset-default

			NOTE: the unset-default command requires no arguments.
		
		Cleaning up old screen sessions:

			scr clean
			
			NOTE: Kills the all local screen session

	Useful scr commands
		Listing open screen sessions:
	
			scr -ls 

		Joining an open screen session:

			scr -x <session name>

"
echo "$message"
}




















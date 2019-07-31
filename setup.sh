#!/bin/bash
INSTALLED=`dpkg-query --status screen > /dev/null 2>&1 && echo $?`
if [[ "$INSTALLED" == "1" ]]; then
	echo "Screen is not installed, exiting"
	exit 1
fi

echo "Setting up SCR for GNU Screen..."

# Place the screen directory in the appropriate location
echo "Placing artifacts in ~/.screen."
cp -r ./screen $HOME/.screen


# Source the scr_functions file
echo "Adding screen functions to ~/.bashrc."
echo "source ~/.screen/scr_function.sh" >> $HOME/.bashrc

# Allow ssh agent forwarding through screen tabs
echo "Enabling SSH agent forwarding."
echo -e "if test \"\$SSH_AUTH_SOCK\" ; then\n    ln -sf \$SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock\nfi" >> $HOME/.ssh/rc

# Be done!
echo "scr is now configured."
echo "To view the scr documentation, run: "
echo "    scr help"

# Gnu screen Profile SYstem (gpsy)

Gnu screen Profile Sysetem or gpsy is a wrapper for GNU Screen that comes prepackaged with several screenrc configurations (profiles) ready to go.

## Setting Up

Use gpsy-conf.sh script to either 'install' or 'uninstall' gpsy.

### Install Locations

Default install location: 		/usr/local/bin/gpsy
Default screenrc profile location: 	/usr/local/gpsy

gpsy-conf.sh install will also place the file 'rc' into ~/.ssh/ if it is not already present. this will allow gpsy to forward your ssh-agent through to
any screen session started. 

## Usage Notes

### Documentation

#### Print General Help:
	gpsy help

#### Print profile specific documentation:
	gpsy help <profile>

#### Add a new screen config:
	gpsy add <profile>

	Caveats:
		- gpsy does not recognize profile configurations outside of the /usr/local/scr-profiles directory
		- gpsy does not support the addition of screenrc files symbolically linked to the /usr/local/scr-profiles directory.

#### Removing a screen config:
	gpsy del <profile>

	NOTE:
		- gpsy will unregister the configuration, making it inaccessible, but will NOT delete the file.

#### Listing Available screen configurations:
	gpsy list

	NOTE:

		- This will only list the available profile configurations.

#### Setting and Unsetting the default screen configuration:

	gpsy set-default <profile>

		NOTE: This will enable a particular config to be invoked with no option.

	gpsy unset-default


#### Cleaning up old screen sessions:

	gpsy clean

#### Listing currently available sessions:

	gpsy show

#### Joining an available session:

	gpsy join <session-id>


### Password Protecting a screen configuration
This leverages the GNU screen password command
to invoke: ctrl + A, :password

When prompted enter your password, and again for verification.
the password will be automatically copied into your buffer.

Open the screenrc file you wish to secure and add the following
password 

on the same line as password ctrl + A, ctrl + ]



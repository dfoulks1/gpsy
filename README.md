# Gnu Screen Manager (wrapper)

the GNU Screen Manager is a wrapper that manages multiple .screenrc files.

## Setting Up
1. Link the screen_manager/screen directory to ~/.screen
2. Add the following lines to your .bashrc:
  - source ~/.screen/scr_function.sh
  - if test "$SSH_AUTH_SOCK" ; then
      ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
    fi
3. Source the updated ~/.bashrc file

'scr' should now be ready to use

## Usage Notes

### Documentation

run 'scr help' for information

### Screenrc Management

any valid screenrc file places in the ~/.screen directory may be used by scr

#### Adding new configurations:
- ensure that the VALID screenrc file has a unique, simple name. this will be used as its tag
- run scr add <newfile>

the new screenrc should now be available for use

#### Removing old configurations:
- run scr del <oldfile>

the old screenrc file should no longer be known to scr

#### Securing a configuration
This leverages the GNU screen password command
to invoke: ctrl + A, :password

When prompted enter your password, and again for verification.
the password will be automatically copied into your buffer.

Open the screenrc file you wish to secure and add the following
password 

on the same line as password ctrl + A, ctrl + ]

 

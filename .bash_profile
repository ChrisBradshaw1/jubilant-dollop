# Copyright (c) 2013 by Ensoft Ltd
# All rights reserved.

# This is a copy of a version controlled file stored in a BZR repository at
# bzr+ssh://ensoft-linux3/var/repo/helper-scripts

# .bash_profile 
#
# This file is run whenever you log in to a new machine, but not if you open 
# a new session on a machine you are already logged in to. This file only 
# contains things that should be run on first login such as welcome messages
# etc. It then sources .bashrc for everything else.
#

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
else
    echo "Warning: unable to source .bashrc. You have no settings." 
fi

# Handle ssh_agent creation for new hosts.

[ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
keychain -q ~/.ssh/id_rsa
. ~/.ssh-agent-${HOSTNAME}

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

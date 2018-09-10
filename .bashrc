###############################################################################
# Copyright (c) 2013 by Ensoft Ltd                                            #
# All rights reserved.                                                        #
#                                                                             #
# This file is taken from the template at                                     #
#     /auto/ensoft/sample_files/.bashrc                                       #
# This is in turn a copy of a version controlled file stored at               #
#     bzr+ssh://ensoft-linux3/var/repo/helper-scripts                         #
#                                                                             #
# To use this file copy it to your home directory then check you are happy    # 
# with the default values or change them to suit your preferences             #
#                                                                             #
# Note: New content added to the template will not be picked up by existing   #
#       users. Consider adding it to include.bashrc instead and/or let people #
#       know so they can update their copies.                                 # 
###############################################################################

# Include the server's standard bashrc file since this seems to be convention.
# Do this first so we can overwrite anything in there we don't want.
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Include the standard ensoft .bashrc definitions
if [ -f /auto/ensoft/etc/ensoft-full.bashrc ]; then
    . /auto/ensoft/etc/ensoft-full.bashrc
else
   # In some circumstances this may not be available (e.g. within an EnXR 
   # session). In that case the path is already inherited from the parent
   # session so define a no-op version of pathmunge so it doesn't complain
   # about not finding it if it is used later on in this file.
   alias pathmunge="#pathmunge"
fi

# Add any extra locations of programs you use to your path using the 
# pathmunge function, which adds the location to the start or the end 
# only if it isn't already present:
#     pathmunge <location> [after]
# If you find yourself adding paths here it's a good idea to document why
# e.g. Personal tools
#pathmunge /users/$USER/bin 
pathmunge ~joseprob/.local/bin

# Default editor
# This controls what many commands use when they need a text editor. 
# Suggested values are
#  - vim
#  - nano
editor=vim
export EDITOR=$editor
export VISUAL=$editor

# Endroid Remote
# See http://enwiki.cisco.com/EnDroid/Remote for instructions for generating
# a key if you wish to use endroid remote.
export ENDROID_REMOTE_KEY="@@@"
export ENDROID_REMOTE_USER=$USER@cisco.com
export ENDROID_REMOTE_URL=http://endroid.cisco.com/remote/


###############################################################################
# Prompt                                                                      #
###############################################################################

# Set the format of and the information contained in your prompt using the
# following values separated by your choice of punctuation etc. It is 
# traditional, but by no means universal to end with a '$ '
#       \u = username
#       \h = hostname
#       \t = time
#       \w = working directory (full path)
#       \W = working directory (current directory only)
#       $(prompt_cc_view) = ios view name
#
# Colours can be changed using the values defined in the ensoft .bashrc e.g.
#       \[$RED\]<text>\[$RESET\]
#
# Examples:
# 1. user@server directory$
export PS1="\[\033]0;\u@\h\007\][\u@\h \W]\$ " 
# 2. Just the server you are working on 
#export PS1="\h$ "
# 3. Include IOS view in pretty colours
#export PS1="\[$LIGHT_RED\]\h:\[$CYAN\]$(prompt_cc_view)\[$LIGHT_RED\]\W\[$RESET\]$ " 

###############################################################################
# XR                                                                          #
###############################################################################

# Uncomment this line to have llaunch automatically spawn sessions using screen
export IOX_XTERM=screen

alias rmcores='rm tgt-linux/hosts/*/*/tmp/*.core'
alias lcku='lcleanup --killprocs && lcleanup --unmount && lcleanup --mqueues'

export PRINTER=ensoft-fire-top
alias enscript='enscript -G2r -P $PRINTER'
alias ljam='ljam -j8'
alias efr='/auto/mssbu-swtools/iox/bin/my_ws_efr'
alias rwdiff='git difftool -x "diff -c" -y'
alias ads='ssh chbradsh-sjc-ads'
alias baggrep='extgrep bag'
alias bgengrep='extgrep bgen'
alias cc_unpatch='cc_patch -p_opts "-R"'
alias cgrep='extgrep c'
alias chgrep='extgrep [ch]'
alias cmdgrep='extgrep cmd'
alias co='cc_co -nc -f'
alias compgrep='gengrep "comp-mdata.pl"'
alias cpm='scp enxr-router-spirit-64.vm chbradsh-laas:/nobackup/chbradsh/moonshine/enxr-router-spirit-64.vm-bgp'
alias crusty='ssh crusty-ucs'
alias ct='cleartool'
alias efr='/auto/mssbu-swtools/iox/bin/my_ws_efr'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gc='git commit -a'
alias gg='git graph'
alias gp='git push'
alias grep='grep --color=auto'
alias gs='git status'
alias hgrep='extgrep h'
alias ios_cstatic='/auto/ses/bin/static_iosbranch -coverity'
alias jamfilegrep='gengrep "Jamfile"'
alias jamgrep='extgrep jam'
alias l.='ls -d .* --color=auto'
alias la='ls -a'
alias laas='ssh chbradsh-laas'
alias lb='lboot -m'
alias lj='ljam -j12'
alias ljm='ljam -j12 enxr-router-spirit-64.vm'
alias ll='ls -l'
alias ls='ls -CF --color=auto'
alias mc='. /usr/libexec/mc/mc-wrapper.sh'
alias mc1='moonshine container-connect --router-name moonshine1 --nodeid 0/0/CPU0 --issuid '
alias mc2='moonshine container-connect --router-name moonshine2 --nodeid 0/0/CPU0 --issuid '
alias mc3='moonshine container-connect --router-name moonshine3 --nodeid 0/0/CPU0 --issuid '
alias ml='moonshine launch --v1image enxr-router-spirit-64.vm --topo '
alias mli='moonshine launch --v1image enxr-router-spirit-64.vm --v2image enxr-router-spirit-64.vm --topo '
alias msggrep='extgrep msg'
alias perlll='eval `perl -Mlocal::lib`'
alias pico='pico -w'
alias precom='/auto/firex-ott/bin/precommit submit -d '
alias reggrep='extgrep reg'
alias rmview='cc_rmview -view'
alias run_sa='/auto/ses/bin/run_sa'
alias sb='source ~/.bashrc'
alias schgrep='extgrep sch'
alias smoke_sanity='/auto/xrut/xrut-gold/enxr-xrut-combo.py'
alias vb='vim ~/.bashrc'
alias vi='vim'
alias vs='vs -graphicssystem native'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
alias wsefr='/users/pastanle/bin/wsefr'
alias x6='xr_bld -plat asr9k-x64'
alias xa='xr_bld -plat asr9k-px'
alias xn='xr_bld -plat ncs6k'
alias xr_bld='/auto/iox/bin/xr_bld'
alias yvett='config/validation/tools/bin/yvett'


# Delete ws
function delete_ws {
    cd $1
    lcleanup --deletews
    cd ..
}

# Go to ws root
wup()
{
    CWD=`pwd`;
    while [ ! -d "$CWD/.ACMEROOT" ] && [ "$CWD" != "/" ]
        do
        CWD=`dirname $CWD`
    done
    if [ ! -d "$CWD/.ACMEROOT" ]
        then
        echo "Not in workspace"
    else
        cd $CWD
    fi
}

# Attach to tmux session
#if [ -z ${TMUX} ]; then
#    tmux a # || tmux
#fi

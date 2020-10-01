
#
# ~/.bashrc
#

# Expand aliases
shopt -s expand_aliases

# Enable history appending instead of overwriting
shopt -s histappend

# Do not store duplicate commands or commands that begin with a space
HISTCONTROL=ignorespace:ignoredups

# Record infinite command history
HISTSIZE= HISTFILESIZE=

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Disable ctrl-s and ctrt-q
stty -ixon

# Use vi mode instead of emac mode
set -o vi

# Add color to terminal and various commands
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias ip='ip -color=auto'
alias ls='ls -AhN --color=auto --group-directories-first'
alias ccat='highlight --out-format=ansi'

# System maintainence
alias regen='sudo reflector --protocol https --country "United States" --sort rate --save /etc/pacman.d/mirrorlist'
alias ug='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mkin='sudo mkinitcpio'
alias sdn='sudo shutdown now'
alias rb='systemctl reboot'

# Account maintenance
alias ga='sudo groupadd'
alias gd='sudo groupdel'
alias gp='sudo gpasswd'

# Systemd shortcuts
alias sc='systemctl'
alias SC='sudo systemctl'
alias jc='sudo journalctl'
alias cdc='sudo coredumpctl'
alias cdo='sudo coredumpctl -1'
alias lc='loginctl'
alias LC='sudo loginctl'

# Pacman and yay
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias up='yay -Su'

# Create shortcuts for common commands
alias mv='mv -v'
alias MV='sudo mv -v'
alias cp='cp -v'
alias CP='sudo cp -v'
alias mkd='mkdir -pv'
alias rmd='rmdir -v'
alias MKD='sudo mkdir -pv'
alias RMD='sudo rmdir -v'
alias rm='rm -v'
alias RM='sudo rm -v'
alias ref='source ~/.bash_profile'
alias refr='clear; source ~/.bash_profile'
alias xref='xrdb ~/.Xresources'
alias SS='sudo ss'
alias st='speaker-test -c 2'
alias bat='acpi --battery'
alias nf='neofetch'
alias nfd='neofetch --disable model resolution de wm wm_theme theme icons term_font cpu gpu memory'
alias pf='pfetch'
alias rn='rename -v'
alias yd='youtube-dl'
alias mnt='sudo mount'
alias umnt='sudo umount'
alias ej='sudo eject'
alias cu='checkupdates'
alias vim='nvim'
alias rwm='ffmpeg -f v4l2 -i /dev/video0 -f alsa -i default -c:v libx264 -preset ultrafast -c:a aac -video_size'
alias rsm='ffmpeg -f x11grab -video_size 1920x1080 -framerate 25 -i $DISPLAY -f alsa -i default -c:v libx264 -preset ultrafast -c:a aac'
alias wb='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'
alias xg='mpv av://x11grab: --profile=low-latency --untimed'
alias xmr='sudo ghc-pkg recache && xmonad --recompile'
alias vns='sudo virsh net-start default'
alias vnd='sudo virsh net-destroy default'
alias g='groff -R -ms -T pdf'
alias z='zathura'

function rfind() {
  if [ "$#" -lt 2 ]; then
    printf "Usage: rfind [directory] [filename regex pattern]\n"
  else
    echo "$(find $1 -regextype posix-extended -regex "$2")"
  fi
}

function rn-g() {
  run=true

  while $run; do
    rename -v $@
    [ "$?" -eq 0 ] && run=true || run=false
  done
}

function getkeysym() {
  [[ "$#" -lt 1 ]] && echo "Usage: getKeySym <keycode>" && return 1

  for code in $@; do
    echo "$(grep -Po "KEY_[A-Z0-9]*(?=\s*$code$)" /usr/include/linux/input-event-codes.h)"
  done

  return 0
}

# Set bash prompt. Captialize username 
if [ "$EUID" -ne 0 ]; then
  if [ "$(tput colors)" -eq 8 ]; then
    export PS1="\[$(printf '\u001b[91m')\][\[$(printf '\u001b[92m')\]\u\[$(printf '\u001b[0;33m')\]@\[$(printf '\u001b[96m')\]\h \[$(printf '\u001b[94;1m')\]\W\[$(printf '\u001b[0m')\]\[$(printf '\u001b[91m')\]]\[$(printf '\u001b[93m')\]\$ \[$(printf '\u001b[0m')\]"
  else
    export PS1="\[$(tput setaf 9)\][\[$(tput setaf 10)\]\u\[$(tput setaf 3)\]@\[$(tput setaf 14)\]\h \[$(tput bold)\]\[$(tput setaf 12)\]\W\[$(tput sgr0)\]\[$(tput setaf 9)\]]\[$(tput setaf 11)\]\$ \[$(tput sgr0)\]"
  fi
fi

# TODO: Set PS1 for root user:
# export PS1="\[$(tput setaf 9)\][\[$(tput setaf 10)\]ROOT@$(hostname | awk '{print toupper($0)}') \[$(tput bold)\]\[$(tput setaf 12)\]\W\[$(tput sgr0)\]\[$(tput setaf 9)\]]\[$(tput setaf 11)\]\$ \[$(tput sgr0)\]"

# Print the command that is being run, ...
echo "pfetch"

# ... run the command on start, ...
# neofetch --disable model resolution de wm wm_theme theme icons term_font cpu gpu memory
pfetch
# ... and print some additional information
# echo " There are $(pacman -Quq | wc -l) packages ready to be upgraded."
# echo


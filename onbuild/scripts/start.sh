#!/bin/sh

if [ -f /etc/skel/initrc ]
then
. /etc/skel/initrc
fi
if [ -f ~/.bashrc ]
then
. ~/.bashrc
fi

exec $*

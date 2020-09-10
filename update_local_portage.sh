#!/bin/sh

update() {
DATA="$(curl -sL $1)"
IS_RC="$(echo $DATA | grep -o "rc[0-9]*\.tar\.gz")"

#echo $IS_RC

if [ -z "$IS_RC" ]
then
VERS_NEW="$(echo $DATA | grep -oP "[0-9][0-9r\-\.]*\.tar\.gz" | uniq | sed -ne 's/\.tar\.gz//p' | tr '-' '.')"
VERS_CURR="$(echo $2 | grep -o "[0-9r\.]*.ebuild" | sed -ne 's/\.ebuild//p')"

#echo $VERS_NEW
#echo $VERS_CURR

if [ "$VERS_NEW" != "$VERS_CURR" ] && [ ! -z "$VERS_NEW" ]
then
NEW_NAME="$(echo $2 | sed -ne "s/[0-9\.]*\.ebuild/$VERS_NEW\.ebuild/p")"

#echo $NEW_NAME

mv -v $2 "$NEW_NAME"
ebuild "$NEW_NAME" manifest

BLUE='\033[1;34m'
RED='\033[0;33m'
echo -e "${RED}updated local ebuild ${BLUE}$NEW_NAME"
fi
fi
}

PORTDIR="/usr/local/portage"

update "http://www.boomerangsworld.de/cms/worker/download.html" "$PORTDIR/app-misc/worker/worker-*.ebuild"
update "https://github.com/moonlight-stream/moonlight-qt/releases/latest" "$PORTDIR/app-misc/moonlight-qt/moonlight-qt-*.ebuild"
update "https://github.com/baldurk/renderdoc/releases/latest" "$PORTDIR/app-misc/renderdoc/renderdoc-*.ebuild"
update "https://github.com/git-cola/git-cola/releases/latest" "$PORTDIR/dev-vcs/git-cola/git-cola-*.ebuild"
update "https://github.com/rust-analyzer/rust-analyzer/releases/latest" "$PORTDIR/app-misc/rust-analyzer/rust-analyzer-*.ebuild"
update "https://github.com/yshui/picom/releases/latest" "$PORTDIR/x11-misc/picom/picom-*.ebuild"

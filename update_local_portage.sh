#!/bin/sh

update() {
DATA="$(curl -sL "$1")"
VERS_NEW="$(echo $DATA | grep -oP "releases/tag/(v)?[0-9][0-9r\-\.]*" | grep -oP "[0-9][0-9r\-\.]*" | uniq | tr '-' '.')"

if [ -z "$VERS_NEW" ]; then
VERS_NEW="$(echo $DATA | grep -oP "worker-[0-9][0-9r\-\.]*[0-9]" | grep -oP "[0-9][0-9r\-\.]*" | uniq | tr '-' '.')"
fi

if [ ! -z "$VERS_NEW" ]; then
VERS_CURR="$(echo $2 | grep -o "[0-9r\.]*.ebuild" | sed -ne 's/\.ebuild//p')"

echo "$VERS_NEW $VERS_CURR"

if [ "$VERS_NEW" != "$VERS_CURR" ] && [ ! -z "$VERS_NEW" ]; then
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

update "http://www.boomerangsworld.de/cms/worker/download.html" "$PORTDIR/app-misc/worker/"worker-*.ebuild
update "https://github.com/moonlight-stream/moonlight-qt/releases/latest" "$PORTDIR/app-misc/moonlight-qt/"moonlight-qt-*.ebuild
update "https://github.com/baldurk/renderdoc/releases/latest" "$PORTDIR/media-gfx/renderdoc/"renderdoc-*.ebuild
update "https://github.com/git-cola/git-cola/releases/latest" "$PORTDIR/dev-vcs/git-cola/"git-cola-*.ebuild
update "https://github.com/mikf/gallery-dl/releases/latest" "$PORTDIR/net-misc/gallery-dl/"gallery-dl-*.ebuild
update "https://github.com/yt-dlp/yt-dlp/releases/latest" "$PORTDIR/net-misc/yt-dlp/"yt-dlp-*.ebuild

#update "https://github.com/yshui/picom/releases/latest" "$PORTDIR/x11-misc/picom/"picom-*.ebuild
#update "https://github.com/doitsujin/dxvk/releases/latest" "$PORTDIR/app-emulation/dxvk/"dxvk-*.ebuild

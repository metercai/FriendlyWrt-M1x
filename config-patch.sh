#!/bin/bash
set -eu

# remove unnecessary i18n 
CONFIG_01="../configs/rockchip/01-nanopi"
cat ${CONFIG_01} | awk -F"-" '{if ($2!="i18n") print $0; else if ($4!="bg=y" && $4!="ca=y" && $4!="cs=y" && $4!="de=y" && $4!="el=y" && $4!="es=y" && $4!="fr=y" && $4!="he=y" && $4!="hi=y" && $4!="hu=y" && $4!="it=y" && $4!="ja=y" && $4!="ko=y" && $4!="mr=y" && $4!="ms=y" && $4!="pl=y"  && $4!="pt=y" && $4!="pt" && $4!="ro=y" && $4!="ru=y" && $4!="sk=y" && $4!="sv=y" && $4!="tr=y" && $4!="uk=y" && $4!="vi=y" && $5!="tw=y" && $4!="idle") print $0; else if ($3=="hd" && ($5=="en=y" || $6=="cn=y")) print $0; }' > 01.tmp

mv 01.tmp ${CONFIG_01}

rm -f ../configs/rockchip/02-luci_lang

echo "CONFIG_LUCI_LANG_en=y" >> ../configs/rockchip/03-custom
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ../configs/rockchip/03-custom 

# patch go language module
echo "CONFIG_GOLANG_EXTERNAL_BOOTSTRAP_ROOT=\"/usr/lib/go\"" >> ../configs/rockchip/03-custom

# turn on build.log
sed -i 's/make -j$(nproc)/make V=s 2>\&1 \| tee build.log \| grep -i -E \"^make.*(error\|[12345]...Entering dir)\"/g' ../scripts/mk-friendlywrt.sh

echo "config patch ok!"
exit 0

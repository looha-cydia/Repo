#!/bin/sh
rm -rf build
mkdir build
TARGET_DEPS_PATH="./deps"
if [ -d "$TARGET_DEPS_PATH" ];
then
for DEB in "$TARGET_DEPS_PATH/"*
do
echo "============开始==================  deb:$DEB   "
mkdir extract
mkdir extract/DEBIAN

mkdir tempBuild

dpkg -X "$DEB" extract
dpkg -e "$DEB" extract/DEBIAN

DEB_DEBIAN_PATH="./extract/DEBIAN"

if [ -d "$DEB_DEBIAN_PATH" ];
then

for DEBIAN in "$DEB_DEBIAN_PATH/"*
do
chmod 775 "$DEBIAN"
done

fi

DEB_CO="./extract/DEBIAN/control"
PKS=$(sed -n '/Package:/p' $DEB_CO)
PKS_CN=$(sed -n '/Package:/p' $DEB_CO)

if [ "$PKS" != "${PKS/cn/}" ];
then
sed -i '' 's/.cn//g' $DEB_CO
PKS=$(sed -n '/Package:/p' $DEB_CO)
fi

LH_PK_P="Package: com.looha."
LOOHA_PK=""


if [ "$PKS_CN" == "${PKS_CN/./}" ];
then

LAST_PK=${PKS##*: }

echo "LAST_PK=====$LAST_PK"

LOOHA_PK=${LH_PK_P}${LAST_PK}

echo "LOOHA_PK=====$LOOHA_PK"


else

LAST_PK=${PKS##*.}


LOOHA_PK=${LH_PK_P}${LAST_PK}

if [ "$PKS_CN" != "${PKS_CN/.cn/}" ];
then
LH_CH=".cn"
LOOHA_PK_CN_P=$LOOHA_PK
LOOHA_PK=${LOOHA_PK_CN_P}${LH_CH}
fi


fi


sed -i '' "s/$PKS/$LOOHA_PK/g" $DEB_CO


SEC=$(sed -n '/Section:/p' $DEB_CO)
sed -i '' "s/$SEC/Section: looha/g" $DEB_CO


MT=$(sed -n '/Maintainer:/p' $DEB_CO)
sed -i '' "s/$MT/Maintainer: looha/g" $DEB_CO

cd extract
find ./ -name '*.DS_Store' -type f -delete
find ./ -name ".DS_Store" -depth -exec rm {} \;
cd ..


dpkg-deb -b extract/ tempBuild

cd tempBuild
find ./ -name '*.DS_Store' -type f -delete
find ./ -name ".DS_Store" -depth -exec rm {} \;
cd ..


TEMP_B_PATH="./tempBuild"
TEMP_B_FILES=$(ls $TEMP_B_PATH)
T_BULID_DEB_PATH=""

for file in $TEMP_B_FILES
do
echo "xxxxxxxxxxxxx 构建成功：deb:$file xxxxxxxxxxxxxxx"

T_BULID_DEB_PATH=$file
done

if [ -z "$T_BULID_DEB_PATH" ];

then
echo "xxxxxxxxxxxxx 构建失败：deb:$DEB xxxxxxxxxxxxxxx"

else

for i in ` ls tempBuild`
do
if [ -f "./build/$i" ];
then
echo "xxxxxxxxxxx deb包$DEB已存在 xxxxx, New_deb:$i xxxxxxxxxxxxxxx"
else
cp tempBuild/$i build/
echo "√√√√√√√√√√ 构建完成已存储:deb:$DEB √√√ New_deb:$i √√√√√√√√"
fi
done

fi


rm -rf extract
rm -rf tempBuild



echo "=============================================== 结束：deb:$DEB  =============================================================="

done

fi



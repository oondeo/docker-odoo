#!/bin/bash
SRC="$1"
DST="$2"
TMP=$(mktemp -d -t ci-XXXXXXXXXX)
# for req in $(ls -1d /mnt/extra-addons/*/requirements.txt)
# do
#     pip3 install -r $req
# done 

# mkdir -p $DST
cd $TMP 
curl -Lo master.zip "$SRC" || true
mv "$SRC" master.zip || true
unzip master.zip 

if [ -e "__manifest__.py" ]; then
    NAME=${DST##*/}
    mkdir -p $DST/$NAME/
    mv * $DST/$NAME/
else
    mv * $DST
fi
for f in $(ls -1d $DST/*/)
do
    if [ -e "requirements.txt" ]; then
        pip3 install --no-cache-dir -r $f/requirements.txt
    fi
done
chmod -R 775 $DST
chgrp -R 0 $DST
rm -rf ~/.cache/pip && rm -rf /tmp/*

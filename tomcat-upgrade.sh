#!/bin/bash

mkdir -p staging
cd staging
[ -d tomcat ] || git clone https://github.com/HybridProgrammer/tomcat
cd tomcat

if [ $1 == "list" ] ;  then 
	git tag
	exit 0
fi

VERSION=$1
cd $2
DEST=`pwd`
cd -

[ -z "$VERSION" ] && VERSION="v8.5.20"
[ -z "$2" ] && DEST=`pwd`

echo "Fetching ${VERSION} and upgrading ${DEST}"

CUR_BRANCH=`git branch | grep "*" | awk '{print $2}'`
#echo $CUR_BRANCH
if [ $CUR_BRANCH != $VERSION ] ; then
	git checkout -b $VERSION $VERSION
fi
#git pull

echo "Upgrading ${DEST}"
cp -R * $DEST

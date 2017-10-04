#!/bin/bash

VERSION=$1
cd $2
DEST=`pwd`
cd -

[ -z "$VERSION" ] && VERSION="v8.5.20"
[ -z "$2" ] && DEST=`pwd`

mkdir -p staging
cd staging
[ -d tomcat ] || git clone https://github.com/HybridProgrammer/tomcat
cd tomcat

if [[ $1 == "list" ]] ;  then 
	git tag
	exit 0
fi

echo "Fetching ${VERSION} and upgrading ${DEST}"

CUR_BRANCH=`git branch | grep "*" | awk '{print $2}'`
#echo $CUR_BRANCH
if [ $CUR_BRANCH != $VERSION ] ; then
	git checkout -b $VERSION $VERSION
fi
#git pull

cp $DEST/conf/* conf/
cp $DEST/bin/* bin/
git status | grep modified
if [[ $? -eq 0 ]] ; then 
	echo "The following files have been modified by you. Do you want us to merge these file after the upgrade? [n/y]:" 
	read merge_answer

	if [[ $merge_answer == "n" ]] ; then
		echo "Stashing modified files"
		git stash
	fi
fi

echo "Upgrading ${DEST}"
cp -r * $DEST

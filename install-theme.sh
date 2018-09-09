#!/bin/bash

# Expects $1 = theme zip

wpThemes="/var/www/html/wp-content/themes/";

if [ $# -ne 1 ]; then
	echo "Expecting one argument: path to theme zip file"
	exit 0;
fi

if [ ! -f $1 ]; then
	echo "Could not find file $1";
	exit 0;
fi

themeName=$(echo $1 | sed -r 's/(.+\/)?(.+)\.zip/\2/g')

echo "Installing theme $themeName to $wpThemes";

cp $1 $wpThemes

startDir=$(pwd)
cd $wpThemes

operation="installed"
if [ -d $themeName ]; then
	echo "Theme $themeName is already installed. Do you want to:"
	echo "  - replace it    [r]"
	echo "  - overwrite it  [o]"
	echo "  - abort         [a]";
	echo -n "[r/o/a]: "
	read -n 1 "prompt"
	echo ""
	if [ "$prompt" == "r" ]; then
		echo "Deleting theme $themeName";
		rm -rf $themeName 2> /dev/null

		if [ $? -ne 0 ]; then
			echo "Could not delete $themeName. Aborting";
			exit 0;
		fi
		operation="replaced";
	elif [ "$prompt" == "o" ]; then
		echo "Overwriting theme $themeName";
		operation="overwritten"
	elif [ "$prompt" == "a" ]; then
		echo "Aborting";
		exit 0;
	else
		echo "Unrecongized option. Aborting";
		exit 0;
	fi
fi

unzip -u $themeName.zip > /dev/null 2> /dev/null

if [ $? -ne 0 ]; then
	echo "Theme could not be installed - error while inflating zip"
	exit 0;
else
	echo "Successfuly $operation theme $themeName to $wpThemes"
fi

cd $startDir

		
	

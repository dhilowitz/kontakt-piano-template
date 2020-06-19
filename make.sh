#!/bin/bash

BASE_PRODUCT_NAME="PB Piano Template"
PRODUCT_FORMATS=("Kontakt")

set -e

# # Get new tags from the remote
git fetch --tags
 
# # Get the latest tag name
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
 
# Checkout the latest tag
# git clone --branch $latestTag . build/"$PRODUCT_NAME"
git checkout $latestTag

for product_format in "${PRODUCT_FORMATS[@]}"
do
	PRODUCT_NAME="$BASE_PRODUCT_NAME [$product_format]"
	PRODUCT_NAME_UNDERSCORES=${PRODUCT_NAME// /_}
	PRODUCT_NAME_SANITIZED=${PRODUCT_NAME_UNDERSCORES//[^a-zA-Z0-9_\-]/}
   
   	echo "Working on $PRODUCT_NAME"

	if [ "$product_format" == "Kontakt" ]
	then

		rm -rf build/"$PRODUCT_NAME"
		mkdir -p build/"$PRODUCT_NAME"


		rsync -avz --delete src/ build/"$PRODUCT_NAME"/

		cd build
		zip -r $PRODUCT_NAME_SANITIZED-$latestTag.zip "$PRODUCT_NAME"/
		cd ..
	fi

	
done

git checkout master

#!/bin/bash
################################################################################
# Install OCR-D framework including processors, workflow and research data repository
# A subdirectory will contain all ingested files. Due to that be sure 
# that file space is sufficient!
# Usage:
# bash install_OCR-D_framework.sh /path/to/installationdir
################################################################################

# Test for commands used in this script
testForCommands="sed unzip wget docker docker-compose"

for command in $testForCommands
do 
  $command --help >> /dev/null
  if [ $? -ne 0 ]; then
    echo "Error: command '$command' is not installed!"
    exit 1
  fi
done

# Check if argument is given
if [ -z "$1" ]; then
  echo Please provide a directory where to install.
  echo USAGE:
  echo   $0 /path/to/installationdir
  exit 1
fi

INSTALLATION_DIRECTORY=$(echo $1 | sed 's:/*$::')

# Check if directory exists
if [ ! -d "$INSTALLATION_DIRECTORY" ]; then
  # Create directory if it doesn't exists.
  mkdir -p "$INSTALLATION_DIRECTORY"
fi
# Check if directory is empty
if [ ! -z "$(ls -A "$INSTALLATION_DIRECTORY")" ]; then
   echo "Please provide an empty directory or a new directory!"
   exit 1
fi
cd "$INSTALLATION_DIRECTORY"
INSTALLATION_DIRECTORY=`pwd`
REPO_DIR=repository
TAVERNA_DIR=taverna
TMP_DIR=tmp

echo Install Research Data Repository into \"$INSTALLATION_DIRECTORY/repository\"

cd "$INSTALLATION_DIRECTORY"
mkdir $REPO_DIR
mkdir $TAVERNA_DIR
mkdir $TMP_DIR
cd $TMP_DIR
wget https://github.com/OCR-D/repository_metastore/archive/master.zip
unzip master.zip
rm master.zip
cd repository_metastore-master/installDocker


bash installRepo.sh "$INSTALLATION_DIRECTORY"/$REPO_DIR

cd "$INSTALLATION_DIRECTORY"/$REPO_DIR
docker-compose up -d

echo Install workflow and workspace into \"$INSTALLATION_DIRECTORY/$TAVERNA_DIR\"
cd "$INSTALLATION_DIRECTORY"/$TMP_DIR
wget https://raw.githubusercontent.com/OCR-D/taverna_workflow/master/Dockerfile
docker build -t ocrd/taverna .
cd "$INSTALLATION_DIRECTORY"/$TAVERNA_DIR
docker run -v `pwd`:/data ocrd/taverna init


cd "$INSTALLATION_DIRECTORY/$TAVERNA_DIR"


echo SUCCESS
echo Now you can start an OCR-D workflow with the following commands:
echo "cd \"$INSTALLATION_DIRECTORY/$TAVERNA_DIR\""
echo "docker run --network=\"host\" -v `pwd`:/data ocrd/taverna process"

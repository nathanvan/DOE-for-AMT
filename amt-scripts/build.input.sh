#!/bin/bash
# Quick script to build the experiment. 


EXPNAME=$1
if [ -z $EXPNAME ]; then
   echo "usage: build.input.sh <experimentName> <expeirmentNumber>"
   echo "You must specify an experiment name." 
   exit 1
fi

EXPNUM=$2
if [ -z $EXPNUM ]; then
   echo "usage: build.input.sh <experimentName> <expeirmentNumber>"
   echo "You must specify an experiment number." 
   exit 2
fi

DIR=`pwd`

#Check if the input alread exists and prompt the user if we want to overwrite
INPUTCSV=$DIR/$EXPNAME/$EXPNAME-input.csv
if [ -e $INPUTCSV ]; then
	echo "The file $INPUTCSV already exists."
	echo -n "Overwrite (y/N) : "
	read ANS
	if [ "$ANS" = "y" ]; then
		echo "Proceeding. The file will be overwritten."
	else
		echo "Exiting without changes."
		exit 0
	fi
fi


STUDENTLIST=$DIR/$EXPNAME/studentIds.$EXPNAME.txt
RUBRICLIST=$DIR/$EXPNAME/rubricCode.$EXPNAME.txt

if [ ! -e $STUDENTLIST ]
then 
	echo " ERROR :  Required file: $STUDENTLIST missing."
	exit 3
fi
if [ ! -e $RUBRICLIST ]
then 
	echo " ERROR :  Required file: $RUBRICLIST missing."
	exit 4
fi

TEMPFILE=$DIR/$EXPNAME/build.input.$$.tmp
#Loop through the students then rubrics
for studentIds in `cat $STUDENTLIST`; do
	for rubricCode in `cat $RUBRICLIST`; do
		echo -e "\"$studentIds\"\t\"$rubricCode\"\t\"$EXPNUM\"" >> $TEMPFILE 
	done
done
echo -e "\"studentIds\"\t\"rubricCode\"\t\"experimentId\"" > $INPUTCSV
shuf $TEMPFILE >> $INPUTCSV
rm $TEMPFILE
echo "Finished writing out $INPUTCSV"

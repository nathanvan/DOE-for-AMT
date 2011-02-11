#!/bin/bash
# Quick script to remove all the unecessary unecessary files


EXPNAME=$1
if [ -z $EXPNAME ]; then
   echo "usage: cleanExperiment.sh <experimentName>"
   echo "You must specify an experiment name." 
   exit 1
fi

DIR=`pwd`

KEEPLIST="$EXPNAME-reject.csv   $EXPNAME-input.csv   $EXPNAME-properties   $EXPNAME-question"

#Check if the experiment directory exists
if [ -d $DIR/$EXPNAME ]; then
	echo "Do you wish to delete everything in the experiment except for : "
	echo "   $KEEPLIST "
	echo "The current contents of the directory that match $EXPNAME* are : "
	ls -l $DIR/$EXPNAME/$EXPNAME*
	echo -n "Delete everything but the keeplist? (y/N) : "
	read ANS
	if [ "$ANS" = "y" ]; then
		cd $DIR/$EXPNAME
		for fileName in `ls $EXPNAME*`
		do
			KILLFILE='true'
			for keepFile in $KEEPLIST
			do
				if [ "$fileName" == "$keepFile" ]; then
					KILLFILE='false'
				fi
			done
			
			if [ "$KILLFILE" == 'true' ];then
				echo "DELETING   $fileName"
				rm $fileName
			else
				echo "SAVING     $fileName"
			fi 
		done
		cd $DIR
	else
		echo "Exiting without changes."
		exit 0
	fi
else
   echo "Experiment name \"$EXPNAME\" doesn't exist." 
   exit 2
fi


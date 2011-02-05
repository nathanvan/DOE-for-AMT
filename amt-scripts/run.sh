#!/usr/bin/env sh

JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun/jre/  
export JAVA_HOME
EXPNAME=$1
if [ -z $EXPNAME ]; then
   echo "You must specify an experiment name." 
   return 1
fi

DIR=`pwd`

# Check to see if the needed files are around. 
INPUTCSV=$DIR/$EXPNAME/$EXPNAME-input.csv
QUESTION=$DIR/$EXPNAME/$EXPNAME-question
PROPERTIES=$DIR/$EXPNAME/$EXPNAME-properties

if [ ! -e $INPUTCSV ]
then 
	echo " ERROR :  Required file: $INPUTCSV missing."
	return 2
fi
if [ ! -e $QUESTION ]
then 
	echo " ERROR :  Required file: $QUESTION missing."
	return 3
fi
if [ ! -e $PROPERTIES ]
then 
	echo " ERROR :  Required file: $PROPERTIES missing."
	return 4
fi

#Check to see if we have already run this
SUCCESS=$DIR/$EXPNAME/$EXPNAME-success

if [ -e $SUCCESS ]
then
	echo " ERROR :  It appears that HITS have already been created in file $SUCCESS"
	echo "          Exiting."
	return 5
fi

#make a log
LOGFILE=$DIR/$EXPNAME/$EXPNAME-run-log.txt

#Since the AMT scripts want the arguments passed to them, we 
#need to shift the argument stack so that anything after the experiment
#name is numbered as expected
if [ -z $2 ]; then
	# Nothing in $2. Generate an error. 
	echo " ERROR :   You must specify if this is either a 'sandbox' or 'golive' run." 
	return 5
else
    # There is something in $2. 
    if [ "$2" = "sandbox" ]; then
    	SANDLIVE="-sandbox"
    else
    	if [ "$2" = "golive" ]; then
    		SANDLIVE=" " #the default is production. make the argument blank
    	else
			echo " ERROR :   You must specify if this is either a 'sandbox' or 'golive' run. You specified \"$2\" instead." 
			return 6  	
    	fi
    fi
    shift # so that the $1 is shifted
    shift # so that the new $1 (prev $2) is shifted away. 
fi

cd ~/workspace/aws-mturk-clt-*/bin
./loadHITs.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 $SANDLIVE -label $SUCCESS -input $INPUTCSV -question $QUESTION -properties $PROPERTIES | tee -a $LOGFILE
mv $SUCCESS.success $SUCCESS #it appends .success to the label. I want a dash.
cd $DIR

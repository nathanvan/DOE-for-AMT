#!/usr/bin/env sh

JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun/jre/  
export JAVA_HOME
EXPNAME=$1
if [ -z $EXPNAME ]; then
   echo "You must specify an experiment name." 
   return 1
fi

DIR=`pwd`

#Check to see if we have a rejection file 
REJECT=$DIR/$EXPNAME/$EXPNAME-reject.csv
if [ ! -e $REJECT ]
then
	echo " ERROR :  Required file: $REJECT missing."
	return 5
fi


#make a log
LOGFILE=$DIR/$EXPNAME/$EXPNAME-rejectWork-log.txt


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
./rejectWork.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 $SANDLIVE  -rejectfile $REJECT | tee -a $LOGFILE
cd $DIR

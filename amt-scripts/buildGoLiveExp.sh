

EXPNAMESTAGE=$1
if [ -z $EXPNAMESTAGE ]; then
   echo "usage: buildGoLiveExp.sh <stage-experimentName> <live-experimentName>"
   echo "You must specify a stage-experiment name." 
   exit 1
fi

EXPNAMELIVE=$2
if [ -z $EXPNAMELIVE ]; then
   echo "usage: buildGoLiveExp.sh <stage-experimentName> <live-experimentName>"
   echo "You must specify a live-experiment name." 
   exit 2
fi

DIR=`pwd`

COPYLIST="-input.csv -properties -question"

#Check if the stage-experiment directory exists
if [ -d $DIR/$EXPNAMESTAGE ]; then

	if [ -d $DIR/$EXPNAMELIVE ]; then
		echo "Experiment \"$EXPNAMELIVE\" already exists."
		echo "Exiting without changes."
		exit 4
	fi
	
	svn mkdir $DIR/$EXPNAMELIVE
	for suffix in $COPYLIST
	do
		#echo "Copying \"$EXPNAMESTAGE/$EXPNAMESTAGE$suffix\" to \"$EXPNAMELIVE/$EXPNAMELIVE$suffix\" "
		svn cp $EXPNAMESTAGE/$EXPNAMESTAGE$suffix $EXPNAMELIVE/$EXPNAMELIVE$suffix 
	done

	STAGENUM=`echo $EXPNAMESTAGE | sed "s/[a-Z]*//"`
	LIVENUM=`echo $EXPNAMELIVE | sed "s/[a-Z]*//"`
	echo $STAGENUM
	echo $LIVENUM
	sed "s/\t\"$STAGENUM\"/\t\"$LIVENUM\"/" $EXPNAMESTAGE/$EXPNAMESTAGE-input.csv > $EXPNAMELIVE/$EXPNAMELIVE-input.csv
	
	svn commit -m "Ran buildGoLive.sh for \"$EXPNAMESTAGE\" and \"$EXPNAMELIVE\" "
else
   echo "Experiment name \"$EXPNAMESTAGE\" doesn't exist." 
   exit 2
fi



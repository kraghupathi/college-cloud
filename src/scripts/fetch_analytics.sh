#!/bin/sh

source ~/script/conf.sh

DATE=`date +"%d-%m-%Y"`
WORKSHOP_FOLDER=workshop-analytics-$DATE
WORKSHOP_DIR=~/college-cloud-data
INDEX_NAME=vlabs
CTID_ANALYTICS=280
CTID_FEEDBACK=278
MYSQL_USER=root
MYSQL_PASS=root
VAGRANT_BOX_PATH=~/vagrant-boxes/
MYSQL_FEEDBACK_DB=feedback
TAG=$COLLEGE_NAME-$DATE
LOCAL_WORKSHOP_DIR=$WORKSHOP_DIR/$WORKSHOP_FOLDER
EDX_AUTH_USER_DATA=edx-auth-user-data.sql
EDX_AUTH_REGISTRATION_DATA=edx-auth-registration-data.sql
DEST=/var/www/html/college-cloud-data/
ELKDATE=`date +"%Y-%m-%d"`

mkdir $WORKSHOP_DIR
mkdir $LOCAL_WORKSHOP_DIR

# Take elasticdump - the logs captured in ELK server
# Details 
# 1. Logs gets copied in localmachine in ~/college-cloud-data/workshop-analytics-$DATE folder
# 2. Two logs files - vlabs_mapping_$DATE.json and vlabs_data_$DATE.json files are generated.
# 3. Log files will not be generated in case they already exist.
 
echo "`date`: Executing elasticdump command " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
echo "`sudo vzctl exec $CTID_ANALYTICS elasticdump --input=http://localhost:9200/$INDEX_NAME --output=/root/vlabs_mapping_$DATE.json --type=mapping`"
echo "`sudo vzctl exec $CTID_ANALYTICS elasticdump --input=http://localhost:9200/$INDEX_NAME --output=/root/vlabs_data_$DATE.json --type=data`"
echo "`date`: Finished Executing elasticdump command " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt

echo "`sudo cp /vz/private/280/root/vlabs_mapping_$DATE.json $LOCAL_WORKSHOP_DIR/`"
echo "`sudo cp /vz/private/280/root/vlabs_data_$DATE.json $LOCAL_WORKSHOP_DIR/`"
echo "`date`: Copied files in $LOCAL_WORKSHOP_DIR " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt

# Take mysqldump of feedback - only sql dump is captured and needed
# Details -
# 1. SQLdump  gets copied in ~/college-cloud-data/workshop-analytics-$DATE folder
# 2. filename will be feedbackdump-$DATE.sql 


full_dump()
{
    echo "----FULL DUMP----"
    echo "`date`: Start Mysql dump for feedback " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
    echo "`sudo vzctl exec $CTID_FEEDBACK mysqldump -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_FEEDBACK_DB`" > $LOCAL_WORKSHOP_DIR/feedbackdump-$DATE.sql
    echo "`date`: End Mysql dump for feedback " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
    
    
    # Take mysql dump of open edx platform (auth_user and auth_registratiom) table 
    # Details  
    # 1. SQLdump  gets copied in ~/college-cloud-data/workshop-analytics-$DATE folder
    # 2. filename will be feedbackdump-$DATE.sql 
    
    cd $VAGRANT_BOX_PATH
    echo " Mysqldump is in progress"
    
    echo "`date`: Start Mysql dump for Open edx platform " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
    echo "`vagrant ssh -c 'mysqldump -uroot edxapp auth_user'`" > $LOCAL_WORKSHOP_DIR/$EDX_AUTH_USER_DATA
    echo "`vagrant ssh -c 'mysqldump -uroot edxapp auth_user'`" > $LOCAL_WORKSHOP_DIR/$EDX_AUTH_REGISTRATION_DATA
    echo "`date`: End Mysql dump for Open edX " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
    cd -
    
    # Compress the folder 
    
    echo "`date`: Start Compressing " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
    echo "`tar -zvcf $TAG-FULL-DUMP.tar.gz $LOCAL_WORKSHOP_DIR`"
    #mv  $TAG.tar.gz  $WORKSHOP_DIR
    sudo mv  $TAG-FULL-DUMP.tar.gz  $DEST
    echo "`date`: File Compressed - Look for file - $TAG-FULL-DUMP.tar.gz " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
}

datewise_dump()
{
     echo "-----DATE-WISE-DUMP------"
     echo "`date`: Start Mysql dump for feedback " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
     echo "`python ~/script/feedback-dump.py`"
     echo "`mv feedback-dump-$DATE.json  $LOCAL_WORKSHOP_DIR/feedbackdump-$DATE.sql`" 
     echo "`date`: End Mysql dump for feedback " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
    
     echo "`date`: Start Vlabs analytics from ELK " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
     curl -XGET 'http://vlabs-analytics.vlabs.ac.in:9200/vlabs/_search?pretty&size=1000' -d '{ "query" : { "term" : { "DATE_OF_EXPERIMENT": $ELKDATE }}}' > vlabs-analytics-$DATE.json
     echo "`mv vlabs-analytics-$DATE.json  $LOCAL_WORKSHOP_DIR`" 
     echo "`date`: End VLabs analytics dump  " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
     
     ## Take mysql dump of open edx platform (auth_user and auth_registratiom) table 
     # Details  
     # 1. SQLdump  gets copied in ~/college-cloud-data/workshop-analytics-$DATE folder
     # 2. filename will be feedbackdump-$DATE.sql 
     
     # Compress the folder 
     
     echo "`date`: Start Compressing " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
     echo "`tar -zvcf $TAG-DATEWISE-DUMP.tar.gz $LOCAL_WORKSHOP_DIR`"
     echo "`sudo mv  $TAG-DATEWISE-DUMP.tar.gz $DEST`"
     echo "`date`: File Compressed - Look for file - $TAG-DATEWISE-DUMP.tar.gz " >> $LOCAL_WORKSHOP_DIR/exec-status-$DATE.txt
}


if [ "$1" = "full" ]
then
 full_dump
else 
datewise_dump
fi

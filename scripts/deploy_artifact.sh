#!/bin/bash

BUCKET_NAME=$1
WAR_FILE_NAME=$2

# Wait for the file to be on S3
while true; do
    if aws s3 ls s3://$BUCKET_NAME/$WAR_FILE_NAME; then
        # If the .war file is found, download it to /tmp/
        aws s3 cp s3://$BUCKET_NAME/$WAR_FILE_NAME /tmp/$WAR_FILE_NAME
        break
    fi
    # Wait a while before checking again
    sleep 60
done

# Wait for Tomcat9 to be "running"
while true; do
    TOMCAT_STATUS=$(sudo systemctl is-active tomcat9)
    
    if [ "$TOMCAT_STATUS" = "active" ]; then
        echo "Tomcat9 is running. Proceeding with the deployment steps."
        break
    fi
    # Wait a while before checking again
    sleep 30
done

# If Tomcat9 is running, stop it
sudo systemctl stop tomcat9

# Remove the existing ROOT directory under webapps
sudo rm -rf /var/lib/tomcat9/webapps/ROOT

# Copy the newly downloaded .war file to webapps and rename to ROOT.war
sudo cp /tmp/$WAR_FILE_NAME /var/lib/tomcat9/webapps/ROOT.war

# Restart Tomcat9 after deploying the new .war
sudo systemctl start tomcat9

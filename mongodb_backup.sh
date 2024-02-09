#!/bin/bash

# Set AWS bucket name
AWS_BUCKET_NAME="mongodb-cluster-bkps"

# AWS S3 bucket name and path
s3_bucket="mongodb-cluster-bkps"

# Timestamp for backup directory structure
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
hour=$(date +%H)
minute=$(date +%M)

# Load environment variables
source .env.mongobkp || { echo "Error: Unable to load environment variables"; exit 1; }

# MongoDB host and port
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="$MONGODB_PORT"
MONGODB_USER="$MONGODB_USER"
MONGODB_PASSWORD="$MONGODB_PASSWORD"
MONGODB_DATABASE="$MONGODB_DATABASE"

# Create the backup directory structure
BACKUP_DIR="$year/$month/$day/$day_folder"
# mkdir -p "$BACKUP_DIR"
timestamp="backup$year-$month-$day-$hour-$minute"
BACKUP_FILE="$timestamp"

# MongoDB backup command
mongodump --host $MONGODB_HOST --port $MONGODB_PORT --username $MONGODB_USER --password $MONGODB_PASSWORD --db $MONGODB_DATABASE --out /root/mongodb-backup

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "MongoDB backup completed successfully."
else
  echo "MongoDB backup failed. Exiting."
  exit 1
fi

# Compress the backup
tar -zcvf "/root/mongodb-backup/$BACKUP_FILE.tar.gz" -C "/root/mongodb-backup" .

# Upload the backup to AWS S3
aws s3 cp "/root/mongodb-backup/$BACKUP_FILE.tar.gz" s3://$AWS_BUCKET_NAME/$BACKUP_DIR

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "Backup uploaded to AWS S3 successfully."
else
  echo "Backup upload to AWS S3 failed. Exiting."
  exit 1
fi

# Clean up the temporary backup files
rm -rf "/root/mongodb-backup/$BACKUP_FILE.tar.gz"
rm -rf "/root/mongodb-backup/decorpotdb/"

# Print the message
echo "Backup process completed."

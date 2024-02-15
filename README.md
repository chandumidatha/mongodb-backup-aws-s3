# mongodb-backup-aws-s3
Automate MongoDB backups and upload to AWS S3 with this Bash script. Simplify database maintenance and ensure data integrity effortlessly.


## Prerequisites

Before using this script, ensure you have the following prerequisites:

- ***MongoDB installed and running***: Ensure MongoDB is installed and running on your system. You can install MongoDB from the official MongoDB website or use a package manager like Homebrew for macOS or apt for Ubuntu. Follow the instructions provided in the [official MongoDB documentation](https://www.mongodb.com/docs/manual/administration/install-community/) for installing MongoDB.

- ***Method 1(AWS IAM role with appropriate permissions)***: Create an AWS IAM role with the necessary permissions to interact with your AWS S3 bucket. Instead of using Access Keys and Secret Keys, it's recommended to assign this IAM role to the EC2 instance where the script will be executed. 
  - Create an IAM role with policies granting permissions for S3 access.
  - Attach the IAM role to the EC2 instance where you plan to run the backup script. You can do this during instance creation or by modifying the instance settings later.
 
- ***Method 2(Access Keys and Secret Keys)***:
  Alternatively, you can configure AWS CLI with access and secret keys. Although less secure than using IAM roles, this method is suitable for local development environments or situations where IAM roles are not applicable.

### To install the AWS CLI using apt, run the following commands:

```bash
sudo apt update
sudo apt install -y awscli
```
### Configure AWS CLI with your AWS Access Key ID, Secret Access Key, and default region by run the below command.
aws configure
```bash
aws configure
```
#### Environment variables set in a `.env.mongobkp` file: Create a `.env.mongobkp` file in the same directory as the script and set the required environment variables for MongoDB connection.
#### Example content of .env.mongobkp file
```bash
MONGODB_HOST=127.0.0.1
MONGODB_PORT=<mongodb_port>
MONGODB_USER=<mongodb_user>
MONGODB_PASSWORD=<mongodb_password>
MONGODB_DATABASE=<mongodb_database>
```
### Run the script using the following command:
```bash
./mongodb_backup.sh
```
The script will create a backup of the specified MongoDB database, compress it, and upload it to the configured AWS S3 bucket.




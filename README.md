# RHEL9 EC2 Config for AWS EFS Analysis

Run the below on the RHEL9 EC2 instance performing the LiveOptics Dossier file analysis on AWS EFS
```bash
cd /home/ec2-user/
curl -O https://github.com/lee-vincent/liveoptics-dossier-aws-efs/blob/main/setup.sh
chmod +x setup.sh
./setup.sh <EFS_IP> <EC2_PRIVATE_IP_ADDRESS>
```
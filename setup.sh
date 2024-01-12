#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <EFS_IP> <EC2_PRIVATE_IP_ADDRESS>"
    exit 1
fi

EFS_IP="$1"
EC2_PRIVATE_IP_ADDRESS="$2"
NFS_MOUNT_PATH="/home/ec2-user/efs"

# Install required packages
sudo yum install -y nfs-utils.x86_64 nfsv4-client-utils.x86_64 compat-openssl11.x86_64

# Disable 64-bit NFS inodes
echo "options nfs enable_ino64=0" | sudo tee -a /etc/modprobe.d/nfs.conf

# Create directory for NFS mount
mkdir "$NFS_MOUNT_PATH"

# Add NFS mount entry to /etc/fstab
echo "$EFS_IP:/   $NFS_MOUNT_PATH   nfs4   rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,hard,noresvport,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=$EC2_PRIVATE_IP_ADDRESS,local_lock=none,addr=$EFS_IP   0   0" | sudo tee -a /etc/fstab

# Mount all filesystems listed in /etc/fstab
sudo mount -a

# Download and extract LiveOptics Dossier
curl -O https://liveoptics-dossier.s3.amazonaws.com/LiveOptics.Dossier.Linux.x64.tar.gz
tar -xvf LiveOptics.Dossier.Linux.x64.tar.gz
chmod +x LiveOptics.Dossier.Linux.ConsoleApp
rm -rf LiveOptics.Dossier.Linux.x64.tar.gz

# Create directories and generate random files
for x in {1..20}; do
    sudo mkdir "$NFS_MOUNT_PATH/dir-$x"
done


for x in {1..20}; do
  for i in {1..10}; do
    sudo dd if=/dev/urandom of="$NFS_MOUNT_PATH/dir-$x/file_${i}.txt" bs=1M count=1;
  done
done


# Run LiveOptics Dossier
sudo ./LiveOptics.Dossier.Linux.ConsoleApp $NFS_MOUNT_PATH/dir-{1..20}
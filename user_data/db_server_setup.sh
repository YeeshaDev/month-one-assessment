#!/bin/bash
yum update -y
amazon-linux-extras enable postgresql14
yum install postgresql-server postgresql -y

postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql

# Configure PostgreSQL to allow password authentication from web servers
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
echo "host all all 10.0.0.0/16 md5" >> /var/lib/pgsql/data/pg_hba.conf

systemctl restart postgresql

# Create a database and user
sudo -u postgres psql -c "CREATE USER techcorp WITH PASSWORD '${db_password}';"
sudo -u postgres psql -c "CREATE DATABASE techcorpdb OWNER techcorp;"

# Enable password authentication for SSH
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "dbadmin:${db_password}" | chpasswd
systemctl restart sshd

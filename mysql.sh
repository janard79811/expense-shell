source common.sh

MYSQL_ROOT_PASSWORD=$1

if [ -z "$1" ]; then
  echo password is missing
  exit
fi

echo -e "${color} disable mysql default version \e[0m"
dnf module disable mysql -y &>>${log_file}
status_check

echo -e "${color} copying mysql repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check

echo -e "${color} install mysql server \e[0m"
dnf install mysql-community-server -y &>>${log_file}
status_check

echo -e "${color} start mysql server \e[0m"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
status_check

echo -e "${color} set mysql password \e[0m"
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} &>>${log_file}
status_check
log_file=/tmp/expense.log
color="\e[33m"
MYSQL_ROOT_PASSWORD=$1

status_check() {
  if [ $? -eq 0 ]; then
   echo -e "\e[32m SUCCESS \e[0m"
  else
   echo -e "\e[31m FAILURE \e[0m"
  fi
}

if [ -z "$1" ]; then
  echo password is missing
  exit
fi

echo -e "${color} disable nodejs default version \e[0m"
dnf module disable nodejs -y &>>${log_file}
status_check

echo -e "${color} enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y &>>${log_file}
status_check

echo -e "${color} install nodejs \e[0m"
dnf install nodejs -y &>>${log_file}
status_check

echo -e "${color} copying backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>${log_file}
status_check

id expense &>>${log_file}
if [ $? -ne 0 ]; then
  echo -e "${color} add application user \e[0m"
  useradd expense &>>${log_file}
  status_check
fi

if [ ! -d /app ]; then
 echo -e "${color} create application directory \e[0m"
 mkdir /app &>>${log_file}
 status_check
fi

echo -e "${color} removing/cleaning/ deleting default/old application content \e[0m"
rm -rf /app/* &>>${log_file}
status_check

echo -e "${color} download application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>${log_file}
status_check

echo -e "${color} extract application content \e[0m"
cd /app &>>${log_file}
unzip /tmp/backend.zip &>>${log_file}
status_check

echo -e "${color} download nodejs dependencies \e[0m"
npm install &>>${log_file}
status_check

echo -e "${color} install mysql client to load schema \e[0m"
dnf install mysql -y &>>${log_file}
status_check

echo -e "${color} load schema \e[0m"
mysql -h mysql-dev.janard4589.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>${log_file}
status_check

echo -e "${color} starting backend service \e[0m"
systemctl daemon-reload &>>${log_file}
systemctl enable backend &>>${log_file}
systemctl start backend &>>${log_file}
status_check

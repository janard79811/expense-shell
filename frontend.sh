echo -e "\e[31m Installing Ngninx \e[0m"
dnf install nginx -y

echo -e "\e[32m copying expense config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf

echo -e "\e[33m removing the default content in Nginx i.e. clean old Nginx content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34m downloading frontend application code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35m Extracting/ unzipping downloaded application content \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m Starting Nginx service \e[0m"
systemctl enable nginx
systemctl restart nginx
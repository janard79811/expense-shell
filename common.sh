# Below 2,3 lines variables declared i.e. common for all scripts
log_file=/tmp/expense.log
color="\e[33m"

# Below script is function declared i.e. common for all scripts
status_check() {
  if [ $? -eq 0 ]; then
   echo -e "\e[32m SUCCESS \e[0m"
  else
   echo -e "\e[31m FAILURE \e[0m"
  fi
}
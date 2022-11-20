#!/bin/bash
#set -xv



#VARIABLES
USAGE=70
mailto=root@web
HOSTNAME=$(hostname)
memory_free=`free -m | grep -i mem | awk '{print $4}'`
swap_free=`free -m | grep -i swap | awk '{print $2}'`
total_free=$(($memory_free+swap_free))

echo

#FILE SYSTEM USAGE
echo "Checking FS utilization..."
for path in `df -h | grep -vE 'Filesystem|tmpfs' | awk '{print $5}' |sed 's/%//g'`
do
        if [ $path -ge $USAGE ]; then
        df -h | grep $path% >> temp.txt
fi
done
if [ ! -f temp.txt ]; then
echo "Current FS status: ";
df -h | grep -i /dev/mapper/cl-root;
echo "The Disk Usage is okay!"
elif [ $(cat temp.txt | wc -l) -ge 1 ]; then
echo "Server: $HOSTNAME Disk Usage is Critical";
mail -s "Server: $HOSTNAME Disk Usage is Critical" root@web < temp.txt
fi

rm -rf temp.txt

echo
echo

#MEMORY CHECK
echo "Checking Memory utilization..."
echo "Free memory left = $total_free MB"
if (( $total_free < 800 )); then
echo "You are running out of memory!!!"; else
echo "The memory usage is okay!"
fi

echo
echo

#CPU CHECK
echo "Checking CPU utilization..."
for cpu_free in $(sar 2 2 | grep -i average | awk '{ printf "%.f\n", int($8-0.5)}'); do

        if [ $cpu_free -gt 60 ]; then
echo "Free CPU left = $cpu_free%";
echo "The CPU Utilization is perfect!"
        else echo "CPU OVERLOADED"
fi
done

echo
echo

#APACHE CHECK
echo "Checking if the Apache service is running..."
systemctl status httpd | egrep -i 'status'
if systemctl status httpd > /dev/null; then
echo "The Apache service is running"
else
systemctl start httpd
echo "The Apache service was stopped, errored, or inactive. The service has been started." | mail -s "                                                                                                                                       The Apache service was stopped" root@web
fi
rm -f output.txt

echo


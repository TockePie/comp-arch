uname -srvmo && hostname
sudo apt update && sudo apt upgrade -y
cat /etc/apt/sources.list.d/*.list
sudo apt install -y vim
cd ~
cd ~/Downloads
man ls
ls -l
dpkg -i package.deb
sudo !!
cd /
sudo su
exit
echo "hi all"
echo "$PWD hi all here!"
touch hi.sh
echo "$PATH"
vi hi.sh
./hi.sh
chmod a+x hi.sh
chmod a+rwx hi.sh
./hi.sh
./hi.sh Ukraine
cp hi.sh scripts/
cp scripts/ ~/Documents/
cp -r scripts/ ~/Documents/
cd scripts
mv hi.sh ../
cd ..
rm scripts
rm -rf scripts
cd /bin
ls -l
cd ../..
tar -cvf scripts.tar scripts/
cat /etc/passwd
cat /var/log/syslog
tail -n 20 /var/log/syslog
grep -i "error" /var/log/syslog
cd /
find . -name "dhcp"
find . -iname "*dhcp*"
grep -i -r "dhcp" .
grep -i -r "etc" .
ping -c 4 google.com
(ping google.com &) && date >> ping.log
sudo ping -c 4 google.com
vlc
ls -l
cd /bin
ls
echo "$PATH"
printenv
whoami
cd /etc
ls -l
cd ..
cd lib
ls -l
dmesg
sudo !!
ls -l /dev
sudo dmesg -C
dmesg | tail -n 20
df -h
cd /home
ls -l
lsmod
cd /proc
cat cpuinfo
echo 1 > /proc/sys/net/ipv4/ip_forward
sudo su
ip addr show
ip link show
cd ~
echo "vika" > 1.txt
cat 1.txt
echo "vasya" > 2.txt
cat 2.txt
diff 1.txt 2.txt
history
lspci
history > history.txt
ls -l

#!/bin/bash
#########初始配置数据#################################
#SFTP配置信息
#用户名
USER=root
#密码
PASSWORD=Yl1699xts
#远程主机
IP=145.242.192.22

#计算前一日日期，格式如20160701
DATE=`date -d '-1 days' +%Y%m%d`
echo ${DATE}

#机构号，暂时只传了这家，可增加
INS=48021910

#文件目录
#######上传文件##################################
#-e后语句内容执行创建目录及传输操作
lftp -e "
cd /NMGNFS/SFTPROOT/CK00/nmgsp/duizhang;
cd ${INS};
mkdir ${DATE};
cd ${DATE};
lcd /var/ftp/nmylswqs;
lcd ${INS};
lcd ${DATE};
mput *;
quit" -u root,Yl1699xts sftp://145.242.192.22



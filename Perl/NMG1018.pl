#!/usr/bin/perl -w
use strict;
use warnings;
use IO::Handle;

#常量定义
use constant {
    DATEINPROMP =>  0,  #TRUE=1;FALSE=0
    ERRINFPROMP =>  0,  #TRUE=1;FALSE=0
    TRIMINSIDCD =>  1,  #TRUE=1;FALSE=0
    WORKINGPATH =>  "/var/ftp/nmylswqs", #脚本工作目录
    DSTFILEPATH =>  "", #输出文件目录
    DESTINSCODE =>  "14511910", #输出文件放置在哪个机构目录下
    SRCINSFILNM =>  "/var/ftp/nmylswqs/1451.txt", #存放机构代码的文件
    #SRCINSFILNM =>  "./1451.txt", 
    SRCFILEPREX =>  "RD1018",   #源文件前缀
    SRCFILESUBX =>  "00",       #源文件结尾
    DSTFILEPREX =>  "NM1018",   #输出文件前缀
    DSTFILESUBX =>  "00",       #输出文件结尾
    ERRFILENAME =>  "debug.txt", #日志文件
    ERRORINFOFILENAME =>  "ERRORinfo.txt" #yb add 网点号错误 而且 地区码也没有匹配成功的交易明细记录
};

#全局变量定义
my $workDate;
my $time;
my @acqList;
my %insFeeHashtable;


my %wangdianHashtable;   #yb add  网点表

$wangdianHashtable{'02001                           '}="541****";
$wangdianHashtable{'02003                           '}="541****";
$wangdianHashtable{'02005                           '}="541****";
$wangdianHashtable{'02007                           '}="541****";
$wangdianHashtable{'02008                           '}="541****";
$wangdianHashtable{'02009                           '}="541****";
$wangdianHashtable{'02010                           '}="541****";
$wangdianHashtable{'02011                           '}="541****";
$wangdianHashtable{'02012                           '}="541****";
$wangdianHashtable{'02014                           '}="541****";
$wangdianHashtable{'02015                           '}="541****";
$wangdianHashtable{'02016                           '}="541****";
$wangdianHashtable{'02020                           '}="541****";
$wangdianHashtable{'02022                           '}="541****";
$wangdianHashtable{'02024                           '}="541****";
$wangdianHashtable{'02025                           '}="541****";
$wangdianHashtable{'02026                           '}="541****";
$wangdianHashtable{'02028                           '}="541****";
$wangdianHashtable{'02029                           '}="541****";
$wangdianHashtable{'02030                           '}="541****";
$wangdianHashtable{'02031                           '}="541****";
$wangdianHashtable{'02032                           '}="541****";
$wangdianHashtable{'02033                           '}="541****";
$wangdianHashtable{'02035                           '}="541****";
$wangdianHashtable{'02036                           '}="541****";
$wangdianHashtable{'02039                           '}="541****";
$wangdianHashtable{'02040                           '}="541****";
$wangdianHashtable{'02041                           '}="541****";
$wangdianHashtable{'02042                           '}="541****";
$wangdianHashtable{'02044                           '}="541****";
$wangdianHashtable{'02045                           '}="541****";
$wangdianHashtable{'02047                           '}="541****";
$wangdianHashtable{'02048                           '}="541****";
$wangdianHashtable{'02049                           '}="541****";
$wangdianHashtable{'02051                           '}="541****";
$wangdianHashtable{'02052                           '}="541****";
$wangdianHashtable{'02053                           '}="541****";
$wangdianHashtable{'02054                           '}="541****";
$wangdianHashtable{'02055                           '}="541****";
$wangdianHashtable{'02057                           '}="541****";
$wangdianHashtable{'02058                           '}="541****";
$wangdianHashtable{'02059                           '}="541****";
$wangdianHashtable{'02060                           '}="541****";
$wangdianHashtable{'02062                           '}="541****";
$wangdianHashtable{'02064                           '}="541****";
$wangdianHashtable{'02065                           '}="541****";
$wangdianHashtable{'02066                           '}="541****";
$wangdianHashtable{'02068                           '}="541****";
$wangdianHashtable{'02069                           '}="541****";
$wangdianHashtable{'02070                           '}="541****";
$wangdianHashtable{'02071                           '}="541****";
$wangdianHashtable{'02072                           '}="541****";
$wangdianHashtable{'02073                           '}="541****";
$wangdianHashtable{'02076                           '}="541****";
$wangdianHashtable{'02077                           '}="541****";
$wangdianHashtable{'02078                           '}="541****";
$wangdianHashtable{'02080                           '}="541****";
$wangdianHashtable{'02081                           '}="541****";
$wangdianHashtable{'02082                           '}="541****";
$wangdianHashtable{'02084                           '}="541****";
$wangdianHashtable{'02085                           '}="541****";
$wangdianHashtable{'02086                           '}="541****";
$wangdianHashtable{'02088                           '}="541****";
$wangdianHashtable{'02089                           '}="541****";
$wangdianHashtable{'02091                           '}="541****";
$wangdianHashtable{'02092                           '}="541****";
$wangdianHashtable{'02093                           '}="541****";
$wangdianHashtable{'02094                           '}="541****";
$wangdianHashtable{'02095                           '}="541****";
$wangdianHashtable{'02096                           '}="541****";
$wangdianHashtable{'02097                           '}="541****";
$wangdianHashtable{'02098                           '}="541****";
$wangdianHashtable{'02100                           '}="541****";
$wangdianHashtable{'02101                           '}="541****";
$wangdianHashtable{'02105                           '}="541****";
$wangdianHashtable{'02106                           '}="541****";
$wangdianHashtable{'02107                           '}="541****";
$wangdianHashtable{'02109                           '}="541****";
$wangdianHashtable{'02111                           '}="541****";
$wangdianHashtable{'02112                           '}="541****";
$wangdianHashtable{'02114                           '}="541****";
$wangdianHashtable{'02115                           '}="541****";
$wangdianHashtable{'02116                           '}="541****";
$wangdianHashtable{'02117                           '}="541****";
$wangdianHashtable{'02119                           '}="541****";
$wangdianHashtable{'02120                           '}="541****";
$wangdianHashtable{'02121                           '}="541****";
$wangdianHashtable{'02122                           '}="541****";
$wangdianHashtable{'02124                           '}="541****";
$wangdianHashtable{'02128                           '}="541****";
$wangdianHashtable{'02130                           '}="541****";
$wangdianHashtable{'02131                           '}="541****";
$wangdianHashtable{'02134                           '}="541****";
$wangdianHashtable{'02136                           '}="541****";
$wangdianHashtable{'02138                           '}="541****";
$wangdianHashtable{'02139                           '}="541****";
$wangdianHashtable{'02141                           '}="541****";
$wangdianHashtable{'02151                           '}="541****";
$wangdianHashtable{'02161                           '}="541****";
$wangdianHashtable{'02171                           '}="541****";
$wangdianHashtable{'02172                           '}="541****";
$wangdianHashtable{'02173                           '}="541****";
$wangdianHashtable{'02174                           '}="541****";
$wangdianHashtable{'02176                           '}="541****";
$wangdianHashtable{'02177                           '}="541****";
$wangdianHashtable{'02178                           '}="541****";
$wangdianHashtable{'03001                           '}="541****";
$wangdianHashtable{'03003                           '}="541****";
$wangdianHashtable{'03004                           '}="541****";
$wangdianHashtable{'03006                           '}="541****";
$wangdianHashtable{'03007                           '}="541****";
$wangdianHashtable{'03008                           '}="541****";
$wangdianHashtable{'03010                           '}="541****";
$wangdianHashtable{'03011                           '}="541****";
$wangdianHashtable{'03012                           '}="541****";
$wangdianHashtable{'03014                           '}="541****";
$wangdianHashtable{'03016                           '}="541****";
$wangdianHashtable{'03017                           '}="541****";
$wangdianHashtable{'03018                           '}="541****";
$wangdianHashtable{'03020                           '}="541****";
$wangdianHashtable{'03021                           '}="541****";
$wangdianHashtable{'03023                           '}="541****";
$wangdianHashtable{'03024                           '}="541****";
$wangdianHashtable{'03026                           '}="541****";
$wangdianHashtable{'03028                           '}="541****";
$wangdianHashtable{'03029                           '}="541****";
$wangdianHashtable{'03030                           '}="541****";
$wangdianHashtable{'03032                           '}="541****";
$wangdianHashtable{'03034                           '}="541****";
$wangdianHashtable{'03036                           '}="541****";
$wangdianHashtable{'03038                           '}="541****";
$wangdianHashtable{'03040                           '}="541****";
$wangdianHashtable{'03042                           '}="541****";
$wangdianHashtable{'03044                           '}="541****";
$wangdianHashtable{'03046                           '}="541****";
$wangdianHashtable{'03048                           '}="541****";
$wangdianHashtable{'03050                           '}="541****";
$wangdianHashtable{'03052                           '}="541****";
$wangdianHashtable{'03056                           '}="541****";
$wangdianHashtable{'03057                           '}="541****";
$wangdianHashtable{'03058                           '}="541****";
$wangdianHashtable{'03060                           '}="541****";
$wangdianHashtable{'03062                           '}="541****";
$wangdianHashtable{'03064                           '}="541****";
$wangdianHashtable{'04001                           '}="541****";
$wangdianHashtable{'04003                           '}="541****";
$wangdianHashtable{'04005                           '}="541****";
$wangdianHashtable{'04007                           '}="541****";
$wangdianHashtable{'04009                           '}="541****";
$wangdianHashtable{'04011                           '}="541****";
$wangdianHashtable{'04013                           '}="541****";
$wangdianHashtable{'04015                           '}="541****";
$wangdianHashtable{'04017                           '}="541****";
$wangdianHashtable{'04019                           '}="541****";
$wangdianHashtable{'04021                           '}="541****";
$wangdianHashtable{'04023                           '}="541****";
$wangdianHashtable{'04025                           '}="541****";
$wangdianHashtable{'04026                           '}="541****";
$wangdianHashtable{'04027                           '}="541****";
$wangdianHashtable{'04028                           '}="541****";
$wangdianHashtable{'04029                           '}="541****";
$wangdianHashtable{'04030                           '}="541****";
$wangdianHashtable{'04031                           '}="541****";
$wangdianHashtable{'04032                           '}="541****";
$wangdianHashtable{'04034                           '}="541****";
$wangdianHashtable{'04035                           '}="541****";
$wangdianHashtable{'04036                           '}="541****";
$wangdianHashtable{'04038                           '}="541****";
$wangdianHashtable{'04040                           '}="541****";
$wangdianHashtable{'05001                           '}="541****";
$wangdianHashtable{'05003                           '}="541****";
$wangdianHashtable{'05004                           '}="541****";
$wangdianHashtable{'05006                           '}="541****";
$wangdianHashtable{'05008                           '}="541****";
$wangdianHashtable{'05010                           '}="541****";
$wangdianHashtable{'05012                           '}="541****";
$wangdianHashtable{'05014                           '}="541****";
$wangdianHashtable{'05016                           '}="541****";
$wangdianHashtable{'05018                           '}="541****";
$wangdianHashtable{'05020                           '}="541****";
$wangdianHashtable{'05022                           '}="541****";
$wangdianHashtable{'05024                           '}="541****";
$wangdianHashtable{'05026                           '}="541****";
$wangdianHashtable{'05027                           '}="541****";
$wangdianHashtable{'05029                           '}="541****";
$wangdianHashtable{'05031                           '}="541****";
$wangdianHashtable{'05032                           '}="541****";
$wangdianHashtable{'05033                           '}="541****";
$wangdianHashtable{'05034                           '}="541****";
$wangdianHashtable{'05036                           '}="541****";
$wangdianHashtable{'05037                           '}="541****";
$wangdianHashtable{'05038                           '}="541****";
$wangdianHashtable{'05039                           '}="541****";
$wangdianHashtable{'05040                           '}="541****";
$wangdianHashtable{'06001                           '}="541****";
$wangdianHashtable{'06003                           '}="541****";
$wangdianHashtable{'06005                           '}="541****";
$wangdianHashtable{'06006                           '}="541****";
$wangdianHashtable{'06008                           '}="541****";
$wangdianHashtable{'06010                           '}="541****";
$wangdianHashtable{'06012                           '}="541****";
$wangdianHashtable{'06014                           '}="541****";
$wangdianHashtable{'06016                           '}="541****";
$wangdianHashtable{'06018                           '}="541****";
$wangdianHashtable{'06020                           '}="541****";
$wangdianHashtable{'06022                           '}="541****";
$wangdianHashtable{'06024                           '}="541****";
$wangdianHashtable{'06025                           '}="541****";
$wangdianHashtable{'06026                           '}="541****";
$wangdianHashtable{'06027                           '}="541****";
$wangdianHashtable{'06029                           '}="541****";
$wangdianHashtable{'06030                           '}="541****";
$wangdianHashtable{'06031                           '}="541****";
$wangdianHashtable{'06033                           '}="541****";
$wangdianHashtable{'06041                           '}="541****";
$wangdianHashtable{'06043                           '}="541****";
$wangdianHashtable{'06045                           '}="541****";
$wangdianHashtable{'07001                           '}="541****";
$wangdianHashtable{'07003                           '}="541****";
$wangdianHashtable{'07005                           '}="541****";
$wangdianHashtable{'07007                           '}="541****";
$wangdianHashtable{'07009                           '}="541****";
$wangdianHashtable{'07011                           '}="541****";
$wangdianHashtable{'07013                           '}="541****";
$wangdianHashtable{'07015                           '}="541****";
$wangdianHashtable{'07017                           '}="541****";
$wangdianHashtable{'07019                           '}="541****";
$wangdianHashtable{'07021                           '}="541****";
$wangdianHashtable{'07023                           '}="541****";
$wangdianHashtable{'07025                           '}="541****";
$wangdianHashtable{'07027                           '}="541****";
$wangdianHashtable{'07029                           '}="541****";
$wangdianHashtable{'07031                           '}="541****";
$wangdianHashtable{'07033                           '}="541****";
$wangdianHashtable{'07035                           '}="541****";
$wangdianHashtable{'07037                           '}="541****";
$wangdianHashtable{'07039                           '}="541****";
$wangdianHashtable{'07041                           '}="541****";
$wangdianHashtable{'07042                           '}="541****";
$wangdianHashtable{'07043                           '}="541****";
$wangdianHashtable{'07044                           '}="541****";
$wangdianHashtable{'07045                           '}="541****";
$wangdianHashtable{'07046                           '}="541****";
$wangdianHashtable{'07047                           '}="541****";
$wangdianHashtable{'08001                           '}="541****";
$wangdianHashtable{'08003                           '}="541****";
$wangdianHashtable{'08004                           '}="541****";
$wangdianHashtable{'08007                           '}="541****";
$wangdianHashtable{'08008                           '}="541****";
$wangdianHashtable{'08013                           '}="541****";
$wangdianHashtable{'08015                           '}="541****";
$wangdianHashtable{'08018                           '}="541****";
$wangdianHashtable{'08019                           '}="541****";
$wangdianHashtable{'08022                           '}="541****";
$wangdianHashtable{'08024                           '}="541****";
$wangdianHashtable{'08027                           '}="541****";
$wangdianHashtable{'08028                           '}="541****";
$wangdianHashtable{'08029                           '}="541****";
$wangdianHashtable{'08030                           '}="541****";
$wangdianHashtable{'08031                           '}="541****";
$wangdianHashtable{'08032                           '}="541****";
$wangdianHashtable{'08034                           '}="541****";
$wangdianHashtable{'08038                           '}="541****";
$wangdianHashtable{'08039                           '}="541****";
$wangdianHashtable{'08040                           '}="541****";
$wangdianHashtable{'08041                           '}="541****";
$wangdianHashtable{'08042                           '}="541****";
$wangdianHashtable{'08043                           '}="541****";
$wangdianHashtable{'08048                           '}="541****";
$wangdianHashtable{'08049                           '}="541****";
$wangdianHashtable{'08054                           '}="541****";
$wangdianHashtable{'08055                           '}="541****";
$wangdianHashtable{'08056                           '}="541****";
$wangdianHashtable{'08057                           '}="541****";
$wangdianHashtable{'08059                           '}="541****";
$wangdianHashtable{'08061                           '}="541****";
$wangdianHashtable{'08065                           '}="541****";
$wangdianHashtable{'08066                           '}="541****";
$wangdianHashtable{'08068                           '}="541****";
$wangdianHashtable{'08070                           '}="541****";
$wangdianHashtable{'08071                           '}="541****";
$wangdianHashtable{'08072                           '}="541****";
$wangdianHashtable{'08073                           '}="541****";
$wangdianHashtable{'08074                           '}="541****";
$wangdianHashtable{'08075                           '}="541****";
$wangdianHashtable{'08077                           '}="541****";
$wangdianHashtable{'08078                           '}="541****";
$wangdianHashtable{'08079                           '}="541****";
$wangdianHashtable{'08080                           '}="541****";
$wangdianHashtable{'09001                           '}="541****";
$wangdianHashtable{'09003                           '}="541****";
$wangdianHashtable{'09004                           '}="541****";
$wangdianHashtable{'09005                           '}="541****";
$wangdianHashtable{'09007                           '}="541****";
$wangdianHashtable{'09009                           '}="541****";
$wangdianHashtable{'09010                           '}="541****";
$wangdianHashtable{'09011                           '}="541****";
$wangdianHashtable{'09012                           '}="541****";
$wangdianHashtable{'09013                           '}="541****";
$wangdianHashtable{'09014                           '}="541****";
$wangdianHashtable{'09015                           '}="541****";
$wangdianHashtable{'09016                           '}="541****";
$wangdianHashtable{'09017                           '}="541****";
$wangdianHashtable{'09018                           '}="541****";
$wangdianHashtable{'09019                           '}="541****";
$wangdianHashtable{'09020                           '}="541****";
$wangdianHashtable{'09022                           '}="541****";
$wangdianHashtable{'09024                           '}="541****";
$wangdianHashtable{'09025                           '}="541****";
$wangdianHashtable{'09026                           '}="541****";
$wangdianHashtable{'09027                           '}="541****";
$wangdianHashtable{'09028                           '}="541****";
$wangdianHashtable{'09029                           '}="541****";
$wangdianHashtable{'09030                           '}="541****";
$wangdianHashtable{'09031                           '}="541****";
$wangdianHashtable{'09032                           '}="541****";
$wangdianHashtable{'09033                           '}="541****";
$wangdianHashtable{'09034                           '}="541****";
$wangdianHashtable{'09036                           '}="541****";
$wangdianHashtable{'09037                           '}="541****";
$wangdianHashtable{'09039                           '}="541****";
$wangdianHashtable{'09040                           '}="541****";
$wangdianHashtable{'09042                           '}="541****";
$wangdianHashtable{'09043                           '}="541****";
$wangdianHashtable{'09044                           '}="541****";
$wangdianHashtable{'09045                           '}="541****";
$wangdianHashtable{'09046                           '}="541****";
$wangdianHashtable{'09047                           '}="541****";
$wangdianHashtable{'09048                           '}="541****";
$wangdianHashtable{'09049                           '}="541****";
$wangdianHashtable{'09050                           '}="541****";
$wangdianHashtable{'09052                           '}="541****";
$wangdianHashtable{'10001                           '}="541****";
$wangdianHashtable{'10003                           '}="541****";
$wangdianHashtable{'10005                           '}="541****";
$wangdianHashtable{'10006                           '}="541****";
$wangdianHashtable{'10007                           '}="541****";
$wangdianHashtable{'10010                           '}="541****";
$wangdianHashtable{'10012                           '}="541****";
$wangdianHashtable{'10013                           '}="541****";
$wangdianHashtable{'10014                           '}="541****";
$wangdianHashtable{'10016                           '}="541****";
$wangdianHashtable{'10019                           '}="541****";
$wangdianHashtable{'10020                           '}="541****";
$wangdianHashtable{'10021                           '}="541****";
$wangdianHashtable{'10023                           '}="541****";
$wangdianHashtable{'10025                           '}="541****";
$wangdianHashtable{'10027                           '}="541****";
$wangdianHashtable{'10030                           '}="541****";
$wangdianHashtable{'10032                           '}="541****";
$wangdianHashtable{'10034                           '}="541****";
$wangdianHashtable{'10036                           '}="541****";
$wangdianHashtable{'10038                           '}="541****";
$wangdianHashtable{'10040                           '}="541****";
$wangdianHashtable{'10042                           '}="541****";
$wangdianHashtable{'10044                           '}="541****";
$wangdianHashtable{'10046                           '}="541****";
$wangdianHashtable{'10048                           '}="541****";
$wangdianHashtable{'10049                           '}="541****";
$wangdianHashtable{'10050                           '}="541****";
$wangdianHashtable{'10052                           '}="541****";
$wangdianHashtable{'10053                           '}="541****";
$wangdianHashtable{'10054                           '}="541****";
$wangdianHashtable{'10059                           '}="541****";
$wangdianHashtable{'10061                           '}="541****";
$wangdianHashtable{'10065                           '}="541****";
$wangdianHashtable{'10067                           '}="541****";
$wangdianHashtable{'10068                           '}="541****";
$wangdianHashtable{'10072                           '}="541****";
$wangdianHashtable{'11001                           '}="541****";
$wangdianHashtable{'11003                           '}="541****";
$wangdianHashtable{'11004                           '}="541****";
$wangdianHashtable{'11005                           '}="541****";
$wangdianHashtable{'11008                           '}="541****";
$wangdianHashtable{'11010                           '}="541****";
$wangdianHashtable{'11011                           '}="541****";
$wangdianHashtable{'11013                           '}="541****";
$wangdianHashtable{'11015                           '}="541****";
$wangdianHashtable{'11017                           '}="541****";
$wangdianHashtable{'11019                           '}="541****";
$wangdianHashtable{'11021                           '}="541****";
$wangdianHashtable{'11023                           '}="541****";
$wangdianHashtable{'11025                           '}="541****";
$wangdianHashtable{'11027                           '}="541****";
$wangdianHashtable{'11032                           '}="541****";
$wangdianHashtable{'11035                           '}="541****";
$wangdianHashtable{'11037                           '}="541****";
$wangdianHashtable{'11039                           '}="541****";
$wangdianHashtable{'11040                           '}="541****";
$wangdianHashtable{'12001                           '}="541****";
$wangdianHashtable{'12003                           '}="541****";
$wangdianHashtable{'12005                           '}="541****";
$wangdianHashtable{'12009                           '}="541****";
$wangdianHashtable{'12011                           '}="541****";
$wangdianHashtable{'12013                           '}="541****";
$wangdianHashtable{'12015                           '}="541****";
$wangdianHashtable{'12017                           '}="541****";
$wangdianHashtable{'12019                           '}="541****";
$wangdianHashtable{'12021                           '}="541****";
$wangdianHashtable{'12023                           '}="541****";
$wangdianHashtable{'12025                           '}="541****";
$wangdianHashtable{'12026                           '}="541****";
$wangdianHashtable{'12028                           '}="541****";
$wangdianHashtable{'12030                           '}="541****";
$wangdianHashtable{'12032                           '}="541****";
$wangdianHashtable{'12033                           '}="541****";
$wangdianHashtable{'12034                           '}="541****";
$wangdianHashtable{'13001                           '}="541****";
$wangdianHashtable{'13003                           '}="541****";
$wangdianHashtable{'13004                           '}="541****";
$wangdianHashtable{'13005                           '}="541****";
$wangdianHashtable{'13007                           '}="541****";
$wangdianHashtable{'13008                           '}="541****";
$wangdianHashtable{'13009                           '}="541****";
$wangdianHashtable{'13010                           '}="541****";
$wangdianHashtable{'13011                           '}="541****";
$wangdianHashtable{'13012                           '}="541****";
$wangdianHashtable{'13014                           '}="541****";
$wangdianHashtable{'13019                           '}="541****";
$wangdianHashtable{'13020                           '}="541****";
$wangdianHashtable{'13022                           '}="541****";
$wangdianHashtable{'13023                           '}="541****";
$wangdianHashtable{'13024                           '}="541****";
$wangdianHashtable{'13025                           '}="541****";
$wangdianHashtable{'13026                           '}="541****";
$wangdianHashtable{'13028                           '}="541****";
$wangdianHashtable{'13029                           '}="541****";
$wangdianHashtable{'13031                           '}="541****";
$wangdianHashtable{'13032                           '}="541****";
$wangdianHashtable{'13033                           '}="541****";
$wangdianHashtable{'13035                           '}="541****";
$wangdianHashtable{'13037                           '}="541****";
$wangdianHashtable{'14001                           '}="541****";
$wangdianHashtable{'14003                           '}="541****";
$wangdianHashtable{'14005                           '}="541****";
$wangdianHashtable{'14006                           '}="541****";
$wangdianHashtable{'14008                           '}="541****";
$wangdianHashtable{'14009                           '}="541****";
$wangdianHashtable{'14011                           '}="541****";
$wangdianHashtable{'14012                           '}="541****";
$wangdianHashtable{'14014                           '}="541****";
$wangdianHashtable{'14016                           '}="541****";
$wangdianHashtable{'14019                           '}="541****";
$wangdianHashtable{'14020                           '}="541****";
$wangdianHashtable{'14021                           '}="541****";
$wangdianHashtable{'14022                           '}="541****";
$wangdianHashtable{'14023                           '}="541****";
$wangdianHashtable{'14025                           '}="541****";
$wangdianHashtable{'14026                           '}="541****";
$wangdianHashtable{'14027                           '}="541****";
$wangdianHashtable{'14031                           '}="541****";
$wangdianHashtable{'14032                           '}="541****";
$wangdianHashtable{'14033                           '}="541****";
$wangdianHashtable{'14034                           '}="541****";
$wangdianHashtable{'14035                           '}="541****";
$wangdianHashtable{'14036                           '}="541****";
$wangdianHashtable{'14037                           '}="541****";
$wangdianHashtable{'15001                           '}="541****";
$wangdianHashtable{'15003                           '}="541****";
$wangdianHashtable{'15005                           '}="541****";
$wangdianHashtable{'15007                           '}="541****";
$wangdianHashtable{'15009                           '}="541****";
$wangdianHashtable{'15011                           '}="541****";
$wangdianHashtable{'15012                           '}="541****";
$wangdianHashtable{'15014                           '}="541****";
$wangdianHashtable{'15015                           '}="541****";
$wangdianHashtable{'15017                           '}="541****";
$wangdianHashtable{'15018                           '}="541****";
$wangdianHashtable{'15020                           '}="541****";
$wangdianHashtable{'15022                           '}="541****";
$wangdianHashtable{'15023                           '}="541****";
$wangdianHashtable{'15025                           '}="541****";
$wangdianHashtable{'15026                           '}="541****";
$wangdianHashtable{'15028                           '}="541****";
$wangdianHashtable{'15030                           '}="541****";
$wangdianHashtable{'15032                           '}="541****";
$wangdianHashtable{'15033                           '}="541****";
$wangdianHashtable{'15034                           '}="541****";
$wangdianHashtable{'15035                           '}="541****";
$wangdianHashtable{'15037                           '}="541****";
$wangdianHashtable{'15039                           '}="541****";
$wangdianHashtable{'15040                           '}="541****";
$wangdianHashtable{'15042                           '}="541****";
$wangdianHashtable{'15043                           '}="541****";
$wangdianHashtable{'15046                           '}="541****";
$wangdianHashtable{'15047                           '}="541****";
$wangdianHashtable{'15049                           '}="541****";
$wangdianHashtable{'16001                           '}="541****";
$wangdianHashtable{'16003                           '}="541****";
$wangdianHashtable{'16005                           '}="541****";
$wangdianHashtable{'16007                           '}="541****";
$wangdianHashtable{'16009                           '}="541****";
$wangdianHashtable{'16011                           '}="541****";
$wangdianHashtable{'16013                           '}="541****";
$wangdianHashtable{'16014                           '}="541****";
$wangdianHashtable{'16016                           '}="541****";
$wangdianHashtable{'16018                           '}="541****";
$wangdianHashtable{'16020                           '}="541****";
$wangdianHashtable{'16022                           '}="541****";
$wangdianHashtable{'16024                           '}="541****";
$wangdianHashtable{'16026                           '}="541****";
$wangdianHashtable{'16028                           '}="541****";
$wangdianHashtable{'16030                           '}="541****";
$wangdianHashtable{'16032                           '}="541****";
$wangdianHashtable{'16034                           '}="541****";
$wangdianHashtable{'16036                           '}="541****";
$wangdianHashtable{'16038                           '}="541****";
$wangdianHashtable{'16040                           '}="541****";
$wangdianHashtable{'16041                           '}="541****";
$wangdianHashtable{'16042                           '}="541****";
$wangdianHashtable{'16043                           '}="541****";
$wangdianHashtable{'16045                           '}="541****";
$wangdianHashtable{'16046                           '}="541****";
$wangdianHashtable{'16047                           '}="541****";
$wangdianHashtable{'16049                           '}="541****";
$wangdianHashtable{'16051                           '}="541****";
$wangdianHashtable{'16053                           '}="541****";
$wangdianHashtable{'16055                           '}="541****";
$wangdianHashtable{'16057                           '}="541****";
$wangdianHashtable{'16058                           '}="541****";
$wangdianHashtable{'17001                           '}="541****";
$wangdianHashtable{'17003                           '}="541****";
$wangdianHashtable{'17004                           '}="541****";
$wangdianHashtable{'17005                           '}="541****";
$wangdianHashtable{'17007                           '}="541****";
$wangdianHashtable{'17008                           '}="541****";
$wangdianHashtable{'17010                           '}="541****";
$wangdianHashtable{'17011                           '}="541****";
$wangdianHashtable{'17013                           '}="541****";
$wangdianHashtable{'17017                           '}="541****";
$wangdianHashtable{'17019                           '}="541****";
$wangdianHashtable{'17021                           '}="541****";
$wangdianHashtable{'17023                           '}="541****";
$wangdianHashtable{'17025                           '}="541****";
$wangdianHashtable{'17027                           '}="541****";
$wangdianHashtable{'17029                           '}="541****";
$wangdianHashtable{'17031                           '}="541****";
$wangdianHashtable{'17033                           '}="541****";
$wangdianHashtable{'17035                           '}="541****";
$wangdianHashtable{'17037                           '}="541****";
$wangdianHashtable{'18001                           '}="541****";
$wangdianHashtable{'18003                           '}="541****";
$wangdianHashtable{'18004                           '}="541****";
$wangdianHashtable{'18006                           '}="541****";
$wangdianHashtable{'18008                           '}="541****";
$wangdianHashtable{'18010                           '}="541****";
$wangdianHashtable{'18012                           '}="541****";
$wangdianHashtable{'19001                           '}="541****";
$wangdianHashtable{'19003                           '}="541****";
$wangdianHashtable{'19005                           '}="541****";
$wangdianHashtable{'19007                           '}="541****";
$wangdianHashtable{'19009                           '}="541****";
$wangdianHashtable{'20001                           '}="541****";
$wangdianHashtable{'20003                           '}="541****";
$wangdianHashtable{'20006                           '}="541****";
$wangdianHashtable{'20008                           '}="541****";
$wangdianHashtable{'20010                           '}="541****";
$wangdianHashtable{'20012                           '}="541****";
$wangdianHashtable{'20014                           '}="541****";
$wangdianHashtable{'20016                           '}="541****";
$wangdianHashtable{'21001                           '}="541****";
$wangdianHashtable{'21003                           '}="541****";
$wangdianHashtable{'21004                           '}="541****";
$wangdianHashtable{'21006                           '}="541****";
$wangdianHashtable{'21007                           '}="541****";
$wangdianHashtable{'21009                           '}="541****";
$wangdianHashtable{'21011                           '}="541****";
$wangdianHashtable{'21013                           '}="541****";
$wangdianHashtable{'21014                           '}="541****";
$wangdianHashtable{'22001                           '}="541****";
$wangdianHashtable{'22003                           '}="541****";
$wangdianHashtable{'22004                           '}="541****";
$wangdianHashtable{'22005                           '}="541****";
$wangdianHashtable{'22006                           '}="541****";
$wangdianHashtable{'22007                           '}="541****";
$wangdianHashtable{'22009                           '}="541****";
$wangdianHashtable{'22011                           '}="541****";
$wangdianHashtable{'22013                           '}="541****";
$wangdianHashtable{'22014                           '}="541****";
$wangdianHashtable{'22016                           '}="541****";
$wangdianHashtable{'22019                           '}="541****";
$wangdianHashtable{'22021                           '}="541****";
$wangdianHashtable{'22022                           '}="541****";
$wangdianHashtable{'23001                           '}="541****";
$wangdianHashtable{'23003                           '}="541****";
$wangdianHashtable{'23007                           '}="541****";
$wangdianHashtable{'23008                           '}="541****";
$wangdianHashtable{'23010                           '}="541****";
$wangdianHashtable{'23012                           '}="541****";
$wangdianHashtable{'23013                           '}="541****";
$wangdianHashtable{'23014                           '}="541****";
$wangdianHashtable{'23015                           '}="541****";
$wangdianHashtable{'23016                           '}="541****";
$wangdianHashtable{'23019                           '}="541****";
$wangdianHashtable{'23020                           '}="541****";
$wangdianHashtable{'23021                           '}="541****";
$wangdianHashtable{'23022                           '}="541****";
$wangdianHashtable{'23023                           '}="541****";
$wangdianHashtable{'23025                           '}="541****";
$wangdianHashtable{'23027                           '}="541****";
$wangdianHashtable{'23030                           '}="541****";
$wangdianHashtable{'23033                           '}="541****";
$wangdianHashtable{'23036                           '}="541****";
$wangdianHashtable{'23037                           '}="541****";
$wangdianHashtable{'23039                           '}="541****";
$wangdianHashtable{'23040                           '}="541****";
$wangdianHashtable{'23042                           '}="541****";
$wangdianHashtable{'23043                           '}="541****";
$wangdianHashtable{'23044                           '}="541****";
$wangdianHashtable{'23047                           '}="541****";
$wangdianHashtable{'24004                           '}="541****";
$wangdianHashtable{'25001                           '}="541****";
$wangdianHashtable{'25003                           '}="541****";
$wangdianHashtable{'25004                           '}="541****";
$wangdianHashtable{'25005                           '}="541****";
$wangdianHashtable{'25006                           '}="541****";
$wangdianHashtable{'25007                           '}="541****";
$wangdianHashtable{'25010                           '}="541****";
$wangdianHashtable{'25011                           '}="541****";
$wangdianHashtable{'25012                           '}="541****";
$wangdianHashtable{'25013                           '}="541****";
$wangdianHashtable{'25014                           '}="541****";
$wangdianHashtable{'25015                           '}="541****";
$wangdianHashtable{'25016                           '}="541****";
$wangdianHashtable{'26001                           '}="541****";
$wangdianHashtable{'26003                           '}="541****";
$wangdianHashtable{'26004                           '}="541****";
$wangdianHashtable{'26005                           '}="541****";
$wangdianHashtable{'26006                           '}="541****";
$wangdianHashtable{'26007                           '}="541****";
$wangdianHashtable{'26010                           '}="541****";
$wangdianHashtable{'26011                           '}="541****";
$wangdianHashtable{'26012                           '}="541****";
$wangdianHashtable{'26013                           '}="541****";
$wangdianHashtable{'26014                           '}="541****";
$wangdianHashtable{'26015                           '}="541****";
$wangdianHashtable{'27001                           '}="541****";
$wangdianHashtable{'27003                           '}="541****";
$wangdianHashtable{'27004                           '}="541****";
$wangdianHashtable{'27005                           '}="541****";
$wangdianHashtable{'27010                           '}="541****";
$wangdianHashtable{'27011                           '}="541****";
$wangdianHashtable{'27012                           '}="541****";
$wangdianHashtable{'27014                           '}="541****";
$wangdianHashtable{'27017                           '}="541****";
$wangdianHashtable{'27019                           '}="541****";
$wangdianHashtable{'27020                           '}="541****";
$wangdianHashtable{'27022                           '}="541****";
$wangdianHashtable{'27024                           '}="541****";
$wangdianHashtable{'27027                           '}="541****";
$wangdianHashtable{'27028                           '}="541****";
$wangdianHashtable{'27029                           '}="541****";
$wangdianHashtable{'27030                           '}="541****";
$wangdianHashtable{'27031                           '}="541****";
$wangdianHashtable{'27032                           '}="541****";
$wangdianHashtable{'27033                           '}="541****";
$wangdianHashtable{'27034                           '}="541****";
$wangdianHashtable{'28001                           '}="541****";
$wangdianHashtable{'28003                           '}="541****";
$wangdianHashtable{'28004                           '}="541****";
$wangdianHashtable{'28005                           '}="541****";
$wangdianHashtable{'28006                           '}="541****";
$wangdianHashtable{'28007                           '}="541****";
$wangdianHashtable{'28008                           '}="541****";
$wangdianHashtable{'28009                           '}="541****";
$wangdianHashtable{'28010                           '}="541****";
$wangdianHashtable{'28011                           '}="541****";
$wangdianHashtable{'28013                           '}="541****";
$wangdianHashtable{'28015                           '}="541****";
$wangdianHashtable{'28017                           '}="541****";
$wangdianHashtable{'28023                           '}="541****";
$wangdianHashtable{'28025                           '}="541****";
$wangdianHashtable{'28027                           '}="541****";
$wangdianHashtable{'28028                           '}="541****";
$wangdianHashtable{'28029                           '}="541****";
$wangdianHashtable{'28031                           '}="541****";
$wangdianHashtable{'28032                           '}="541****";
$wangdianHashtable{'28033                           '}="541****";
$wangdianHashtable{'28034                           '}="541****";
$wangdianHashtable{'28036                           '}="541****";
$wangdianHashtable{'28038                           '}="541****";
$wangdianHashtable{'28039                           '}="541****";
$wangdianHashtable{'28041                           '}="541****";
$wangdianHashtable{'28043                           '}="541****";
$wangdianHashtable{'28045                           '}="541****";
$wangdianHashtable{'28047                           '}="541****";
$wangdianHashtable{'28049                           '}="541****";
$wangdianHashtable{'28052                           '}="541****";
$wangdianHashtable{'28053                           '}="541****";
$wangdianHashtable{'28054                           '}="541****";
$wangdianHashtable{'29001                           '}="541****";
$wangdianHashtable{'29003                           '}="541****";
$wangdianHashtable{'29005                           '}="541****";
$wangdianHashtable{'29007                           '}="541****";
$wangdianHashtable{'29008                           '}="541****";
$wangdianHashtable{'29009                           '}="541****";
$wangdianHashtable{'29010                           '}="541****";
$wangdianHashtable{'29012                           '}="541****";
$wangdianHashtable{'29013                           '}="541****";
$wangdianHashtable{'29016                           '}="541****";
$wangdianHashtable{'29018                           '}="541****";
$wangdianHashtable{'29020                           '}="541****";
$wangdianHashtable{'29022                           '}="541****";
$wangdianHashtable{'29024                           '}="541****";
$wangdianHashtable{'29026                           '}="541****";
$wangdianHashtable{'29030                           '}="541****";
$wangdianHashtable{'29032                           '}="541****";
$wangdianHashtable{'29034                           '}="541****";
$wangdianHashtable{'29036                           '}="541****";
$wangdianHashtable{'29037                           '}="541****";
$wangdianHashtable{'30001                           '}="541****";
$wangdianHashtable{'30003                           '}="541****";
$wangdianHashtable{'30004                           '}="541****";
$wangdianHashtable{'30005                           '}="541****";
$wangdianHashtable{'30007                           '}="541****";
$wangdianHashtable{'30009                           '}="541****";
$wangdianHashtable{'30010                           '}="541****";
$wangdianHashtable{'30011                           '}="541****";
$wangdianHashtable{'30013                           '}="541****";
$wangdianHashtable{'30015                           '}="541****";
$wangdianHashtable{'30017                           '}="541****";
$wangdianHashtable{'30019                           '}="541****";
$wangdianHashtable{'30021                           '}="541****";
$wangdianHashtable{'30022                           '}="541****";
$wangdianHashtable{'30024                           '}="541****";
$wangdianHashtable{'30026                           '}="541****";
$wangdianHashtable{'30027                           '}="541****";
$wangdianHashtable{'30029                           '}="541****";
$wangdianHashtable{'30031                           '}="541****";
$wangdianHashtable{'30032                           '}="541****";
$wangdianHashtable{'30034                           '}="541****";
$wangdianHashtable{'30036                           '}="541****";
$wangdianHashtable{'30038                           '}="541****";
$wangdianHashtable{'30040                           '}="541****";
$wangdianHashtable{'30042                           '}="541****";
$wangdianHashtable{'30044                           '}="541****";
$wangdianHashtable{'30046                           '}="541****";
$wangdianHashtable{'30048                           '}="541****";
$wangdianHashtable{'31001                           '}="541****";
$wangdianHashtable{'31003                           '}="541****";
$wangdianHashtable{'31004                           '}="541****";
$wangdianHashtable{'31007                           '}="541****";
$wangdianHashtable{'31008                           '}="541****";
$wangdianHashtable{'31009                           '}="541****";
$wangdianHashtable{'31010                           '}="541****";
$wangdianHashtable{'31012                           '}="541****";
$wangdianHashtable{'31013                           '}="541****";
$wangdianHashtable{'31014                           '}="541****";
$wangdianHashtable{'31015                           '}="541****";
$wangdianHashtable{'31017                           '}="541****";
$wangdianHashtable{'31019                           '}="541****";
$wangdianHashtable{'31021                           '}="541****";
$wangdianHashtable{'31023                           '}="541****";
$wangdianHashtable{'31025                           '}="541****";
$wangdianHashtable{'31027                           '}="541****";
$wangdianHashtable{'31029                           '}="541****";
$wangdianHashtable{'31031                           '}="541****";
$wangdianHashtable{'31033                           '}="541****";
$wangdianHashtable{'31035                           '}="541****";
$wangdianHashtable{'31036                           '}="541****";
$wangdianHashtable{'32001                           '}="541****";
$wangdianHashtable{'32003                           '}="541****";
$wangdianHashtable{'32004                           '}="541****";
$wangdianHashtable{'32005                           '}="541****";
$wangdianHashtable{'32006                           '}="541****";
$wangdianHashtable{'32007                           '}="541****";
$wangdianHashtable{'32008                           '}="541****";
$wangdianHashtable{'32009                           '}="541****";
$wangdianHashtable{'32010                           '}="541****";
$wangdianHashtable{'33001                           '}="541****";
$wangdianHashtable{'33003                           '}="541****";
$wangdianHashtable{'33005                           '}="541****";
$wangdianHashtable{'33006                           '}="541****";
$wangdianHashtable{'33008                           '}="541****";
$wangdianHashtable{'33009                           '}="541****";
$wangdianHashtable{'33010                           '}="541****";
$wangdianHashtable{'33011                           '}="541****";
$wangdianHashtable{'33012                           '}="541****";
$wangdianHashtable{'33014                           '}="541****";
$wangdianHashtable{'33016                           '}="541****";
$wangdianHashtable{'33017                           '}="541****";
$wangdianHashtable{'33019                           '}="541****";
$wangdianHashtable{'33021                           '}="541****";
$wangdianHashtable{'33022                           '}="541****";
$wangdianHashtable{'33024                           '}="541****";
$wangdianHashtable{'33025                           '}="541****";
$wangdianHashtable{'33027                           '}="541****";
$wangdianHashtable{'33028                           '}="541****";
$wangdianHashtable{'33029                           '}="541****";
$wangdianHashtable{'33031                           '}="541****";
$wangdianHashtable{'33032                           '}="541****";
$wangdianHashtable{'33034                           '}="541****";
$wangdianHashtable{'33035                           '}="541****";
$wangdianHashtable{'33037                           '}="541****";
$wangdianHashtable{'33038                           '}="541****";
$wangdianHashtable{'33039                           '}="541****";
$wangdianHashtable{'33040                           '}="541****";
$wangdianHashtable{'33041                           '}="541****";
$wangdianHashtable{'33043                           '}="541****";
$wangdianHashtable{'33044                           '}="541****";
$wangdianHashtable{'33046                           '}="541****";
$wangdianHashtable{'33050                           '}="541****";
$wangdianHashtable{'33051                           '}="541****";
$wangdianHashtable{'33053                           '}="541****";
$wangdianHashtable{'33054                           '}="541****";
$wangdianHashtable{'33055                           '}="541****";
$wangdianHashtable{'33057                           '}="541****";
$wangdianHashtable{'33060                           '}="541****";
$wangdianHashtable{'33061                           '}="541****";
$wangdianHashtable{'33063                           '}="541****";
$wangdianHashtable{'33064                           '}="541****";
$wangdianHashtable{'33065                           '}="541****";
$wangdianHashtable{'33066                           '}="541****";
$wangdianHashtable{'33069                           '}="541****";
$wangdianHashtable{'33070                           '}="541****";
$wangdianHashtable{'33072                           '}="541****";
$wangdianHashtable{'33073                           '}="541****";
$wangdianHashtable{'33075                           '}="541****";
$wangdianHashtable{'33076                           '}="541****";
$wangdianHashtable{'33078                           '}="541****";
$wangdianHashtable{'33079                           '}="541****";
$wangdianHashtable{'33080                           '}="541****";
$wangdianHashtable{'33081                           '}="541****";
$wangdianHashtable{'33082                           '}="541****";
$wangdianHashtable{'33084                           '}="541****";
$wangdianHashtable{'33086                           '}="541****";
$wangdianHashtable{'33087                           '}="541****";
$wangdianHashtable{'33089                           '}="541****";
$wangdianHashtable{'33090                           '}="541****";
$wangdianHashtable{'33091                           '}="541****";
$wangdianHashtable{'33095                           '}="541****";
$wangdianHashtable{'33097                           '}="541****";
$wangdianHashtable{'33098                           '}="541****";
$wangdianHashtable{'33099                           '}="541****";
$wangdianHashtable{'33100                           '}="541****";
$wangdianHashtable{'33101                           '}="541****";
$wangdianHashtable{'33102                           '}="541****";
$wangdianHashtable{'33103                           '}="541****";
$wangdianHashtable{'33105                           '}="541****";
$wangdianHashtable{'33106                           '}="541****";
$wangdianHashtable{'33107                           '}="541****";
$wangdianHashtable{'33108                           '}="541****";
$wangdianHashtable{'33110                           '}="541****";
$wangdianHashtable{'33111                           '}="541****";
$wangdianHashtable{'33112                           '}="541****";
$wangdianHashtable{'33114                           '}="541****";
$wangdianHashtable{'33115                           '}="541****";
$wangdianHashtable{'33117                           '}="541****";
$wangdianHashtable{'33118                           '}="541****";
$wangdianHashtable{'33119                           '}="541****";
$wangdianHashtable{'33120                           '}="541****";
$wangdianHashtable{'33121                           '}="541****";
$wangdianHashtable{'33123                           '}="541****";
$wangdianHashtable{'33124                           '}="541****";
$wangdianHashtable{'33125                           '}="541****";
$wangdianHashtable{'33126                           '}="541****";
$wangdianHashtable{'33128                           '}="541****";
$wangdianHashtable{'33129                           '}="541****";
$wangdianHashtable{'33130                           '}="541****";
$wangdianHashtable{'33131                           '}="541****";
$wangdianHashtable{'33133                           '}="541****";
$wangdianHashtable{'33134                           '}="541****";
$wangdianHashtable{'33135                           '}="541****";
$wangdianHashtable{'33136                           '}="541****";
$wangdianHashtable{'34001                           '}="541****";
$wangdianHashtable{'34003                           '}="541****";
$wangdianHashtable{'34004                           '}="541****";
$wangdianHashtable{'34005                           '}="541****";
$wangdianHashtable{'34006                           '}="541****";
$wangdianHashtable{'34007                           '}="541****";
$wangdianHashtable{'34010                           '}="541****";
$wangdianHashtable{'34011                           '}="541****";
$wangdianHashtable{'34012                           '}="541****";
$wangdianHashtable{'34014                           '}="541****";
$wangdianHashtable{'34016                           '}="541****";
$wangdianHashtable{'34018                           '}="541****";
$wangdianHashtable{'34021                           '}="541****";
$wangdianHashtable{'34024                           '}="541****";
$wangdianHashtable{'34026                           '}="541****";
$wangdianHashtable{'34029                           '}="541****";
$wangdianHashtable{'34030                           '}="541****";
$wangdianHashtable{'34033                           '}="541****";
$wangdianHashtable{'34034                           '}="541****";
$wangdianHashtable{'34039                           '}="541****";
$wangdianHashtable{'34040                           '}="541****";
$wangdianHashtable{'34042                           '}="541****";
$wangdianHashtable{'34045                           '}="541****";
$wangdianHashtable{'34046                           '}="541****";
$wangdianHashtable{'34047                           '}="541****";
$wangdianHashtable{'34048                           '}="541****";
$wangdianHashtable{'35001                           '}="541****";
$wangdianHashtable{'35003                           '}="541****";
$wangdianHashtable{'35004                           '}="541****";
$wangdianHashtable{'35005                           '}="541****";
$wangdianHashtable{'35006                           '}="541****";
$wangdianHashtable{'35007                           '}="541****";
$wangdianHashtable{'35008                           '}="541****";
$wangdianHashtable{'35009                           '}="541****";
$wangdianHashtable{'35011                           '}="541****";
$wangdianHashtable{'35012                           '}="541****";
$wangdianHashtable{'35014                           '}="541****";
$wangdianHashtable{'35015                           '}="541****";
$wangdianHashtable{'35017                           '}="541****";
$wangdianHashtable{'35019                           '}="541****";
$wangdianHashtable{'35022                           '}="541****";
$wangdianHashtable{'35024                           '}="541****";
$wangdianHashtable{'35025                           '}="541****";
$wangdianHashtable{'35026                           '}="541****";
$wangdianHashtable{'35027                           '}="541****";
$wangdianHashtable{'35028                           '}="541****";
$wangdianHashtable{'35029                           '}="541****";
$wangdianHashtable{'35031                           '}="541****";
$wangdianHashtable{'35032                           '}="541****";
$wangdianHashtable{'35034                           '}="541****";
$wangdianHashtable{'35036                           '}="541****";
$wangdianHashtable{'35038                           '}="541****";
$wangdianHashtable{'35039                           '}="541****";
$wangdianHashtable{'35040                           '}="541****";
$wangdianHashtable{'35041                           '}="541****";
$wangdianHashtable{'35044                           '}="541****";
$wangdianHashtable{'35045                           '}="541****";
$wangdianHashtable{'35047                           '}="541****";
$wangdianHashtable{'35049                           '}="541****";
$wangdianHashtable{'35052                           '}="541****";
$wangdianHashtable{'35053                           '}="541****";
$wangdianHashtable{'35054                           '}="541****";
$wangdianHashtable{'35055                           '}="541****";
$wangdianHashtable{'35057                           '}="541****";
$wangdianHashtable{'35058                           '}="541****";
$wangdianHashtable{'35060                           '}="541****";
$wangdianHashtable{'35061                           '}="541****";
$wangdianHashtable{'35062                           '}="541****";
$wangdianHashtable{'35063                           '}="541****";
$wangdianHashtable{'35064                           '}="541****";
$wangdianHashtable{'35065                           '}="541****";
$wangdianHashtable{'36001                           '}="541****";
$wangdianHashtable{'36003                           '}="541****";
$wangdianHashtable{'36004                           '}="541****";
$wangdianHashtable{'36006                           '}="541****";
$wangdianHashtable{'36007                           '}="541****";
$wangdianHashtable{'36012                           '}="541****";
$wangdianHashtable{'36013                           '}="541****";
$wangdianHashtable{'36016                           '}="541****";
$wangdianHashtable{'36018                           '}="541****";
$wangdianHashtable{'36020                           '}="541****";
$wangdianHashtable{'36026                           '}="541****";
$wangdianHashtable{'36028                           '}="541****";
$wangdianHashtable{'36029                           '}="541****";
$wangdianHashtable{'36030                           '}="541****";
$wangdianHashtable{'36032                           '}="541****";
$wangdianHashtable{'36033                           '}="541****";
$wangdianHashtable{'36035                           '}="541****";
$wangdianHashtable{'36036                           '}="541****";
$wangdianHashtable{'36038                           '}="541****";
$wangdianHashtable{'36040                           '}="541****";
$wangdianHashtable{'36042                           '}="541****";
$wangdianHashtable{'36044                           '}="541****";
$wangdianHashtable{'36046                           '}="541****";
$wangdianHashtable{'36048                           '}="541****";
$wangdianHashtable{'36049                           '}="541****";
$wangdianHashtable{'37001                           '}="541****";
$wangdianHashtable{'37003                           '}="541****";
$wangdianHashtable{'37004                           '}="541****";
$wangdianHashtable{'37005                           '}="541****";
$wangdianHashtable{'37006                           '}="541****";
$wangdianHashtable{'37007                           '}="541****";
$wangdianHashtable{'37009                           '}="541****";
$wangdianHashtable{'37010                           '}="541****";
$wangdianHashtable{'37011                           '}="541****";
$wangdianHashtable{'37014                           '}="541****";
$wangdianHashtable{'37015                           '}="541****";
$wangdianHashtable{'37016                           '}="541****";
$wangdianHashtable{'37018                           '}="541****";
$wangdianHashtable{'37019                           '}="541****";
$wangdianHashtable{'37020                           '}="541****";
$wangdianHashtable{'37022                           '}="541****";
$wangdianHashtable{'37024                           '}="541****";
$wangdianHashtable{'37025                           '}="541****";
$wangdianHashtable{'37027                           '}="541****";
$wangdianHashtable{'37029                           '}="541****";
$wangdianHashtable{'37031                           '}="541****";
$wangdianHashtable{'37033                           '}="541****";
$wangdianHashtable{'37035                           '}="541****";
$wangdianHashtable{'37037                           '}="541****";
$wangdianHashtable{'37039                           '}="541****";
$wangdianHashtable{'37041                           '}="541****";
$wangdianHashtable{'37043                           '}="541****";
$wangdianHashtable{'37045                           '}="541****";
$wangdianHashtable{'37047                           '}="541****";
$wangdianHashtable{'37049                           '}="541****";
$wangdianHashtable{'37050                           '}="541****";
$wangdianHashtable{'37051                           '}="541****";
$wangdianHashtable{'37054                           '}="541****";
$wangdianHashtable{'37056                           '}="541****";
$wangdianHashtable{'37058                           '}="541****";
$wangdianHashtable{'37060                           '}="541****";
$wangdianHashtable{'37062                           '}="541****";
$wangdianHashtable{'37064                           '}="541****";
$wangdianHashtable{'37066                           '}="541****";
$wangdianHashtable{'37068                           '}="541****";
$wangdianHashtable{'37070                           '}="541****";
$wangdianHashtable{'37072                           '}="541****";
$wangdianHashtable{'37073                           '}="541****";
$wangdianHashtable{'37075                           '}="541****";
$wangdianHashtable{'38001                           '}="541****";
$wangdianHashtable{'38003                           '}="541****";
$wangdianHashtable{'38005                           '}="541****";
$wangdianHashtable{'38007                           '}="541****";
$wangdianHashtable{'38009                           '}="541****";
$wangdianHashtable{'38011                           '}="541****";
$wangdianHashtable{'38013                           '}="541****";
$wangdianHashtable{'38015                           '}="541****";
$wangdianHashtable{'38018                           '}="541****";
$wangdianHashtable{'38020                           '}="541****";
$wangdianHashtable{'38022                           '}="541****";
$wangdianHashtable{'38024                           '}="541****";
$wangdianHashtable{'38026                           '}="541****";
$wangdianHashtable{'38028                           '}="541****";
$wangdianHashtable{'38029                           '}="541****";
$wangdianHashtable{'38030                           '}="541****";
$wangdianHashtable{'38031                           '}="541****";
$wangdianHashtable{'38032                           '}="541****";
$wangdianHashtable{'38033                           '}="541****";
$wangdianHashtable{'39001                           '}="541****";
$wangdianHashtable{'39003                           '}="541****";
$wangdianHashtable{'39004                           '}="541****";
$wangdianHashtable{'39005                           '}="541****";
$wangdianHashtable{'39006                           '}="541****";
$wangdianHashtable{'39008                           '}="541****";
$wangdianHashtable{'39009                           '}="541****";
$wangdianHashtable{'39011                           '}="541****";
$wangdianHashtable{'39013                           '}="541****";
$wangdianHashtable{'39014                           '}="541****";
$wangdianHashtable{'39015                           '}="541****";
$wangdianHashtable{'39017                           '}="541****";
$wangdianHashtable{'39021                           '}="541****";
$wangdianHashtable{'39023                           '}="541****";
$wangdianHashtable{'39025                           '}="541****";
$wangdianHashtable{'39027                           '}="541****";
$wangdianHashtable{'39029                           '}="541****";
$wangdianHashtable{'39031                           '}="541****";
$wangdianHashtable{'39033                           '}="541****";
$wangdianHashtable{'39035                           '}="541****";
$wangdianHashtable{'39037                           '}="541****";
$wangdianHashtable{'39041                           '}="541****";
$wangdianHashtable{'39047                           '}="541****";
$wangdianHashtable{'39049                           '}="541****";
$wangdianHashtable{'40001                           '}="541****";
$wangdianHashtable{'40003                           '}="541****";
$wangdianHashtable{'40004                           '}="541****";
$wangdianHashtable{'40005                           '}="541****";
$wangdianHashtable{'40006                           '}="541****";
$wangdianHashtable{'40008                           '}="541****";
$wangdianHashtable{'40009                           '}="541****";
$wangdianHashtable{'40011                           '}="541****";
$wangdianHashtable{'40012                           '}="541****";
$wangdianHashtable{'40013                           '}="541****";
$wangdianHashtable{'40014                           '}="541****";
$wangdianHashtable{'40016                           '}="541****";
$wangdianHashtable{'40017                           '}="541****";
$wangdianHashtable{'40018                           '}="541****";
$wangdianHashtable{'40020                           '}="541****";
$wangdianHashtable{'40021                           '}="541****";
$wangdianHashtable{'40022                           '}="541****";
$wangdianHashtable{'40023                           '}="541****";
$wangdianHashtable{'40024                           '}="541****";
$wangdianHashtable{'40025                           '}="541****";
$wangdianHashtable{'40026                           '}="541****";
$wangdianHashtable{'40027                           '}="541****";
$wangdianHashtable{'40028                           '}="541****";
$wangdianHashtable{'40030                           '}="541****";
$wangdianHashtable{'40031                           '}="541****";
$wangdianHashtable{'40032                           '}="541****";
$wangdianHashtable{'40033                           '}="541****";
$wangdianHashtable{'40034                           '}="541****";
$wangdianHashtable{'40035                           '}="541****";
$wangdianHashtable{'40036                           '}="541****";
$wangdianHashtable{'40037                           '}="541****";
$wangdianHashtable{'40038                           '}="541****";
$wangdianHashtable{'40039                           '}="541****";
$wangdianHashtable{'40052                           '}="541****";
$wangdianHashtable{'40053                           '}="541****";
$wangdianHashtable{'40054                           '}="541****";
$wangdianHashtable{'40055                           '}="541****";
$wangdianHashtable{'41001                           '}="541****";
$wangdianHashtable{'41003                           '}="541****";
$wangdianHashtable{'41004                           '}="541****";
$wangdianHashtable{'41006                           '}="541****";
$wangdianHashtable{'41007                           '}="541****";
$wangdianHashtable{'41010                           '}="541****";
$wangdianHashtable{'41011                           '}="541****";
$wangdianHashtable{'41012                           '}="541****";
$wangdianHashtable{'41013                           '}="541****";
$wangdianHashtable{'41016                           '}="541****";
$wangdianHashtable{'41019                           '}="541****";
$wangdianHashtable{'41021                           '}="541****";
$wangdianHashtable{'41023                           '}="541****";
$wangdianHashtable{'41025                           '}="541****";
$wangdianHashtable{'41027                           '}="541****";
$wangdianHashtable{'41029                           '}="541****";
$wangdianHashtable{'41031                           '}="541****";
$wangdianHashtable{'41034                           '}="541****";
$wangdianHashtable{'41035                           '}="541****";
$wangdianHashtable{'41037                           '}="541****";
$wangdianHashtable{'41039                           '}="541****";
$wangdianHashtable{'41040                           '}="541****";
$wangdianHashtable{'41041                           '}="541****";
$wangdianHashtable{'41043                           '}="541****";
$wangdianHashtable{'41044                           '}="541****";
$wangdianHashtable{'41046                           '}="541****";
$wangdianHashtable{'41047                           '}="541****";
$wangdianHashtable{'41050                           '}="541****";
$wangdianHashtable{'41052                           '}="541****";
$wangdianHashtable{'41054                           '}="541****";
$wangdianHashtable{'41056                           '}="541****";
$wangdianHashtable{'41058                           '}="541****";
$wangdianHashtable{'41060                           '}="541****";
$wangdianHashtable{'41062                           '}="541****";
$wangdianHashtable{'41064                           '}="541****";
$wangdianHashtable{'41069                           '}="541****";
$wangdianHashtable{'41071                           '}="541****";
$wangdianHashtable{'41073                           '}="541****";
$wangdianHashtable{'41076                           '}="541****";
$wangdianHashtable{'41078                           '}="541****";
$wangdianHashtable{'41081                           '}="541****";
$wangdianHashtable{'41082                           '}="541****";
$wangdianHashtable{'41083                           '}="541****";
$wangdianHashtable{'41084                           '}="541****";
$wangdianHashtable{'41085                           '}="541****";
$wangdianHashtable{'41093                           '}="541****";
$wangdianHashtable{'41095                           '}="541****";
$wangdianHashtable{'41096                           '}="541****";
$wangdianHashtable{'41098                           '}="541****";
$wangdianHashtable{'41104                           '}="541****";
$wangdianHashtable{'41108                           '}="541****";
$wangdianHashtable{'41110                           '}="541****";
$wangdianHashtable{'41112                           '}="541****";
$wangdianHashtable{'41116                           '}="541****";
$wangdianHashtable{'41117                           '}="541****";
$wangdianHashtable{'41118                           '}="541****";
$wangdianHashtable{'41119                           '}="541****";
$wangdianHashtable{'41120                           '}="541****";
$wangdianHashtable{'41121                           '}="541****";
$wangdianHashtable{'41132                           '}="541****";
$wangdianHashtable{'41133                           '}="541****";
$wangdianHashtable{'42001                           '}="541****";
$wangdianHashtable{'42003                           '}="541****";
$wangdianHashtable{'42004                           '}="541****";
$wangdianHashtable{'42005                           '}="541****";
$wangdianHashtable{'42007                           '}="541****";
$wangdianHashtable{'42011                           '}="541****";
$wangdianHashtable{'42013                           '}="541****";
$wangdianHashtable{'42017                           '}="541****";
$wangdianHashtable{'42018                           '}="541****";
$wangdianHashtable{'42019                           '}="541****";
$wangdianHashtable{'42020                           '}="541****";
$wangdianHashtable{'42022                           '}="541****";
$wangdianHashtable{'42024                           '}="541****";
$wangdianHashtable{'42027                           '}="541****";
$wangdianHashtable{'42029                           '}="541****";
$wangdianHashtable{'42030                           '}="541****";
$wangdianHashtable{'42031                           '}="541****";
$wangdianHashtable{'42032                           '}="541****";
$wangdianHashtable{'42033                           '}="541****";
$wangdianHashtable{'42034                           '}="541****";
$wangdianHashtable{'42035                           '}="541****";
$wangdianHashtable{'42037                           '}="541****";
$wangdianHashtable{'42040                           '}="541****";
$wangdianHashtable{'42041                           '}="541****";
$wangdianHashtable{'42042                           '}="541****";
$wangdianHashtable{'42045                           '}="541****";
$wangdianHashtable{'42048                           '}="541****";
$wangdianHashtable{'42050                           '}="541****";
$wangdianHashtable{'42054                           '}="541****";
$wangdianHashtable{'42056                           '}="541****";
$wangdianHashtable{'42058                           '}="541****";
$wangdianHashtable{'42060                           '}="541****";
$wangdianHashtable{'42062                           '}="541****";
$wangdianHashtable{'42064                           '}="541****";
$wangdianHashtable{'43001                           '}="541****";
$wangdianHashtable{'43003                           '}="541****";
$wangdianHashtable{'43005                           '}="541****";
$wangdianHashtable{'43006                           '}="541****";
$wangdianHashtable{'43007                           '}="541****";
$wangdianHashtable{'43008                           '}="541****";
$wangdianHashtable{'43009                           '}="541****";
$wangdianHashtable{'43010                           '}="541****";
$wangdianHashtable{'43011                           '}="541****";
$wangdianHashtable{'43012                           '}="541****";
$wangdianHashtable{'43014                           '}="541****";
$wangdianHashtable{'43015                           '}="541****";
$wangdianHashtable{'43016                           '}="541****";
$wangdianHashtable{'43018                           '}="541****";
$wangdianHashtable{'43020                           '}="541****";
$wangdianHashtable{'43022                           '}="541****";
$wangdianHashtable{'43024                           '}="541****";
$wangdianHashtable{'43026                           '}="541****";
$wangdianHashtable{'43028                           '}="541****";
$wangdianHashtable{'43030                           '}="541****";
$wangdianHashtable{'43032                           '}="541****";
$wangdianHashtable{'43034                           '}="541****";
$wangdianHashtable{'43045                           '}="541****";
$wangdianHashtable{'43047                           '}="541****";
$wangdianHashtable{'43049                           '}="541****";
$wangdianHashtable{'43051                           '}="541****";
$wangdianHashtable{'43053                           '}="541****";
$wangdianHashtable{'43055                           '}="541****";
$wangdianHashtable{'43057                           '}="541****";
$wangdianHashtable{'43059                           '}="541****";
$wangdianHashtable{'44001                           '}="541****";
$wangdianHashtable{'44003                           '}="541****";
$wangdianHashtable{'44005                           '}="541****";
$wangdianHashtable{'44006                           '}="541****";
$wangdianHashtable{'44007                           '}="541****";
$wangdianHashtable{'44008                           '}="541****";
$wangdianHashtable{'44009                           '}="541****";
$wangdianHashtable{'44010                           '}="541****";
$wangdianHashtable{'44011                           '}="541****";
$wangdianHashtable{'44012                           '}="541****";
$wangdianHashtable{'44013                           '}="541****";
$wangdianHashtable{'44014                           '}="541****";
$wangdianHashtable{'44015                           '}="541****";
$wangdianHashtable{'44016                           '}="541****";
$wangdianHashtable{'44017                           '}="541****";
$wangdianHashtable{'44019                           '}="541****";
$wangdianHashtable{'44021                           '}="541****";
$wangdianHashtable{'44023                           '}="541****";
$wangdianHashtable{'44025                           '}="541****";
$wangdianHashtable{'44026                           '}="541****";
$wangdianHashtable{'44028                           '}="541****";
$wangdianHashtable{'44030                           '}="541****";
$wangdianHashtable{'44033                           '}="541****";
$wangdianHashtable{'44035                           '}="541****";
$wangdianHashtable{'44037                           '}="541****";
$wangdianHashtable{'44039                           '}="541****";
$wangdianHashtable{'44041                           '}="541****";
$wangdianHashtable{'44043                           '}="541****";
$wangdianHashtable{'44046                           '}="541****";
$wangdianHashtable{'44048                           '}="541****";
$wangdianHashtable{'44049                           '}="541****";
$wangdianHashtable{'45001                           '}="541****";
$wangdianHashtable{'45003                           '}="541****";
$wangdianHashtable{'45004                           '}="541****";
$wangdianHashtable{'45006                           '}="541****";
$wangdianHashtable{'45008                           '}="541****";
$wangdianHashtable{'45010                           '}="541****";
$wangdianHashtable{'45012                           '}="541****";
$wangdianHashtable{'45013                           '}="541****";
$wangdianHashtable{'45015                           '}="541****";
$wangdianHashtable{'45017                           '}="541****";
$wangdianHashtable{'45019                           '}="541****";
$wangdianHashtable{'45021                           '}="541****";
$wangdianHashtable{'45023                           '}="541****";
$wangdianHashtable{'45024                           '}="541****";
$wangdianHashtable{'45025                           '}="541****";
$wangdianHashtable{'45026                           '}="541****";
$wangdianHashtable{'45027                           '}="541****";
$wangdianHashtable{'45031                           '}="541****";
$wangdianHashtable{'45032                           '}="541****";
$wangdianHashtable{'45033                           '}="541****";
$wangdianHashtable{'46001                           '}="541****";
$wangdianHashtable{'46003                           '}="541****";
$wangdianHashtable{'46004                           '}="541****";
$wangdianHashtable{'46005                           '}="541****";
$wangdianHashtable{'46007                           '}="541****";
$wangdianHashtable{'46009                           '}="541****";
$wangdianHashtable{'46010                           '}="541****";
$wangdianHashtable{'46012                           '}="541****";
$wangdianHashtable{'46016                           '}="541****";
$wangdianHashtable{'46018                           '}="541****";
$wangdianHashtable{'46020                           '}="541****";
$wangdianHashtable{'46022                           '}="541****";
$wangdianHashtable{'46024                           '}="541****";
$wangdianHashtable{'46025                           '}="541****";
$wangdianHashtable{'46026                           '}="541****";
$wangdianHashtable{'46027                           '}="541****";
$wangdianHashtable{'46028                           '}="541****";
$wangdianHashtable{'46029                           '}="541****";
$wangdianHashtable{'46031                           '}="541****";
$wangdianHashtable{'47001                           '}="541****";
$wangdianHashtable{'47003                           '}="541****";
$wangdianHashtable{'47005                           '}="541****";
$wangdianHashtable{'47006                           '}="541****";
$wangdianHashtable{'47007                           '}="541****";
$wangdianHashtable{'47009                           '}="541****";
$wangdianHashtable{'47010                           '}="541****";
$wangdianHashtable{'47011                           '}="541****";
$wangdianHashtable{'47013                           '}="541****";
$wangdianHashtable{'47015                           '}="541****";
$wangdianHashtable{'47017                           '}="541****";
$wangdianHashtable{'47019                           '}="541****";
$wangdianHashtable{'47021                           '}="541****";
$wangdianHashtable{'47023                           '}="541****";
$wangdianHashtable{'47025                           '}="541****";
$wangdianHashtable{'47027                           '}="541****";
$wangdianHashtable{'47029                           '}="541****";
$wangdianHashtable{'47031                           '}="541****";
$wangdianHashtable{'47033                           '}="541****";
$wangdianHashtable{'47035                           '}="541****";
$wangdianHashtable{'47037                           '}="541****";
$wangdianHashtable{'47039                           '}="541****";
$wangdianHashtable{'47041                           '}="541****";
$wangdianHashtable{'47047                           '}="541****";
$wangdianHashtable{'47049                           '}="541****";
$wangdianHashtable{'47051                           '}="541****";
$wangdianHashtable{'47053                           '}="541****";
$wangdianHashtable{'48001                           '}="541****";
$wangdianHashtable{'48003                           '}="541****";
$wangdianHashtable{'48005                           '}="541****";
$wangdianHashtable{'48006                           '}="541****";
$wangdianHashtable{'48007                           '}="541****";
$wangdianHashtable{'48008                           '}="541****";
$wangdianHashtable{'48009                           '}="541****";
$wangdianHashtable{'48010                           '}="541****";
$wangdianHashtable{'48012                           '}="541****";
$wangdianHashtable{'48013                           '}="541****";
$wangdianHashtable{'48014                           '}="541****";
$wangdianHashtable{'48015                           '}="541****";
$wangdianHashtable{'48016                           '}="541****";
$wangdianHashtable{'48018                           '}="541****";
$wangdianHashtable{'48020                           '}="541****";
$wangdianHashtable{'48022                           '}="541****";
$wangdianHashtable{'48025                           '}="541****";
$wangdianHashtable{'48027                           '}="541****";
$wangdianHashtable{'48029                           '}="541****";
$wangdianHashtable{'48032                           '}="541****";
$wangdianHashtable{'48034                           '}="541****";
$wangdianHashtable{'48036                           '}="541****";
$wangdianHashtable{'48040                           '}="541****";
$wangdianHashtable{'48042                           '}="541****";
$wangdianHashtable{'48044                           '}="541****";
$wangdianHashtable{'48046                           '}="541****";
$wangdianHashtable{'48048                           '}="541****";
$wangdianHashtable{'48050                           '}="541****";
$wangdianHashtable{'48052                           '}="541****";
$wangdianHashtable{'48054                           '}="541****";
$wangdianHashtable{'48056                           '}="541****";
$wangdianHashtable{'48058                           '}="541****";
$wangdianHashtable{'48060                           '}="541****";
$wangdianHashtable{'48061                           '}="541****";
$wangdianHashtable{'48065                           '}="541****";
$wangdianHashtable{'48066                           '}="541****";
$wangdianHashtable{'49001                           '}="541****";
$wangdianHashtable{'49003                           '}="541****";
$wangdianHashtable{'49004                           '}="541****";
$wangdianHashtable{'49005                           '}="541****";
$wangdianHashtable{'49006                           '}="541****";
$wangdianHashtable{'49008                           '}="541****";
$wangdianHashtable{'49010                           '}="541****";
$wangdianHashtable{'49013                           '}="541****";
$wangdianHashtable{'49016                           '}="541****";
$wangdianHashtable{'49018                           '}="541****";
$wangdianHashtable{'49019                           '}="541****";
$wangdianHashtable{'49020                           '}="541****";
$wangdianHashtable{'49021                           '}="541****";
$wangdianHashtable{'49023                           '}="541****";
$wangdianHashtable{'49025                           '}="541****";
$wangdianHashtable{'49027                           '}="541****";
$wangdianHashtable{'49029                           '}="541****";
$wangdianHashtable{'49031                           '}="541****";
$wangdianHashtable{'49032                           '}="541****";
$wangdianHashtable{'49033                           '}="541****";
$wangdianHashtable{'49034                           '}="541****";
$wangdianHashtable{'49037                           '}="541****";
$wangdianHashtable{'49040                           '}="541****";
$wangdianHashtable{'49042                           '}="541****";
$wangdianHashtable{'49043                           '}="541****";
$wangdianHashtable{'49045                           '}="541****";
$wangdianHashtable{'49046                           '}="541****";
$wangdianHashtable{'49050                           '}="541****";
$wangdianHashtable{'49052                           '}="541****";
$wangdianHashtable{'49054                           '}="541****";
$wangdianHashtable{'49056                           '}="541****";
$wangdianHashtable{'49059                           '}="541****";
$wangdianHashtable{'49062                           '}="541****";
$wangdianHashtable{'49066                           '}="541****";
$wangdianHashtable{'50001                           '}="541****";
$wangdianHashtable{'50003                           '}="541****";
$wangdianHashtable{'50005                           '}="541****";
$wangdianHashtable{'50007                           '}="541****";
$wangdianHashtable{'50008                           '}="541****";
$wangdianHashtable{'50009                           '}="541****";
$wangdianHashtable{'50011                           '}="541****";
$wangdianHashtable{'50013                           '}="541****";
$wangdianHashtable{'50015                           '}="541****";
$wangdianHashtable{'50016                           '}="541****";
$wangdianHashtable{'50018                           '}="541****";
$wangdianHashtable{'50020                           '}="541****";
$wangdianHashtable{'50022                           '}="541****";
$wangdianHashtable{'50024                           '}="541****";
$wangdianHashtable{'50026                           '}="541****";
$wangdianHashtable{'50028                           '}="541****";
$wangdianHashtable{'50030                           '}="541****";
$wangdianHashtable{'50032                           '}="541****";
$wangdianHashtable{'50034                           '}="541****";
$wangdianHashtable{'50035                           '}="541****";
$wangdianHashtable{'50036                           '}="541****";
$wangdianHashtable{'50038                           '}="541****";
$wangdianHashtable{'50039                           '}="541****";
$wangdianHashtable{'50040                           '}="541****";
$wangdianHashtable{'50041                           '}="541****";
$wangdianHashtable{'50042                           '}="541****";
$wangdianHashtable{'50044                           '}="541****";
$wangdianHashtable{'50045                           '}="541****";
$wangdianHashtable{'50046                           '}="541****";
$wangdianHashtable{'50047                           '}="541****";
$wangdianHashtable{'50048                           '}="541****";
$wangdianHashtable{'50049                           '}="541****";
$wangdianHashtable{'50050                           '}="541****";
$wangdianHashtable{'50051                           '}="541****";
$wangdianHashtable{'50052                           '}="541****";
$wangdianHashtable{'50054                           '}="541****";
$wangdianHashtable{'50056                           '}="541****";
$wangdianHashtable{'50058                           '}="541****";
$wangdianHashtable{'50060                           '}="541****";
$wangdianHashtable{'50062                           '}="541****";
$wangdianHashtable{'50064                           '}="541****";
$wangdianHashtable{'50066                           '}="541****";
$wangdianHashtable{'50068                           '}="541****";
$wangdianHashtable{'50070                           '}="541****";
$wangdianHashtable{'50072                           '}="541****";
$wangdianHashtable{'51001                           '}="541****";
$wangdianHashtable{'51003                           '}="541****";
$wangdianHashtable{'51005                           '}="541****";
$wangdianHashtable{'51007                           '}="541****";
$wangdianHashtable{'51008                           '}="541****";
$wangdianHashtable{'51009                           '}="541****";
$wangdianHashtable{'51010                           '}="541****";
$wangdianHashtable{'51011                           '}="541****";
$wangdianHashtable{'51012                           '}="541****";
$wangdianHashtable{'51013                           '}="541****";
$wangdianHashtable{'51015                           '}="541****";
$wangdianHashtable{'51017                           '}="541****";
$wangdianHashtable{'51019                           '}="541****";
$wangdianHashtable{'51021                           '}="541****";
$wangdianHashtable{'51023                           '}="541****";
$wangdianHashtable{'51025                           '}="541****";
$wangdianHashtable{'51027                           '}="541****";
$wangdianHashtable{'51029                           '}="541****";
$wangdianHashtable{'51031                           '}="541****";
$wangdianHashtable{'51033                           '}="541****";
$wangdianHashtable{'51035                           '}="541****";
$wangdianHashtable{'51037                           '}="541****";
$wangdianHashtable{'51039                           '}="541****";
$wangdianHashtable{'51041                           '}="541****";
$wangdianHashtable{'51043                           '}="541****";
$wangdianHashtable{'51045                           '}="541****";
$wangdianHashtable{'51047                           '}="541****";
$wangdianHashtable{'51049                           '}="541****";
$wangdianHashtable{'51053                           '}="541****";
$wangdianHashtable{'51055                           '}="541****";
$wangdianHashtable{'51061                           '}="541****";
$wangdianHashtable{'51069                           '}="541****";
$wangdianHashtable{'52001                           '}="541****";
$wangdianHashtable{'52003                           '}="541****";
$wangdianHashtable{'52004                           '}="541****";
$wangdianHashtable{'52005                           '}="541****";
$wangdianHashtable{'52006                           '}="541****";
$wangdianHashtable{'52007                           '}="541****";
$wangdianHashtable{'52008                           '}="541****";
$wangdianHashtable{'52009                           '}="541****";
$wangdianHashtable{'52010                           '}="541****";
$wangdianHashtable{'52011                           '}="541****";
$wangdianHashtable{'52013                           '}="541****";
$wangdianHashtable{'52016                           '}="541****";
$wangdianHashtable{'52018                           '}="541****";
$wangdianHashtable{'52020                           '}="541****";
$wangdianHashtable{'52021                           '}="541****";
$wangdianHashtable{'52024                           '}="541****";
$wangdianHashtable{'52026                           '}="541****";
$wangdianHashtable{'52027                           '}="541****";
$wangdianHashtable{'52028                           '}="541****";
$wangdianHashtable{'52029                           '}="541****";
$wangdianHashtable{'52031                           '}="541****";
$wangdianHashtable{'52032                           '}="541****";
$wangdianHashtable{'52033                           '}="541****";
$wangdianHashtable{'52035                           '}="541****";
$wangdianHashtable{'52036                           '}="541****";
$wangdianHashtable{'53001                           '}="541****";
$wangdianHashtable{'53003                           '}="541****";
$wangdianHashtable{'53005                           '}="541****";
$wangdianHashtable{'53007                           '}="541****";
$wangdianHashtable{'53009                           '}="541****";
$wangdianHashtable{'53011                           '}="541****";
$wangdianHashtable{'53013                           '}="541****";
$wangdianHashtable{'53015                           '}="541****";
$wangdianHashtable{'53016                           '}="541****";
$wangdianHashtable{'53017                           '}="541****";
$wangdianHashtable{'53019                           '}="541****";
$wangdianHashtable{'54001                           '}="541****";
$wangdianHashtable{'54003                           '}="541****";
$wangdianHashtable{'54007                           '}="541****";
$wangdianHashtable{'54009                           '}="541****";
$wangdianHashtable{'54011                           '}="541****";
$wangdianHashtable{'54013                           '}="541****";
$wangdianHashtable{'54015                           '}="541****";
$wangdianHashtable{'54017                           '}="541****";
$wangdianHashtable{'54019                           '}="541****";
$wangdianHashtable{'54020                           '}="541****";
$wangdianHashtable{'54021                           '}="541****";
$wangdianHashtable{'54023                           '}="541****";
$wangdianHashtable{'54024                           '}="541****";
$wangdianHashtable{'54025                           '}="541****";
$wangdianHashtable{'54027                           '}="541****";
$wangdianHashtable{'54028                           '}="541****";
$wangdianHashtable{'54029                           '}="541****";
$wangdianHashtable{'54030                           '}="541****";
$wangdianHashtable{'55001                           '}="541****";
$wangdianHashtable{'55003                           '}="541****";
$wangdianHashtable{'55004                           '}="541****";
$wangdianHashtable{'55005                           '}="541****";
$wangdianHashtable{'55007                           '}="541****";
$wangdianHashtable{'55009                           '}="541****";
$wangdianHashtable{'55011                           '}="541****";
$wangdianHashtable{'55014                           '}="541****";
$wangdianHashtable{'55015                           '}="541****";
$wangdianHashtable{'55016                           '}="541****";
$wangdianHashtable{'55018                           '}="541****";
$wangdianHashtable{'55019                           '}="541****";
$wangdianHashtable{'55020                           '}="541****";
$wangdianHashtable{'56001                           '}="541****";
$wangdianHashtable{'56003                           '}="541****";
$wangdianHashtable{'56004                           '}="541****";
$wangdianHashtable{'56005                           '}="541****";
$wangdianHashtable{'56007                           '}="541****";
$wangdianHashtable{'56009                           '}="541****";
$wangdianHashtable{'56013                           '}="541****";
$wangdianHashtable{'56015                           '}="541****";
$wangdianHashtable{'56017                           '}="541****";
$wangdianHashtable{'56019                           '}="541****";
$wangdianHashtable{'57001                           '}="541****";
$wangdianHashtable{'57003                           '}="541****";
$wangdianHashtable{'57004                           '}="541****";
$wangdianHashtable{'57005                           '}="541****";
$wangdianHashtable{'57006                           '}="541****";
$wangdianHashtable{'57008                           '}="541****";
$wangdianHashtable{'57010                           '}="541****";
$wangdianHashtable{'57012                           '}="541****";
$wangdianHashtable{'57014                           '}="541****";
$wangdianHashtable{'57018                           '}="541****";
$wangdianHashtable{'57020                           '}="541****";
$wangdianHashtable{'57022                           '}="541****";
$wangdianHashtable{'57026                           '}="541****";
$wangdianHashtable{'57031                           '}="541****";
$wangdianHashtable{'57033                           '}="541****";
$wangdianHashtable{'57034                           '}="541****";
$wangdianHashtable{'57036                           '}="541****";
$wangdianHashtable{'57037                           '}="541****";
$wangdianHashtable{'58001                           '}="541****";
$wangdianHashtable{'58003                           '}="541****";
$wangdianHashtable{'58004                           '}="541****";
$wangdianHashtable{'58005                           '}="541****";
$wangdianHashtable{'58007                           '}="541****";
$wangdianHashtable{'58009                           '}="541****";
$wangdianHashtable{'58010                           '}="541****";
$wangdianHashtable{'58012                           '}="541****";
$wangdianHashtable{'58014                           '}="541****";
$wangdianHashtable{'58020                           '}="541****";
$wangdianHashtable{'58021                           '}="541****";
$wangdianHashtable{'58023                           '}="541****";
$wangdianHashtable{'58026                           '}="541****";
$wangdianHashtable{'59001                           '}="541****";
$wangdianHashtable{'59003                           '}="541****";
$wangdianHashtable{'59004                           '}="541****";
$wangdianHashtable{'59007                           '}="541****";
$wangdianHashtable{'59009                           '}="541****";
$wangdianHashtable{'59013                           '}="541****";
$wangdianHashtable{'59015                           '}="541****";
$wangdianHashtable{'59017                           '}="541****";
$wangdianHashtable{'59019                           '}="541****";
$wangdianHashtable{'59020                           '}="541****";
$wangdianHashtable{'60001                           '}="541****";
$wangdianHashtable{'60003                           '}="541****";
$wangdianHashtable{'60004                           '}="541****";
$wangdianHashtable{'60005                           '}="541****";
$wangdianHashtable{'60007                           '}="541****";
$wangdianHashtable{'60009                           '}="541****";
$wangdianHashtable{'60012                           '}="541****";
$wangdianHashtable{'60013                           '}="541****";
$wangdianHashtable{'60015                           '}="541****";
$wangdianHashtable{'60017                           '}="541****";
$wangdianHashtable{'60021                           '}="541****";
$wangdianHashtable{'60023                           '}="541****";
$wangdianHashtable{'60024                           '}="541****";
$wangdianHashtable{'61001                           '}="541****";
$wangdianHashtable{'61003                           '}="541****";
$wangdianHashtable{'61004                           '}="541****";
$wangdianHashtable{'61006                           '}="541****";
$wangdianHashtable{'61008                           '}="541****";
$wangdianHashtable{'61009                           '}="541****";
$wangdianHashtable{'61010                           '}="541****";
$wangdianHashtable{'61011                           '}="541****";
$wangdianHashtable{'61012                           '}="541****";
$wangdianHashtable{'61013                           '}="541****";
$wangdianHashtable{'61015                           '}="541****";
$wangdianHashtable{'61019                           '}="541****";
$wangdianHashtable{'61021                           '}="541****";
$wangdianHashtable{'61023                           '}="541****";
$wangdianHashtable{'61025                           '}="541****";
$wangdianHashtable{'61027                           '}="541****";
$wangdianHashtable{'62001                           '}="541****";
$wangdianHashtable{'62003                           '}="541****";
$wangdianHashtable{'62004                           '}="541****";
$wangdianHashtable{'62005                           '}="541****";
$wangdianHashtable{'62006                           '}="541****";
$wangdianHashtable{'62008                           '}="541****";
$wangdianHashtable{'62009                           '}="541****";
$wangdianHashtable{'62011                           '}="541****";
$wangdianHashtable{'62013                           '}="541****";
$wangdianHashtable{'62017                           '}="541****";
$wangdianHashtable{'62019                           '}="541****";
$wangdianHashtable{'62020                           '}="541****";
$wangdianHashtable{'62022                           '}="541****";
$wangdianHashtable{'62024                           '}="541****";
$wangdianHashtable{'62026                           '}="541****";
$wangdianHashtable{'62028                           '}="541****";
$wangdianHashtable{'63001                           '}="541****";
$wangdianHashtable{'63003                           '}="541****";
$wangdianHashtable{'63005                           '}="541****";
$wangdianHashtable{'63006                           '}="541****";
$wangdianHashtable{'63007                           '}="541****";
$wangdianHashtable{'63008                           '}="541****";
$wangdianHashtable{'64001                           '}="541****";
$wangdianHashtable{'64003                           '}="541****";
$wangdianHashtable{'64004                           '}="541****";
$wangdianHashtable{'64005                           '}="541****";
$wangdianHashtable{'64007                           '}="541****";
$wangdianHashtable{'64008                           '}="541****";
$wangdianHashtable{'64009                           '}="541****";
$wangdianHashtable{'64010                           '}="541****";
$wangdianHashtable{'64011                           '}="541****";
$wangdianHashtable{'64012                           '}="541****";
$wangdianHashtable{'64014                           '}="541****";
$wangdianHashtable{'64015                           '}="541****";
$wangdianHashtable{'64016                           '}="541****";
$wangdianHashtable{'64019                           '}="541****";
$wangdianHashtable{'64021                           '}="541****";
$wangdianHashtable{'64022                           '}="541****";
$wangdianHashtable{'64023                           '}="541****";
$wangdianHashtable{'64024                           '}="541****";
$wangdianHashtable{'64026                           '}="541****";
$wangdianHashtable{'64027                           '}="541****";
$wangdianHashtable{'64028                           '}="541****";
$wangdianHashtable{'64029                           '}="541****";
$wangdianHashtable{'64030                           '}="541****";
$wangdianHashtable{'65001                           '}="541****";
$wangdianHashtable{'65003                           '}="541****";
$wangdianHashtable{'65004                           '}="541****";
$wangdianHashtable{'65005                           '}="541****";
$wangdianHashtable{'65006                           '}="541****";
$wangdianHashtable{'65007                           '}="541****";
$wangdianHashtable{'65008                           '}="541****";
$wangdianHashtable{'65011                           '}="541****";
$wangdianHashtable{'65013                           '}="541****";
$wangdianHashtable{'65014                           '}="541****";
$wangdianHashtable{'65016                           '}="541****";
$wangdianHashtable{'65018                           '}="541****";
$wangdianHashtable{'65019                           '}="541****";
$wangdianHashtable{'65021                           '}="541****";
$wangdianHashtable{'65024                           '}="541****";
$wangdianHashtable{'65025                           '}="541****";
$wangdianHashtable{'65027                           '}="541****";
$wangdianHashtable{'65029                           '}="541****";
$wangdianHashtable{'65031                           '}="541****";
$wangdianHashtable{'65033                           '}="541****";
$wangdianHashtable{'65035                           '}="541****";
$wangdianHashtable{'65037                           '}="541****";
$wangdianHashtable{'65042                           '}="541****";
$wangdianHashtable{'65043                           '}="541****";
$wangdianHashtable{'66001                           '}="541****";
$wangdianHashtable{'66003                           '}="541****";
$wangdianHashtable{'66004                           '}="541****";
$wangdianHashtable{'66005                           '}="541****";
$wangdianHashtable{'66007                           '}="541****";
$wangdianHashtable{'66009                           '}="541****";
$wangdianHashtable{'66011                           '}="541****";
$wangdianHashtable{'66013                           '}="541****";
$wangdianHashtable{'66015                           '}="541****";
$wangdianHashtable{'66017                           '}="541****";
$wangdianHashtable{'66019                           '}="541****";
$wangdianHashtable{'66021                           '}="541****";
$wangdianHashtable{'66023                           '}="541****";
$wangdianHashtable{'66025                           '}="541****";
$wangdianHashtable{'66027                           '}="541****";
$wangdianHashtable{'66028                           '}="541****";
$wangdianHashtable{'66029                           '}="541****";
$wangdianHashtable{'66031                           '}="541****";
$wangdianHashtable{'66032                           '}="541****";
$wangdianHashtable{'66033                           '}="541****";
$wangdianHashtable{'66034                           '}="541****";
$wangdianHashtable{'66035                           '}="541****";
$wangdianHashtable{'66037                           '}="541****";
$wangdianHashtable{'66038                           '}="541****";
$wangdianHashtable{'66039                           '}="541****";
$wangdianHashtable{'66049                           '}="541****";
$wangdianHashtable{'66051                           '}="541****";
$wangdianHashtable{'67001                           '}="541****";
$wangdianHashtable{'67003                           '}="541****";
$wangdianHashtable{'67004                           '}="541****";
$wangdianHashtable{'67005                           '}="541****";
$wangdianHashtable{'67007                           '}="541****";
$wangdianHashtable{'67008                           '}="541****";
$wangdianHashtable{'67010                           '}="541****";
$wangdianHashtable{'67013                           '}="541****";
$wangdianHashtable{'67015                           '}="541****";
$wangdianHashtable{'67017                           '}="541****";
$wangdianHashtable{'67019                           '}="541****";
$wangdianHashtable{'67021                           '}="541****";
$wangdianHashtable{'67023                           '}="541****";
$wangdianHashtable{'67025                           '}="541****";
$wangdianHashtable{'67026                           '}="541****";
$wangdianHashtable{'67027                           '}="541****";
$wangdianHashtable{'67029                           '}="541****";
$wangdianHashtable{'67031                           '}="541****";
$wangdianHashtable{'67033                           '}="541****";
$wangdianHashtable{'67035                           '}="541****";
$wangdianHashtable{'68001                           '}="541****";
$wangdianHashtable{'68003                           '}="541****";
$wangdianHashtable{'68004                           '}="541****";
$wangdianHashtable{'68006                           '}="541****";
$wangdianHashtable{'68007                           '}="541****";
$wangdianHashtable{'68008                           '}="541****";
$wangdianHashtable{'68009                           '}="541****";
$wangdianHashtable{'68011                           '}="541****";
$wangdianHashtable{'68013                           '}="541****";
$wangdianHashtable{'68015                           '}="541****";
$wangdianHashtable{'68017                           '}="541****";
$wangdianHashtable{'68019                           '}="541****";
$wangdianHashtable{'68021                           '}="541****";
$wangdianHashtable{'68022                           '}="541****";
$wangdianHashtable{'68024                           '}="541****";
$wangdianHashtable{'68025                           '}="541****";
$wangdianHashtable{'68026                           '}="541****";
$wangdianHashtable{'68028                           '}="541****";
$wangdianHashtable{'68029                           '}="541****";
$wangdianHashtable{'68031                           '}="541****";
$wangdianHashtable{'68033                           '}="541****";
$wangdianHashtable{'68035                           '}="541****";
$wangdianHashtable{'68037                           '}="541****";
$wangdianHashtable{'68039                           '}="541****";
$wangdianHashtable{'68041                           '}="541****";
$wangdianHashtable{'68043                           '}="541****";
$wangdianHashtable{'68044                           '}="541****";
$wangdianHashtable{'68046                           '}="541****";
$wangdianHashtable{'68048                           '}="541****";
$wangdianHashtable{'68050                           '}="541****";
$wangdianHashtable{'69001                           '}="541****";
$wangdianHashtable{'69003                           '}="541****";
$wangdianHashtable{'69005                           '}="541****";
$wangdianHashtable{'69006                           '}="541****";
$wangdianHashtable{'69007                           '}="541****";
$wangdianHashtable{'69008                           '}="541****";
$wangdianHashtable{'69009                           '}="541****";
$wangdianHashtable{'69010                           '}="541****";
$wangdianHashtable{'69011                           '}="541****";
$wangdianHashtable{'69012                           '}="541****";
$wangdianHashtable{'69013                           '}="541****";
$wangdianHashtable{'69015                           '}="541****";
$wangdianHashtable{'69016                           '}="541****";
$wangdianHashtable{'69018                           '}="541****";
$wangdianHashtable{'69020                           '}="541****";
$wangdianHashtable{'69021                           '}="541****";
$wangdianHashtable{'69022                           '}="541****";
$wangdianHashtable{'69024                           '}="541****";
$wangdianHashtable{'69026                           '}="541****";
$wangdianHashtable{'70001                           '}="541****";
$wangdianHashtable{'70003                           '}="541****";
$wangdianHashtable{'70004                           '}="541****";
$wangdianHashtable{'70006                           '}="541****";
$wangdianHashtable{'70014                           '}="541****";
$wangdianHashtable{'70018                           '}="541****";
$wangdianHashtable{'70020                           '}="541****";
$wangdianHashtable{'70024                           '}="541****";
$wangdianHashtable{'70026                           '}="541****";
$wangdianHashtable{'70032                           '}="541****";
$wangdianHashtable{'70036                           '}="541****";
$wangdianHashtable{'70037                           '}="541****";
$wangdianHashtable{'70039                           '}="541****";
$wangdianHashtable{'70040                           '}="541****";
$wangdianHashtable{'70044                           '}="541****";
$wangdianHashtable{'70046                           '}="541****";
$wangdianHashtable{'71001                           '}="541****";
$wangdianHashtable{'71003                           '}="541****";
$wangdianHashtable{'71004                           '}="541****";
$wangdianHashtable{'71005                           '}="541****";
$wangdianHashtable{'71006                           '}="541****";
$wangdianHashtable{'71008                           '}="541****";
$wangdianHashtable{'71009                           '}="541****";
$wangdianHashtable{'71010                           '}="541****";
$wangdianHashtable{'71011                           '}="541****";
$wangdianHashtable{'71012                           '}="541****";
$wangdianHashtable{'71014                           '}="541****";
$wangdianHashtable{'71015                           '}="541****";
$wangdianHashtable{'71016                           '}="541****";
$wangdianHashtable{'71018                           '}="541****";
$wangdianHashtable{'71020                           '}="541****";
$wangdianHashtable{'71022                           '}="541****";
$wangdianHashtable{'71028                           '}="541****";
$wangdianHashtable{'71034                           '}="541****";
$wangdianHashtable{'71036                           '}="541****";
$wangdianHashtable{'71038                           '}="541****";
$wangdianHashtable{'71039                           '}="541****";
$wangdianHashtable{'71041                           '}="541****";
$wangdianHashtable{'71043                           '}="541****";
$wangdianHashtable{'71045                           '}="541****";
$wangdianHashtable{'71047                           '}="541****";
$wangdianHashtable{'71049                           '}="541****";
$wangdianHashtable{'71051                           '}="541****";
$wangdianHashtable{'72001                           '}="541****";
$wangdianHashtable{'72003                           '}="541****";
$wangdianHashtable{'72004                           '}="541****";
$wangdianHashtable{'72005                           '}="541****";
$wangdianHashtable{'72007                           '}="541****";
$wangdianHashtable{'72009                           '}="541****";
$wangdianHashtable{'72010                           '}="541****";
$wangdianHashtable{'72012                           '}="541****";
$wangdianHashtable{'72014                           '}="541****";
$wangdianHashtable{'72015                           '}="541****";
$wangdianHashtable{'72016                           '}="541****";
$wangdianHashtable{'72017                           '}="541****";
$wangdianHashtable{'72019                           '}="541****";
$wangdianHashtable{'72020                           '}="541****";
$wangdianHashtable{'72021                           '}="541****";
$wangdianHashtable{'72023                           '}="541****";
$wangdianHashtable{'72025                           '}="541****";
$wangdianHashtable{'72027                           '}="541****";
$wangdianHashtable{'72029                           '}="541****";
$wangdianHashtable{'72031                           '}="541****";
$wangdianHashtable{'72033                           '}="541****";
$wangdianHashtable{'72035                           '}="541****";
$wangdianHashtable{'72037                           '}="541****";
$wangdianHashtable{'72043                           '}="541****";
$wangdianHashtable{'73001                           '}="541****";
$wangdianHashtable{'73003                           '}="541****";
$wangdianHashtable{'73004                           '}="541****";
$wangdianHashtable{'73006                           '}="541****";
$wangdianHashtable{'73007                           '}="541****";
$wangdianHashtable{'73009                           '}="541****";
$wangdianHashtable{'73011                           '}="541****";
$wangdianHashtable{'73015                           '}="541****";
$wangdianHashtable{'73019                           '}="541****";
$wangdianHashtable{'73021                           '}="541****";
$wangdianHashtable{'73025                           '}="541****";
$wangdianHashtable{'73027                           '}="541****";
$wangdianHashtable{'74001                           '}="541****";
$wangdianHashtable{'74003                           '}="541****";
$wangdianHashtable{'74004                           '}="541****";
$wangdianHashtable{'74005                           '}="541****";
$wangdianHashtable{'74006                           '}="541****";
$wangdianHashtable{'74007                           '}="541****";
$wangdianHashtable{'74008                           '}="541****";
$wangdianHashtable{'74009                           '}="541****";
$wangdianHashtable{'74010                           '}="541****";
$wangdianHashtable{'74011                           '}="541****";
$wangdianHashtable{'74013                           '}="541****";
$wangdianHashtable{'74014                           '}="541****";
$wangdianHashtable{'74015                           '}="541****";
$wangdianHashtable{'74016                           '}="541****";
$wangdianHashtable{'74018                           '}="541****";
$wangdianHashtable{'74019                           '}="541****";
$wangdianHashtable{'74021                           '}="541****";
$wangdianHashtable{'74022                           '}="541****";
$wangdianHashtable{'74023                           '}="541****";
$wangdianHashtable{'74025                           '}="541****";
$wangdianHashtable{'74027                           '}="541****";
$wangdianHashtable{'74029                           '}="541****";
$wangdianHashtable{'74035                           '}="541****";
$wangdianHashtable{'74037                           '}="541****";
$wangdianHashtable{'74039                           '}="541****";
$wangdianHashtable{'74043                           '}="541****";
$wangdianHashtable{'74045                           '}="541****";
$wangdianHashtable{'74047                           '}="541****";
$wangdianHashtable{'74051                           '}="541****";
$wangdianHashtable{'75001                           '}="541****";
$wangdianHashtable{'75003                           '}="541****";
$wangdianHashtable{'75004                           '}="541****";
$wangdianHashtable{'75005                           '}="541****";
$wangdianHashtable{'75006                           '}="541****";
$wangdianHashtable{'75007                           '}="541****";
$wangdianHashtable{'75008                           '}="541****";
$wangdianHashtable{'75009                           '}="541****";
$wangdianHashtable{'75010                           '}="541****";
$wangdianHashtable{'75012                           '}="541****";
$wangdianHashtable{'75014                           '}="541****";
$wangdianHashtable{'75015                           '}="541****";
$wangdianHashtable{'75016                           '}="541****";
$wangdianHashtable{'75018                           '}="541****";
$wangdianHashtable{'75019                           '}="541****";
$wangdianHashtable{'75020                           '}="541****";
$wangdianHashtable{'75022                           '}="541****";
$wangdianHashtable{'75023                           '}="541****";
$wangdianHashtable{'75024                           '}="541****";
$wangdianHashtable{'75025                           '}="541****";
$wangdianHashtable{'75026                           '}="541****";
$wangdianHashtable{'75027                           '}="541****";
$wangdianHashtable{'75029                           '}="541****";
$wangdianHashtable{'75031                           '}="541****";
$wangdianHashtable{'75033                           '}="541****";
$wangdianHashtable{'75034                           '}="541****";
$wangdianHashtable{'75035                           '}="541****";
$wangdianHashtable{'75036                           '}="541****";
$wangdianHashtable{'75037                           '}="541****";
$wangdianHashtable{'75038                           '}="541****";
$wangdianHashtable{'75039                           '}="541****";
$wangdianHashtable{'75040                           '}="541****";
$wangdianHashtable{'75041                           '}="541****";
$wangdianHashtable{'75042                           '}="541****";
$wangdianHashtable{'75043                           '}="541****";
$wangdianHashtable{'75044                           '}="541****";
$wangdianHashtable{'75046                           '}="541****";
$wangdianHashtable{'75048                           '}="541****";
$wangdianHashtable{'75050                           '}="541****";
$wangdianHashtable{'75052                           '}="541****";
$wangdianHashtable{'75054                           '}="541****";
$wangdianHashtable{'75056                           '}="541****";
$wangdianHashtable{'75058                           '}="541****";
$wangdianHashtable{'75061                           '}="541****";
$wangdianHashtable{'75062                           '}="541****";
$wangdianHashtable{'75063                           '}="541****";
$wangdianHashtable{'75064                           '}="541****";
$wangdianHashtable{'75065                           '}="541****";
$wangdianHashtable{'75066                           '}="541****";
$wangdianHashtable{'75067                           '}="541****";
$wangdianHashtable{'75068                           '}="541****";
$wangdianHashtable{'75069                           '}="541****";
$wangdianHashtable{'75070                           '}="541****";
$wangdianHashtable{'75071                           '}="541****";
$wangdianHashtable{'75072                           '}="541****";
$wangdianHashtable{'76001                           '}="541****";
$wangdianHashtable{'76003                           '}="541****";
$wangdianHashtable{'76005                           '}="541****";
$wangdianHashtable{'76007                           '}="541****";
$wangdianHashtable{'76009                           '}="541****";
$wangdianHashtable{'76011                           '}="541****";
$wangdianHashtable{'76013                           '}="541****";
$wangdianHashtable{'76015                           '}="541****";
$wangdianHashtable{'76019                           '}="541****";
$wangdianHashtable{'76021                           '}="541****";
$wangdianHashtable{'76023                           '}="541****";
$wangdianHashtable{'76025                           '}="541****";
$wangdianHashtable{'76029                           '}="541****";
$wangdianHashtable{'76031                           '}="541****";
$wangdianHashtable{'76033                           '}="541****";
$wangdianHashtable{'76037                           '}="541****";
$wangdianHashtable{'76039                           '}="541****";
$wangdianHashtable{'76041                           '}="541****";
$wangdianHashtable{'76044                           '}="541****";
$wangdianHashtable{'76045                           '}="541****";
$wangdianHashtable{'76046                           '}="541****";
$wangdianHashtable{'76047                           '}="541****";
$wangdianHashtable{'76048                           '}="541****";
$wangdianHashtable{'76049                           '}="541****";
$wangdianHashtable{'76052                           '}="541****";
$wangdianHashtable{'76053                           '}="541****";
$wangdianHashtable{'76055                           '}="541****";
$wangdianHashtable{'76056                           '}="541****";
$wangdianHashtable{'76057                           '}="541****";
$wangdianHashtable{'76059                           '}="541****";
$wangdianHashtable{'77001                           '}="541****";
$wangdianHashtable{'77003                           '}="541****";
$wangdianHashtable{'77004                           '}="541****";
$wangdianHashtable{'77007                           '}="541****";
$wangdianHashtable{'77009                           '}="541****";
$wangdianHashtable{'77011                           '}="541****";
$wangdianHashtable{'77012                           '}="541****";
$wangdianHashtable{'77014                           '}="541****";
$wangdianHashtable{'77021                           '}="541****";
$wangdianHashtable{'77023                           '}="541****";
$wangdianHashtable{'77025                           '}="541****";
$wangdianHashtable{'77029                           '}="541****";
$wangdianHashtable{'77031                           '}="541****";
$wangdianHashtable{'77033                           '}="541****";
$wangdianHashtable{'77040                           '}="541****";
$wangdianHashtable{'77042                           '}="541****";
$wangdianHashtable{'77047                           '}="541****";
$wangdianHashtable{'77049                           '}="541****";
$wangdianHashtable{'77051                           '}="541****";
$wangdianHashtable{'77053                           '}="541****";
$wangdianHashtable{'77057                           '}="541****";
$wangdianHashtable{'77058                           '}="541****";
$wangdianHashtable{'77059                           '}="541****";
$wangdianHashtable{'77060                           '}="541****";
$wangdianHashtable{'77062                           '}="541****";
$wangdianHashtable{'77063                           '}="541****";
$wangdianHashtable{'77065                           '}="541****";
$wangdianHashtable{'77066                           '}="541****";
$wangdianHashtable{'77067                           '}="541****";
$wangdianHashtable{'77068                           '}="541****";
$wangdianHashtable{'77070                           '}="541****";
$wangdianHashtable{'77071                           '}="541****";
$wangdianHashtable{'77073                           '}="541****";
$wangdianHashtable{'77074                           '}="541****";
$wangdianHashtable{'77075                           '}="541****";
$wangdianHashtable{'77076                           '}="541****";
$wangdianHashtable{'77077                           '}="541****";
$wangdianHashtable{'77080                           '}="541****";
$wangdianHashtable{'77081                           '}="541****";
$wangdianHashtable{'77082                           '}="541****";
$wangdianHashtable{'77083                           '}="541****";
$wangdianHashtable{'77085                           '}="541****";
$wangdianHashtable{'77087                           '}="541****";
$wangdianHashtable{'78001                           '}="541****";
$wangdianHashtable{'78003                           '}="541****";
$wangdianHashtable{'78004                           '}="541****";
$wangdianHashtable{'78005                           '}="541****";
$wangdianHashtable{'78006                           '}="541****";
$wangdianHashtable{'78007                           '}="541****";
$wangdianHashtable{'78009                           '}="541****";
$wangdianHashtable{'78011                           '}="541****";
$wangdianHashtable{'78013                           '}="541****";
$wangdianHashtable{'78014                           '}="541****";
$wangdianHashtable{'78016                           '}="541****";
$wangdianHashtable{'78018                           '}="541****";
$wangdianHashtable{'78020                           '}="541****";
$wangdianHashtable{'78022                           '}="541****";
$wangdianHashtable{'78024                           '}="541****";
$wangdianHashtable{'78026                           '}="541****";
$wangdianHashtable{'78028                           '}="541****";
$wangdianHashtable{'78029                           '}="541****";
$wangdianHashtable{'78030                           '}="541****";
$wangdianHashtable{'78031                           '}="541****";
$wangdianHashtable{'78033                           '}="541****";
$wangdianHashtable{'78035                           '}="541****";
$wangdianHashtable{'78037                           '}="541****";
$wangdianHashtable{'78038                           '}="541****";
$wangdianHashtable{'78039                           '}="541****";
$wangdianHashtable{'78040                           '}="541****";
$wangdianHashtable{'78041                           '}="541****";
$wangdianHashtable{'78042                           '}="541****";
$wangdianHashtable{'78043                           '}="541****";
$wangdianHashtable{'78044                           '}="541****";
$wangdianHashtable{'78045                           '}="541****";
$wangdianHashtable{'78046                           '}="541****";
$wangdianHashtable{'78047                           '}="541****";
$wangdianHashtable{'78999                           '}="541****";
$wangdianHashtable{'79001                           '}="541****";
$wangdianHashtable{'79003                           '}="541****";
$wangdianHashtable{'79004                           '}="541****";
$wangdianHashtable{'79005                           '}="541****";
$wangdianHashtable{'79006                           '}="541****";
$wangdianHashtable{'79007                           '}="541****";
$wangdianHashtable{'79008                           '}="541****";
$wangdianHashtable{'79009                           '}="541****";
$wangdianHashtable{'79011                           '}="541****";
$wangdianHashtable{'79013                           '}="541****";
$wangdianHashtable{'79014                           '}="541****";
$wangdianHashtable{'79019                           '}="541****";
$wangdianHashtable{'79024                           '}="541****";
$wangdianHashtable{'79026                           '}="541****";
$wangdianHashtable{'79031                           '}="541****";
$wangdianHashtable{'79033                           '}="541****";
$wangdianHashtable{'79035                           '}="541****";
$wangdianHashtable{'79036                           '}="541****";
$wangdianHashtable{'79038                           '}="541****";
$wangdianHashtable{'79039                           '}="541****";
$wangdianHashtable{'79041                           '}="541****";
$wangdianHashtable{'79042                           '}="541****";
$wangdianHashtable{'79043                           '}="541****";
$wangdianHashtable{'79044                           '}="541****";
$wangdianHashtable{'79045                           '}="541****";
$wangdianHashtable{'79046                           '}="541****";
$wangdianHashtable{'79047                           '}="541****";
$wangdianHashtable{'79048                           '}="541****";
$wangdianHashtable{'80001                           '}="541****";
$wangdianHashtable{'80003                           '}="541****";
$wangdianHashtable{'80005                           '}="541****";
$wangdianHashtable{'80007                           '}="541****";
$wangdianHashtable{'80009                           '}="541****";
$wangdianHashtable{'80011                           '}="541****";
$wangdianHashtable{'80013                           '}="541****";
$wangdianHashtable{'80015                           '}="541****";
$wangdianHashtable{'80017                           '}="541****";
$wangdianHashtable{'80019                           '}="541****";
$wangdianHashtable{'80020                           '}="541****";
$wangdianHashtable{'80022                           '}="541****";
$wangdianHashtable{'80024                           '}="541****";
$wangdianHashtable{'80026                           '}="541****";
$wangdianHashtable{'80028                           '}="541****";
$wangdianHashtable{'80030                           '}="541****";
$wangdianHashtable{'80032                           '}="541****";
$wangdianHashtable{'81001                           '}="541****";
$wangdianHashtable{'81003                           '}="541****";
$wangdianHashtable{'81005                           '}="541****";
$wangdianHashtable{'81009                           '}="541****";
$wangdianHashtable{'81013                           '}="541****";
$wangdianHashtable{'81015                           '}="541****";
$wangdianHashtable{'81017                           '}="541****";
$wangdianHashtable{'81023                           '}="541****";
$wangdianHashtable{'81025                           '}="541****";
$wangdianHashtable{'81027                           '}="541****";
$wangdianHashtable{'81029                           '}="541****";
$wangdianHashtable{'81031                           '}="541****";
$wangdianHashtable{'81033                           '}="541****";
$wangdianHashtable{'81035                           '}="541****";
$wangdianHashtable{'81037                           '}="541****";
$wangdianHashtable{'81038                           '}="541****";
$wangdianHashtable{'81039                           '}="541****";
$wangdianHashtable{'81040                           '}="541****";
$wangdianHashtable{'81041                           '}="541****";
$wangdianHashtable{'81042                           '}="541****";
$wangdianHashtable{'81043                           '}="541****";
$wangdianHashtable{'81044                           '}="541****";
$wangdianHashtable{'81045                           '}="541****";
$wangdianHashtable{'82001                           '}="541****";
$wangdianHashtable{'82003                           '}="541****";
$wangdianHashtable{'82004                           '}="541****";
$wangdianHashtable{'82006                           '}="541****";
$wangdianHashtable{'82007                           '}="541****";
$wangdianHashtable{'82009                           '}="541****";
$wangdianHashtable{'82011                           '}="541****";
$wangdianHashtable{'82014                           '}="541****";
$wangdianHashtable{'82015                           '}="541****";
$wangdianHashtable{'82018                           '}="541****";
$wangdianHashtable{'82021                           '}="541****";
$wangdianHashtable{'82022                           '}="541****";
$wangdianHashtable{'82024                           '}="541****";
$wangdianHashtable{'82026                           '}="541****";
$wangdianHashtable{'82029                           '}="541****";
$wangdianHashtable{'82034                           '}="541****";
$wangdianHashtable{'82038                           '}="541****";
$wangdianHashtable{'82041                           '}="541****";
$wangdianHashtable{'82045                           '}="541****";
$wangdianHashtable{'82047                           '}="541****";
$wangdianHashtable{'83001                           '}="541****";
$wangdianHashtable{'83003                           '}="541****";
$wangdianHashtable{'83004                           '}="541****";
$wangdianHashtable{'83005                           '}="541****";
$wangdianHashtable{'83006                           '}="541****";
$wangdianHashtable{'83008                           '}="541****";
$wangdianHashtable{'83009                           '}="541****";
$wangdianHashtable{'83011                           '}="541****";
$wangdianHashtable{'83012                           '}="541****";
$wangdianHashtable{'83013                           '}="541****";
$wangdianHashtable{'83014                           '}="541****";
$wangdianHashtable{'83015                           '}="541****";
$wangdianHashtable{'83016                           '}="541****";
$wangdianHashtable{'83017                           '}="541****";
$wangdianHashtable{'83018                           '}="541****";
$wangdianHashtable{'84001                           '}="541****";
$wangdianHashtable{'84003                           '}="541****";
$wangdianHashtable{'84004                           '}="541****";
$wangdianHashtable{'84005                           '}="541****";
$wangdianHashtable{'84006                           '}="541****";
$wangdianHashtable{'84008                           '}="541****";
$wangdianHashtable{'84009                           '}="541****";
$wangdianHashtable{'84010                           '}="541****";
$wangdianHashtable{'84011                           '}="541****";
$wangdianHashtable{'84014                           '}="541****";
$wangdianHashtable{'84015                           '}="541****";
$wangdianHashtable{'84016                           '}="541****";
$wangdianHashtable{'84017                           '}="541****";
$wangdianHashtable{'84019                           '}="541****";
$wangdianHashtable{'84020                           '}="541****";
$wangdianHashtable{'84021                           '}="541****";
$wangdianHashtable{'84022                           '}="541****";
$wangdianHashtable{'84024                           '}="541****";
$wangdianHashtable{'84025                           '}="541****";
$wangdianHashtable{'84026                           '}="541****";
$wangdianHashtable{'84027                           '}="541****";
$wangdianHashtable{'84029                           '}="541****";
$wangdianHashtable{'84030                           '}="541****";
$wangdianHashtable{'85001                           '}="541****";
$wangdianHashtable{'85003                           '}="541****";
$wangdianHashtable{'85004                           '}="541****";
$wangdianHashtable{'85007                           '}="541****";
$wangdianHashtable{'85008                           '}="541****";
$wangdianHashtable{'85010                           '}="541****";
$wangdianHashtable{'85013                           '}="541****";
$wangdianHashtable{'85016                           '}="541****";
$wangdianHashtable{'85018                           '}="541****";
$wangdianHashtable{'85019                           '}="541****";
$wangdianHashtable{'85020                           '}="541****";
$wangdianHashtable{'85021                           '}="541****";
$wangdianHashtable{'85026                           '}="541****";
$wangdianHashtable{'85027                           '}="541****";
$wangdianHashtable{'85031                           '}="541****";
$wangdianHashtable{'85033                           '}="541****";
$wangdianHashtable{'85037                           '}="541****";
$wangdianHashtable{'85039                           '}="541****";
$wangdianHashtable{'85041                           '}="541****";
$wangdianHashtable{'85043                           '}="541****";
$wangdianHashtable{'85045                           '}="541****";
$wangdianHashtable{'85046                           '}="541****";
$wangdianHashtable{'85048                           '}="541****";
$wangdianHashtable{'85054                           '}="541****";
$wangdianHashtable{'85056                           '}="541****";
$wangdianHashtable{'85057                           '}="541****";
$wangdianHashtable{'85061                           '}="541****";
$wangdianHashtable{'85063                           '}="541****";
$wangdianHashtable{'85064                           '}="541****";
$wangdianHashtable{'85065                           '}="541****";
$wangdianHashtable{'85070                           '}="541****";
$wangdianHashtable{'85072                           '}="541****";
$wangdianHashtable{'85074                           '}="541****";
$wangdianHashtable{'85075                           '}="541****";
$wangdianHashtable{'85079                           '}="541****";
$wangdianHashtable{'85082                           '}="541****";
$wangdianHashtable{'85084                           '}="541****";
$wangdianHashtable{'85086                           '}="541****";
$wangdianHashtable{'85088                           '}="541****";
$wangdianHashtable{'85090                           '}="541****";
$wangdianHashtable{'85092                           '}="541****";
$wangdianHashtable{'85094                           '}="541****";
$wangdianHashtable{'85096                           '}="541****";
$wangdianHashtable{'85098                           '}="541****";
$wangdianHashtable{'85100                           '}="541****";
$wangdianHashtable{'85102                           '}="541****";
$wangdianHashtable{'85104                           '}="541****";
$wangdianHashtable{'85106                           '}="541****";
$wangdianHashtable{'85108                           '}="541****";
$wangdianHashtable{'85110                           '}="541****";
$wangdianHashtable{'85111                           '}="541****";
$wangdianHashtable{'85112                           '}="541****";
$wangdianHashtable{'85113                           '}="541****";
$wangdianHashtable{'85115                           '}="541****";
$wangdianHashtable{'85118                           '}="541****";
$wangdianHashtable{'85122                           '}="541****";
$wangdianHashtable{'85123                           '}="541****";
$wangdianHashtable{'85124                           '}="541****";
$wangdianHashtable{'85125                           '}="541****";
$wangdianHashtable{'85999                           '}="541****";
$wangdianHashtable{'86001                           '}="541****";
$wangdianHashtable{'86003                           '}="541****";
$wangdianHashtable{'86004                           '}="541****";
$wangdianHashtable{'86006                           '}="541****";
$wangdianHashtable{'86007                           '}="541****";
$wangdianHashtable{'86009                           '}="541****";
$wangdianHashtable{'86010                           '}="541****";
$wangdianHashtable{'86012                           '}="541****";
$wangdianHashtable{'86015                           '}="541****";
$wangdianHashtable{'86017                           '}="541****";
$wangdianHashtable{'86018                           '}="541****";
$wangdianHashtable{'86020                           '}="541****";
$wangdianHashtable{'86022                           '}="541****";
$wangdianHashtable{'86024                           '}="541****";
$wangdianHashtable{'86025                           '}="541****";
$wangdianHashtable{'86033                           '}="541****";
$wangdianHashtable{'86034                           '}="541****";
$wangdianHashtable{'86035                           '}="541****";
$wangdianHashtable{'86036                           '}="541****";
$wangdianHashtable{'87001                           '}="541****";
$wangdianHashtable{'87003                           '}="541****";
$wangdianHashtable{'87005                           '}="541****";
$wangdianHashtable{'87007                           '}="541****";
$wangdianHashtable{'87009                           '}="541****";
$wangdianHashtable{'87011                           '}="541****";
$wangdianHashtable{'87013                           '}="541****";
$wangdianHashtable{'87015                           '}="541****";
$wangdianHashtable{'87017                           '}="541****";
$wangdianHashtable{'87019                           '}="541****";
$wangdianHashtable{'87021                           '}="541****";
$wangdianHashtable{'87023                           '}="541****";
$wangdianHashtable{'87025                           '}="541****";
$wangdianHashtable{'87027                           '}="541****";
$wangdianHashtable{'87029                           '}="541****";
$wangdianHashtable{'87031                           '}="541****";
$wangdianHashtable{'87033                           '}="541****";
$wangdianHashtable{'87035                           '}="541****";
$wangdianHashtable{'87037                           '}="541****";
$wangdianHashtable{'87039                           '}="541****";
$wangdianHashtable{'87041                           '}="541****";
$wangdianHashtable{'87044                           '}="541****";
$wangdianHashtable{'87046                           '}="541****";
$wangdianHashtable{'87047                           '}="541****";
$wangdianHashtable{'87049                           '}="541****";
$wangdianHashtable{'87050                           '}="541****";
$wangdianHashtable{'87051                           '}="541****";
$wangdianHashtable{'87053                           '}="541****";
$wangdianHashtable{'87055                           '}="541****";
$wangdianHashtable{'87058                           '}="541****";
$wangdianHashtable{'87059                           '}="541****";
$wangdianHashtable{'87061                           '}="541****";
$wangdianHashtable{'87063                           '}="541****";
$wangdianHashtable{'87065                           '}="541****";
$wangdianHashtable{'87066                           '}="541****";
$wangdianHashtable{'88001                           '}="541****";
$wangdianHashtable{'88003                           '}="541****";
$wangdianHashtable{'88004                           '}="541****";
$wangdianHashtable{'88005                           '}="541****";
$wangdianHashtable{'88007                           '}="541****";
$wangdianHashtable{'88008                           '}="541****";
$wangdianHashtable{'88010                           '}="541****";
$wangdianHashtable{'88012                           '}="541****";
$wangdianHashtable{'88013                           '}="541****";
$wangdianHashtable{'88014                           '}="541****";
$wangdianHashtable{'88016                           '}="541****";
$wangdianHashtable{'88018                           '}="541****";
$wangdianHashtable{'88020                           '}="541****";
$wangdianHashtable{'88022                           '}="541****";
$wangdianHashtable{'88024                           '}="541****";
$wangdianHashtable{'88026                           '}="541****";
$wangdianHashtable{'88028                           '}="541****";
$wangdianHashtable{'88030                           '}="541****";
$wangdianHashtable{'88032                           '}="541****";
$wangdianHashtable{'88034                           '}="541****";
$wangdianHashtable{'88036                           '}="541****";
$wangdianHashtable{'88038                           '}="541****";
$wangdianHashtable{'88040                           '}="541****";
$wangdianHashtable{'88042                           '}="541****";
$wangdianHashtable{'88044                           '}="541****";
$wangdianHashtable{'88045                           '}="541****";
$wangdianHashtable{'88047                           '}="541****";
$wangdianHashtable{'88049                           '}="541****";
$wangdianHashtable{'89001                           '}="541****";
$wangdianHashtable{'89003                           '}="541****";
$wangdianHashtable{'89004                           '}="541****";
$wangdianHashtable{'89005                           '}="541****";
$wangdianHashtable{'89007                           '}="541****";
$wangdianHashtable{'89008                           '}="541****";
$wangdianHashtable{'89010                           '}="541****";
$wangdianHashtable{'89013                           '}="541****";
$wangdianHashtable{'89015                           '}="541****";
$wangdianHashtable{'89017                           '}="541****";
$wangdianHashtable{'89019                           '}="541****";
$wangdianHashtable{'89021                           '}="541****";
$wangdianHashtable{'89023                           '}="541****";
$wangdianHashtable{'89025                           '}="541****";
$wangdianHashtable{'89028                           '}="541****";
$wangdianHashtable{'89030                           '}="541****";
$wangdianHashtable{'89031                           '}="541****";
$wangdianHashtable{'89033                           '}="541****";
$wangdianHashtable{'89035                           '}="541****";
$wangdianHashtable{'89037                           '}="541****";
$wangdianHashtable{'89039                           '}="541****";
$wangdianHashtable{'89043                           '}="541****";
$wangdianHashtable{'89045                           '}="541****";
$wangdianHashtable{'89047                           '}="541****";
$wangdianHashtable{'89049                           '}="541****";
$wangdianHashtable{'89053                           '}="541****";
$wangdianHashtable{'89055                           '}="541****";
$wangdianHashtable{'89056                           '}="541****";
$wangdianHashtable{'89058                           '}="541****";
$wangdianHashtable{'89059                           '}="541****";
$wangdianHashtable{'89060                           '}="541****";
$wangdianHashtable{'89061                           '}="541****";
$wangdianHashtable{'89062                           '}="541****";
$wangdianHashtable{'89063                           '}="541****";
$wangdianHashtable{'90001                           '}="541****";
$wangdianHashtable{'90003                           '}="541****";
$wangdianHashtable{'90004                           '}="541****";
$wangdianHashtable{'90005                           '}="541****";
$wangdianHashtable{'90006                           '}="541****";
$wangdianHashtable{'90008                           '}="541****";
$wangdianHashtable{'90010                           '}="541****";
$wangdianHashtable{'90012                           '}="541****";
$wangdianHashtable{'90014                           '}="541****";
$wangdianHashtable{'90016                           '}="541****";
$wangdianHashtable{'90018                           '}="541****";
$wangdianHashtable{'90020                           '}="541****";
$wangdianHashtable{'90022                           '}="541****";
$wangdianHashtable{'90024                           '}="541****";
$wangdianHashtable{'90026                           '}="541****";
$wangdianHashtable{'90028                           '}="541****";
$wangdianHashtable{'90030                           '}="541****";
$wangdianHashtable{'90034                           '}="541****";
$wangdianHashtable{'90036                           '}="541****";
$wangdianHashtable{'90037                           '}="541****";
$wangdianHashtable{'90038                           '}="541****";
$wangdianHashtable{'91001                           '}="541****";
$wangdianHashtable{'91003                           '}="541****";
$wangdianHashtable{'91005                           '}="541****";
$wangdianHashtable{'91007                           '}="541****";
$wangdianHashtable{'91008                           '}="541****";
$wangdianHashtable{'91009                           '}="541****";
$wangdianHashtable{'91011                           '}="541****";
$wangdianHashtable{'91013                           '}="541****";
$wangdianHashtable{'91015                           '}="541****";
$wangdianHashtable{'91016                           '}="541****";
$wangdianHashtable{'91017                           '}="541****";
$wangdianHashtable{'92001                           '}="541****";
$wangdianHashtable{'92003                           '}="541****";
$wangdianHashtable{'92004                           '}="541****";
$wangdianHashtable{'92005                           '}="541****";
$wangdianHashtable{'92006                           '}="541****";
$wangdianHashtable{'92008                           '}="541****";
$wangdianHashtable{'92009                           '}="541****";
$wangdianHashtable{'92010                           '}="541****";
$wangdianHashtable{'92011                           '}="541****";
$wangdianHashtable{'92012                           '}="541****";
$wangdianHashtable{'92015                           '}="541****";
$wangdianHashtable{'92017                           '}="541****";
$wangdianHashtable{'92023                           '}="541****";
$wangdianHashtable{'92025                           '}="541****";
$wangdianHashtable{'92027                           '}="541****";
$wangdianHashtable{'92030                           '}="541****";
$wangdianHashtable{'92032                           '}="541****";
$wangdianHashtable{'92035                           '}="541****";
$wangdianHashtable{'92038                           '}="541****";
$wangdianHashtable{'92040                           '}="541****";
$wangdianHashtable{'92043                           '}="541****";
$wangdianHashtable{'92045                           '}="541****";
$wangdianHashtable{'92047                           '}="541****";
$wangdianHashtable{'92049                           '}="541****";
$wangdianHashtable{'92050                           '}="541****";
$wangdianHashtable{'93001                           '}="541****";
$wangdianHashtable{'93003                           '}="541****";
$wangdianHashtable{'93007                           '}="541****";
$wangdianHashtable{'93009                           '}="541****";
$wangdianHashtable{'94001                           '}="541****";
$wangdianHashtable{'94003                           '}="541****";
$wangdianHashtable{'94004                           '}="541****";
$wangdianHashtable{'94005                           '}="541****";
$wangdianHashtable{'94006                           '}="541****";
$wangdianHashtable{'94007                           '}="541****";
$wangdianHashtable{'95001                           '}="541****";
$wangdianHashtable{'95003                           '}="541****";
$wangdianHashtable{'95005                           '}="541****";
$wangdianHashtable{'95006                           '}="541****";
$wangdianHashtable{'95007                           '}="541****";
$wangdianHashtable{'95008                           '}="541****";
$wangdianHashtable{'95009                           '}="541****";
$wangdianHashtable{'95011                           '}="541****";
$wangdianHashtable{'95013                           '}="541****";
$wangdianHashtable{'95015                           '}="541****";
$wangdianHashtable{'95021                           '}="541****";
$wangdianHashtable{'95023                           '}="541****";
$wangdianHashtable{'95025                           '}="541****";
$wangdianHashtable{'95027                           '}="541****";
$wangdianHashtable{'95031                           '}="541****";
$wangdianHashtable{'95033                           '}="541****";
$wangdianHashtable{'95035                           '}="541****";
$wangdianHashtable{'95037                           '}="541****";
$wangdianHashtable{'95041                           '}="541****";
$wangdianHashtable{'95043                           '}="541****";
$wangdianHashtable{'95045                           '}="541****";
$wangdianHashtable{'95047                           '}="541****";
$wangdianHashtable{'95049                           '}="541****";
$wangdianHashtable{'95050                           '}="541****";
$wangdianHashtable{'95061                           '}="541****";
$wangdianHashtable{'95063                           '}="541****";
$wangdianHashtable{'95065                           '}="541****";
$wangdianHashtable{'95071                           '}="541****";
$wangdianHashtable{'95073                           '}="541****";
$wangdianHashtable{'95075                           '}="541****";
$wangdianHashtable{'95077                           '}="541****";
$wangdianHashtable{'95079                           '}="541****";
$wangdianHashtable{'95081                           '}="541****";
$wangdianHashtable{'95083                           '}="541****";
$wangdianHashtable{'95084                           '}="541****";
$wangdianHashtable{'95085                           '}="541****";
$wangdianHashtable{'95086                           '}="541****";
$wangdianHashtable{'95087                           '}="541****";
$wangdianHashtable{'95088                           '}="541****";
$wangdianHashtable{'95089                           '}="541****";
$wangdianHashtable{'95091                           '}="541****";
$wangdianHashtable{'95093                           '}="541****";
$wangdianHashtable{'95094                           '}="541****";
$wangdianHashtable{'95101                           '}="541****";
$wangdianHashtable{'95103                           '}="541****";
$wangdianHashtable{'95111                           '}="541****";
$wangdianHashtable{'95113                           '}="541****";
$wangdianHashtable{'95115                           '}="541****";
$wangdianHashtable{'95117                           '}="541****";
$wangdianHashtable{'95121                           '}="541****";
$wangdianHashtable{'95123                           '}="541****";
$wangdianHashtable{'95131                           '}="541****";
$wangdianHashtable{'95133                           '}="541****";
$wangdianHashtable{'95135                           '}="541****";
$wangdianHashtable{'95141                           '}="541****";
$wangdianHashtable{'95143                           '}="541****";
$wangdianHashtable{'95151                           '}="541****";
$wangdianHashtable{'95153                           '}="541****";
$wangdianHashtable{'95155                           '}="541****";
$wangdianHashtable{'95161                           '}="541****";
$wangdianHashtable{'95163                           '}="541****";
$wangdianHashtable{'95171                           '}="541****";
$wangdianHashtable{'95173                           '}="541****";
$wangdianHashtable{'95181                           '}="541****";
$wangdianHashtable{'95183                           '}="541****";
$wangdianHashtable{'95191                           '}="541****";
$wangdianHashtable{'95193                           '}="541****";
$wangdianHashtable{'95201                           '}="541****";
$wangdianHashtable{'95203                           '}="541****";
$wangdianHashtable{'95211                           '}="541****";
$wangdianHashtable{'95213                           '}="541****";
$wangdianHashtable{'95221                           '}="541****";
$wangdianHashtable{'95223                           '}="541****";
$wangdianHashtable{'95231                           '}="541****";
$wangdianHashtable{'95233                           '}="541****";
$wangdianHashtable{'95241                           '}="541****";
$wangdianHashtable{'95243                           '}="541****";
$wangdianHashtable{'96001                           '}="541****";
$wangdianHashtable{'96003                           '}="541****";
$wangdianHashtable{'97001                           '}="541****";
$wangdianHashtable{'97003                           '}="541****";
$wangdianHashtable{'97004                           '}="541****";
$wangdianHashtable{'97005                           '}="541****";
$wangdianHashtable{'97006                           '}="541****";
$wangdianHashtable{'97008                           '}="541****";

	
my %diqumaHashtable;            #yb add 地区码与营业部对应关系表

	
$diqumaHashtable{'1910'}="02003";
$diqumaHashtable{'1911'}="03003";
$diqumaHashtable{'1912'}="04003";
$diqumaHashtable{'1914'}="05003";
$diqumaHashtable{'1915'}="06003";
$diqumaHashtable{'1913'}="07003";
$diqumaHashtable{'1925'}="08003";
$diqumaHashtable{'1924'}="09003";
$diqumaHashtable{'1921'}="10003";
$diqumaHashtable{'1922'}="11003";
$diqumaHashtable{'1923'}="12003";
$diqumaHashtable{'1960'}="13003";
$diqumaHashtable{'1962'}="14003";
$diqumaHashtable{'1963'}="15003";
$diqumaHashtable{'1965'}="16003";
$diqumaHashtable{'1966'}="17003";
$diqumaHashtable{'1973'}="18003";
$diqumaHashtable{'1972'}="19003";
$diqumaHashtable{'1974'}="20003";
$diqumaHashtable{'1971'}="21003";
$diqumaHashtable{'1967'}="22003";
$diqumaHashtable{'1964'}="23003";
$diqumaHashtable{'1968'}="25003";
$diqumaHashtable{'1969'}="26003";
$diqumaHashtable{'1981'}="27003";
$diqumaHashtable{'1982'}="28003";
$diqumaHashtable{'1983'}="29003";
$diqumaHashtable{'1984'}="30003";
$diqumaHashtable{'1985'}="31003";
$diqumaHashtable{'1986'}="32003";
$diqumaHashtable{'1990'}="33003";
$diqumaHashtable{'1995'}="34003";
$diqumaHashtable{'1993'}="35003";
$diqumaHashtable{'1994'}="36003";
$diqumaHashtable{'1997'}="37003";
$diqumaHashtable{'1996'}="38003";
$diqumaHashtable{'1998'}="39003";
$diqumaHashtable{'1951'}="40003";
$diqumaHashtable{'1952'}="41003";
$diqumaHashtable{'1953'}="42003";
$diqumaHashtable{'1941'}="43003";
$diqumaHashtable{'1942'}="44003";
$diqumaHashtable{'1943'}="45003";
$diqumaHashtable{'1944'}="46003";
$diqumaHashtable{'1945'}="47003";
$diqumaHashtable{'1946'}="48003";
$diqumaHashtable{'1947'}="49003";
$diqumaHashtable{'1948'}="50003";
$diqumaHashtable{'1949'}="51003";
$diqumaHashtable{'2012'}="52003";
$diqumaHashtable{'2023'}="53003";
$diqumaHashtable{'2022'}="54003";
$diqumaHashtable{'2021'}="55003";
$diqumaHashtable{'2019'}="56003";
$diqumaHashtable{'2018'}="57003";
$diqumaHashtable{'2013'}="58003";
$diqumaHashtable{'2014'}="59003";
$diqumaHashtable{'2015'}="60003";
$diqumaHashtable{'2016'}="61003";
$diqumaHashtable{'2017'}="62003";
$diqumaHashtable{'2011'}="63003";
$diqumaHashtable{'2030'}="64003";
$diqumaHashtable{'2039'}="65003";
$diqumaHashtable{'2035'}="66003";
$diqumaHashtable{'2043'}="67003";
$diqumaHashtable{'2038'}="68003";
$diqumaHashtable{'2041'}="69003";
$diqumaHashtable{'2044'}="70003";
$diqumaHashtable{'2042'}="71003";
$diqumaHashtable{'2046'}="72003";
$diqumaHashtable{'2036'}="73003";
$diqumaHashtable{'2037'}="74003";
$diqumaHashtable{'2051'}="75003";
$diqumaHashtable{'2053'}="76003";
$diqumaHashtable{'2052'}="77003";
$diqumaHashtable{'2058'}="78003";
$diqumaHashtable{'2055'}="79003";
$diqumaHashtable{'2054'}="80003";
$diqumaHashtable{'2057'}="81003";
$diqumaHashtable{'2056'}="82003";
$diqumaHashtable{'2059'}="83003";
$diqumaHashtable{'2060'}="84003";
$diqumaHashtable{'2070'}="85003";
$diqumaHashtable{'2073'}="86003";
$diqumaHashtable{'2077'}="87003";
$diqumaHashtable{'2072'}="88003";
$diqumaHashtable{'2074'}="89003";
$diqumaHashtable{'2075'}="90003";
$diqumaHashtable{'2076'}="91003";
$diqumaHashtable{'2081'}="92003";
$diqumaHashtable{'2082'}="93003";
$diqumaHashtable{'2083'}="94003";


	
	
#sub initwangdianHashtable{
#	$wangdianHashtable{'02026'} = "5411910";
#	$wangdianHashtable{'02151'} = "5411910";
#	
#}
#&initwangdianHashtable();



#函数定义

# ------------------------------
# &nowdate()
# 当前日期
# ------------------------------
sub latestDate {
my ( $d,$m,$y ) = (localtime(time()))[3,4,5];
$y -= 100;
$m ++;
if(($m == 2 || $m == 4 || $m == 6 || $m ==8 || $m == 9 || $m == 11)
   && $d == 1){
    $m --;
    $d = 31;
}
elsif($m ==3 && $d == 1){
    $m --;
    if($y % 4 == 0){
        if($y % 100 == 0){
            if($y % 400 == 0){
                $d = 29;
            }
            else{
                $d = 28;
            }
        }
        else{
            $d = 29;
        }
    }
    else{
        $d = 28;
    }
}
elsif(($m == 5 || $m == 7 || $m == 10 || $m == 12) && $d == 1){
    $m --;
    $d =30;
}
elsif($m == 1 && $d == 1){
    $y --;
    $m = 12;
    $d = 31;
}
else{
    $d --;
}
return sprintf("%02d%02d%02d",$y,$m,$d);
}

# ------------------------------
# &nowtime()
# 当前时间
# ------------------------------
sub nowtime {
my ( $s,$min,$h,$d,$m,$y ) = (localtime(time()))[0,1,2,3,4,5];
$y += 1900;
$m ++;
return sprintf("%4d-%02d-%02d %02d:%02d:%02d",$y,$m,$d,$h,$min,$s);
}

# ------------------------------
# &getWorkingPath()
# 获取工作目录路径，即脚本的工作目录
# ------------------------------
sub getWorkingPath(){
    my $empty = "";
    my $tmppath = "";
    my $pathsplit="/";
    if((WORKINGPATH gt $empty) &&
       (-d WORKINGPATH)){
        $tmppath = WORKINGPATH;
        my $tmp = substr($tmppath,length($tmppath)-1,);
        if($tmp gt $pathsplit){
            substr($tmppath,length($tmppath),)="/"
        }
    }
    if($tmppath eq $empty){
        $tmppath="./"
    }
    return $tmppath;
}

# ------------------------------
# &getDstPath()
# 获取输出目的路径，即汇总结果输出的目的路径
# ------------------------------
sub getDstPath {
    my $empty = "";
    my $tmppath = "";
    my $pathsplit="/";
    if(DSTFILEPATH gt $empty){
        $tmppath=DSTFILEPATH;
        my $tmp = substr($tmppath,length($tmppath)-1,);
        if($tmp gt $pathsplit){
            substr($tmppath,length($tmppath),)="/"
        }
    }
    if($tmppath eq $empty){
        $tmppath = sprintf("%s%s/20%s/",&getWorkingPath(),DESTINSCODE,$workDate);
    }
    return $tmppath;
}


# ------------------------------
# &loadAcqList()
# 加载机构列表
# ------------------------------
sub loadAcqList{
    my $acqlistfilepath = sprintf("%s",SRCINSFILNM);
    open my $acqlistfile, $acqlistfilepath or die "Cannot open $acqlistfilepath: $!";
    @acqList = <$acqlistfile>
}







#程序开始
#判断日期是否根据输入或者取系统时间
if(DATEINPROMP){
    print "请输入文件日期(YYMMDD格式)：";
    $workDate = <STDIN>;
    chomp($workDate);
}
else{
    $workDate = &latestDate();
}
#打开日志文件记录
my $logfilepath = sprintf(">> %s",ERRFILENAME);
open my $logfile, $logfilepath or die "Cannot open log.txt: $!";

#yb add 打开ERRORINFO文件
my $errorinfofilepath = sprintf(">> %s%s%s%s",&getDstPath(),DSTFILEPREX,$workDate,ERRORINFOFILENAME);
open my $errorinfofile, $errorinfofilepath or die "Cannot open log.txt: $!";
print $errorinfofile <<EOT;

未能匹配到网点号的交易信息   

  商户代码          商户名称                                            交易笔数                  交易金额                应收费用                应付费用              费用清算净额        收单收益账号                      
  ────────  ─────────────────────      ──────      ──────────      ─────────      ─────────      ──────────        ─────────────────

EOT

$time = &nowtime();
print $logfile <<EOT;
汇总收益工作开始[$workDate]  开始时间：$time
---------------------------------------------------------------
EOT

#从机构列表文件读取机构列表
&loadAcqList();
if($#acqList == -1){
    print $logfile <<EOT;
错误：无法读取机构列表，请检查存放机构代码的文件。
出现错误，未能完成汇总工作。


EOT
exit 1;
}

#到每个机构对应的目录下读取汇总文件
foreach my $item (@acqList){
    my $tmpsrcfile;
    $item = substr($item,0,8);
    my $tmpsrcfilepath = sprintf("%s%s/20%s/%s%s00",&getWorkingPath(),$item,$workDate,SRCFILEPREX,$workDate);
    if(-e $tmpsrcfilepath){
        unless(open $tmpsrcfile, $tmpsrcfilepath){
print $logfile <<EOT;
错误：无法读取文件[$tmpsrcfile]
出现错误，未能完成汇总工作。


EOT
        die "Cannot open $tmpsrcfilepath: $!";
        }
        

#汇总开始        
        $time = &nowtime();
print $logfile <<EOT;
开始汇总[$tmpsrcfilepath]  开始时间：$time   
EOT

        my @sumsrclinelist = <$tmpsrcfile>;
        my $feeSum = 0.0;
       
        
        foreach my $item (@sumsrclinelist){

            if(length($item) > 63){
                my $s1 = substr($item,0,2);
                my $s2 = substr($item,2,1);
                my $s3 = substr($item,0,12);
                my $s4 = substr($item,5,4);  #yb add 取商户号中的地区码 放入变量s4中
                my $s6 = substr($item,0,223);  #yb add 取整条记录
                my $s7 = substr($item,13,4);# yb add 取商户号最后4位
                
                if(($s1 eq "  ")
                   && !($s2 =~/[^0-9]+/)) {
                    $s1 = substr($item,length($item)-63,62);
                    $s2 = substr($s1,28,32);
                    $s1 = substr($s1,0,20);
                    $feeSum += $s1;
                   # if(exists$insFeeHashtable{$s2}){

                   if(exists$wangdianHashtable{$s2})  # yb add 如果网点表里存在这个网点号
                   {

                   	
                   	if(exists$insFeeHashtable{$s2}){
                        my $fee = $insFeeHashtable{$s2};
                        $fee += $s1;
                        $insFeeHashtable{$s2} = $fee;
                    }
                    else{
                        $insFeeHashtable{$s2} = $s1+0.0;
                    }
                  }
                    else                              # yb add 如果网点表里不存在这个网点号
                    {
                    	if(exists$diqumaHashtable{$s4})   #如果商户号中的地区码有对应的营业网点号
                    	{
                    		#my $s5 =$diqumaHashtable{$s4};
                    		my $s5 =$diqumaHashtable{$s4}.'                           ';
                    		if(exists$insFeeHashtable{$s5})
                    		{
                        	my $fee = $insFeeHashtable{$s5};
                        	$fee += $s1;
                        	$insFeeHashtable{$s5} = $fee;
                    		}
                    		else
                    		{
                        	$insFeeHashtable{$s5} = $s1+0.0;
                        	

                        	
                    		}
                    		
                    	}
                    	else
                    	{
                    		if($s4 eq "1920")
                    		{
                    			if($s7 >= 5000)
                    			{
                    				#1924
                    				my $s8 =$diqumaHashtable{"1924"}.'                           ';
                    				if(exists$insFeeHashtable{$s8})
                    				{
                        			my $fee11 = $insFeeHashtable{$s8};
                        			$fee11 += $s1;
                        			$insFeeHashtable{$s8} = $fee11;
                    				}
                    				else
                    				{
                        			$insFeeHashtable{$s8} = $s1+0.0;
                    				}
                    				
                    			}
                    			if($s7 < 5000)
                    			{
                    				#1925
                    				my $s9 =$diqumaHashtable{"1925"}.'                           ';
                    				if(exists$insFeeHashtable{$s9})
                    				{
                        			my $fee12 = $insFeeHashtable{$s9};
                        			$fee12 += $s1;
                        			$insFeeHashtable{$s9} = $fee12;
                    				}
                    				else
                    				{
                        			$insFeeHashtable{$s9} = $s1+0.0;
                    				}
                    			}
                    			
                    		}
                    		if($s4 eq "1940")
                    		{
                    			if($s7 >= 6000)
                    			{
                    				#1952
                    				my $s10 =$diqumaHashtable{"1952"}.'                           ';
                    				if(exists$insFeeHashtable{$s10})
                    				{
                        			my $fee13 = $insFeeHashtable{$s10};
                        			$fee13 += $s1;
                        			$insFeeHashtable{$s10} = $fee13;
                    				}
                    				else
                    				{
                        			$insFeeHashtable{$s10} = $s1+0.0;
                    				}
                    			
                    			}
                    			if($s7 <= 3000)
                    			{
                    				#1951
                    				my $s11 =$diqumaHashtable{"1951"}.'                           ';
                    				if(exists$insFeeHashtable{$s11})
                    				{
                        			my $fee14 = $insFeeHashtable{$s11};
                        			$fee14 += $s1;
                        			$insFeeHashtable{$s11} = $fee14;
                    				}
                    				else
                    				{
                        			$insFeeHashtable{$s11} = $s1+0.0;
                    				}
                    			
                    			}
                    			if($s7 > 3000 && $s7 < 6000)
                    			{
                    				
                    				#1953
                    				my $s12 =$diqumaHashtable{"1953"}.'                           ';
                    				if(exists$insFeeHashtable{$s12})
                    				{
                        			my $fee15 = $insFeeHashtable{$s12};
                        			$fee15 += $s1;
                        			$insFeeHashtable{$s12} = $fee15;
                    				}
                    				else
                    				{
                        			$insFeeHashtable{$s12} = $s1+0.0;
                    				}
                    			}
                    		}
                    		
                    		
                    		if(!($s4 eq "1920" || $s4 eq "1940"))# yb add 如果地区码等于1920或1940，计入未能匹配的错误文件。
                    		{
                    			#yb add 将无法对应网点号的交易记录，计入ERROR中，并将明细信息整条计入差错文件	
                    			if(exists$insFeeHashtable{'ERROR'})
                    			{
                        		my $fee16 = $insFeeHashtable{'ERROR'};
                        		$fee16 += $s1;
                        		$insFeeHashtable{'ERROR'} = $fee16;
                    			}
                    			else
                    			{
                       	 		$insFeeHashtable{'ERROR'} = $s1+0.0;
                    			}
                    			#yb add 将明细信息整条计入差错文件
print $errorinfofile <<EOT;
$s6
EOT
												}
                    	}
                    }    
                }
                elsif($s3 eq "        总计"){
                    $s3 = substr($item,160,20);
                    $s3 += 0.0;
                    if($s3-$feeSum >= 0.001 || $feeSum-$s3 >= 0.001){
print $logfile <<EOT;
错误：汇总文件[$tmpsrcfilepath]总计不平
总计[$s3]    计算累计[$feeSum]
出现错误，未能完成汇总工作。


EOT
        exit 1;                        
                    }
                }
            }
        }

print $logfile <<EOT;
结束汇总[$tmpsrcfilepath]  结束时间：$time
EOT
    }
    else{
print $logfile <<EOT;
警告：找不到文件[$tmpsrcfilepath]继续汇总下一个机构
EOT
    }
}

my $tmpdstfilepath = sprintf("%s%s%s%s",&getDstPath(),DSTFILEPREX,$workDate,DSTFILESUBX);
my $tmpdstfile;
if(-e $tmpdstfilepath){
    unless(unlink $tmpdstfilepath){
        print $logfile <<EOT;
错误：文件[$tmpdstfilepath]已经存在且无法删除，请删除后重新尝试汇总
出现错误，未能完成汇总工作。


EOT
    }
}
if(scalar(keys%insFeeHashtable) <= 0){
print $logfile <<EOT;
错误：未能完成任何汇总工作，请检查文件目录名称及结构。
出现错误，未能完成汇总工作。


EOT
    exit 1;
}
unless(open $tmpdstfile, " >> ", $tmpdstfilepath){
print $logfile <<EOT;
错误：无法打开文件[$tmpdstfilepath]
出现错误，未能完成汇总工作。


EOT
        exit 1;
        }
$time = &nowtime();
print $logfile <<EOT;
开始写入汇总结果文件[$tmpdstfilepath] 开始时间：$time
EOT
    my @keysInHashtable = sort keys%insFeeHashtable;
    my $counter = 0;
    my $feeSum = 0.0;
    foreach my $item (@keysInHashtable){
        if(exists$insFeeHashtable{$item}){
            $counter++;
            $feeSum += $insFeeHashtable{$item};
            my $itemtemp=$item;
            $itemtemp=~s/ +$//;
            my $outputstr = sprintf("%-5s%s%.2f%s",$itemtemp,';',$insFeeHashtable{$item},';');
            print $tmpdstfile <<EOT;
$outputstr
EOT
        }
    }
    my $outputstr = sprintf("%-5d%s%.2f%s",99999,';',$feeSum,';');
    print $tmpdstfile <<EOT;
$outputstr
EOT
$time = &nowtime();
print $logfile <<EOT;
完成写入汇总结果文件[$tmpdstfilepath] 结束时间：$time
EOT

$time = &nowtime();
print $logfile <<EOT;
---------------------------------------------------------------
汇总收益工作结束[$workDate]  结束时间：$time


EOT


#程序结束



# -*- coding: UTF-8 -*-

import calendar
cal = calendar.month(2016,8)
print cal

# 000 100以内的质数
i=2
while(i<100):
    j=2
    while(j<=i/j):
        if(i%j==0):break
        j=j+1
    if(j>i/j):print'%d is Pri' %i
    i=i+1

# 001 1、2、3、4能组成多少不重复的3位数
count=0
for i in range(1,5):
    for j in range(1,5):
        for k in range(1,5):
            if(k!=i) and (k!=j) and (i!=j):
                print i,j,k;
                count+=1
print count

# 002 阶梯纳税
i=int(input('请输入利润：'))

salary=[0,100000,200000,400000,600000,1000000]
per=[0.1,0.075,0.05,0.03,0.015,0.01]

sum=0
for n in range(1,6):
    if(i<salary[n]):
        sum+=(i-salary[n-1])*per[n-1]
        break
    else:
        sum+=(salary[n]-salary[n-1])*per[n-1]

if(i>1000000):
    sum+=(i-salary[5])*per[5]

print sum

# 003 求某整数
import math

i=1
while 1==1:
    x=int(math.sqrt(i+100))
    y=int(math.sqrt(i+268))
    if((x*x == i+100) and (y*y == i+268)):
        break
    i+=1
print i

# 004 计算一年中的第几天
y = int(raw_input("input year:\n"))
m = int(input("input month:\n"))
d = int(input("input day:\n"))
month = [31,28,31,30,31,30,31,31,30,31,30,31]

flag = 1 # 0 闰年
if(y%4 == 0):
    if(y%100 == 0):
        if(y%400 == 0):
            flag = 0
        else:
            flag=1
    else:
        flag=0       
else:
    flag=1

i=1
s=d
while(i<m):
   s+=month[i-1]
   i+=1   
if(flag == 0) and (m>2):s+=1
print s

# 005 斐波那契数列
c=int(raw_input("input how long\n"))
      
def fn(n):
    if n==1:
        return [1]
    if n==2:
        return [1,1]
    fib = [1,1]
    for i in range(2,n):
        fib.append(fib[-2]+fib[-1])
    return fib

print fn(c)

# 006 sleep
import time
for i in range(1,10):
    print time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
    time.sleep(2)

# 007 水仙花数
for i in range(100,1000):
    a=i%10
    b=(i/10)%10
    c=i/100
    if(i == a*a*a + b*b*b + c*c*c):print i

# 008 分解质因数
nu = int(raw_input("input a number:\n"))
li=[]
def p(n):
    if n==1:
        print "Error Input!"
        return
    if n==2:
        li.append(n)
        return li
    for i in range(2,n+1):
        if(i != n):
            if(n%i == 0):
                li.append(i)
                p(n/i)
                break
        else:
            li.append(i)
            break     
    return li
p(nu)

if(len(li) == 1):print str(nu)+"=1*"+str(li[0])
elif(len(li) >1):        
    fomu=str(nu)+"="
    for i in range(0,len(li)-1):
        fomu=fomu+str(li[i])+"*"
    fomu+=str(li[i+1])    
    print fomu

# 009 完美数
def perfect(n):
    sum=0
    i=2
    while(i<n/i):
        if(n%i == 0):
            sum+=i
            sum+=n/i
        i+=1
    return sum

num=2
while(num<=1000):
    if(perfect(num) == num-1):print num
    num+=1

n=1
while(n<=2):
   a = int(raw_input("input a number:\n"))
   print '*'*a
   n+=1








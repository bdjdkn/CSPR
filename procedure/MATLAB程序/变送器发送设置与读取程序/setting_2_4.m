%两个四路数字变送器设置文件
%2023.1.2       张胤启
%   1、设置变送器     状态1.1：设置零点    状态1.2：标定量程比例系数
%   2、连续发送的状态
%   3、接收一帧确认进入连续发送状态
%   4、返回成功的命令
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;%清除所有内容
txt="请核对串口信息";
disp(txt);
scom1= serialport('COM3',115200);%配置第一个变送器的串口
scom2= serialport('COM12',115200);%配置第二个变送器的串口
disp(scom1);
disp(scom2);
flush(scom1);%清除1号缓冲区
flush(scom2);%清除2号缓冲区
%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt="请设置模块参数,默认更改所有通道的参数";
disp(txt);
txt="AD转换速率 0x00:10 0x01:40 0x02:640 0x03:不更改";
AD=input(txt);
right=[0xFE,0x01,0xF2,0x01,0xCF,0xFC,0xCC,0xFF];
if  AD~=0x03
    txt="设置极性 0x00:双向;0x01:单向    默认单向";
    Polay=input(txt);
    data(:,1)=[0xFE,0x01,0x21,0xFF,AD,Polay,0xCF,0xFC,0xCC,0xFF];
    write(scom1,data,"uint8");
    write(scom2,data,"uint8");
    back_AD1=read(scom1,8,"uint8");
    back_AD2=read(scom2,8,"uint8");
    if back_AD1==right
        txt="一号设置成功";
        disp(txt);
    end
    if back_AD2==right
        txt="二号设置成功";
        disp(txt);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt="滤波器设置";
disp(txt);
txt="滤波方式";
disp(txt);
txt="0x00:不使用 0x01:平均值滤波";
disp(txt);
txt="0x02:中位值滤波 0x03:一阶滤波";
disp(txt);
txt="0x04:滑动平均滤波 0x05:中位值平均滤波";
disp(txt);
txt="0x06:滑动中位值平均滤波";
disp(txt);
txt="0x07:平均值滤波 + 一阶滤波";
disp(txt);
txt="0x08:中位值滤波 + 一阶滤波";
disp(txt);
txt="0x09:滑动平均滤波 + 一阶滤波";
disp(txt);
txt="0x0A:中位值平均滤波 + 一阶滤";
disp(txt);
txt="0x10不更改";
lvbo=input(txt);
if lvbo~=0x10
    txt="范围：0~50，数字越大，滤波越强 ";
    level=input(txt);
    data(:,1)=[0xFE,0x01,0x22,0xFF,lvbo,level,0xCF,0xFC,0xCC,0xFF];
    write(scom1,data,"uint8");
    write(scom2,data,"uint8");
    back_lvbo1=read(scom1,8,"uint8");
    back_lvbo2=read(scom2,8,"uint8");
    if back_lvbo1==right
        txt="一号设置成功";
        disp(txt);
    end
    if back_lvbo2==right
        txt="二号设置成功";
        disp(txt);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt="是否设置零点";
disp(txt);
txt="0x01 是  0x00 否";
zero=input(txt);
if zero==0x01
    data_zero(:,1)=[0xFE,0x01,0x30,0xFF,0x00,0x00,0x00,0x00,0xCF,0xFC,0xCC,0xFF];
    write(scom1,data_zero,"uint8");
    write(scom2,data_zero,"uint8");
    back_zero1=read(scom1,8,"uint8");
    back_zero2=read(scom2,8,"uint8");
     if back_zero1==right
        txt="一号设置成功";
        disp(txt);
    end
    if back_zero2==right
        txt="二号设置成功";
        disp(txt);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt="连续发送设置";
disp(txt);
txt="延迟设置    16进制    单位ms    不应小于5ms，小于5ms，会造成一定的数据帧破损";
delay=input(txt);
txt="数据类型;0x00:测量值;0x01:AD 内码值;0x02:毛重值;0x03:净重值;0x04:峰值;0x05:谷值;0x06:峰谷差值";
datatype=input(txt);%数据类型;00:测量值;01:AD 内码值;02:毛重值;03:净重值;04:峰值;05:谷值;06:峰谷差值
txt="发送类型:0x00:不管数据有没有变化，都发送；0x01:只在数据变化时发送";
sandtype=input(txt);%发送类型:0x00:不管数据有没有变化，都发送；0x01:只在数据变化时发送
data_sand(:,1)=[0xFE,0x01,0x07,0xFF,0x01,datatype,sandtype,delay,0xCF,0xFC,0xCC,0xFF];
write(scom1,data_sand,"uint8");
back_sand1=read(scom1,8,"uint8");
write(scom2,data_sand,"uint8");
back_sand2=read(scom2,8,"uint8");
if back_sand1==right
      txt="一号发送成功";
      disp(txt);
end
if back_sand2==right
      txt="二号发送成功";
      disp(txt);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;%清除所有内容 关闭串口
%更改相应设置需在下面更改
%变送器设置数据
%协议         自由协议
%波特率       115200
%地址         01
%校验         00不使用
%AD转换速率   640
%滤波         0x01  5
%重量单位     00 无
%最大重量和分度    10，000  0x09  0.1

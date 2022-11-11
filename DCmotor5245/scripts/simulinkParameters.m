%clear
clc;


potpin =0; %A0
pwmEnablepin =6;
driverIn1pin =10;
driverIn2pin =9;
motorOutApin =3; %// yellow A
motorOutBpin =2; %// white B

Ts = 0.05;

J=0.018256;
b=0.168599;
kt=1.595349;
kb=1.56749;
R=1.746171;
L=0;

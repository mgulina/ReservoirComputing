clc; clearvars;
N = 10;
msg = randi(2,N,8) - 1;

MSG = char(bin2dec(num2str(msg)))'


a = 'Hello Bob !' %#ok<*NOPTS>
b = double(a)
c = dec2bin(b);
d  =  bin2dec(c)
e  =  char(d)'


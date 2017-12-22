clear;
clc;
[y,Fs] = audioread('dtmf.wav');
N = 100;
freqs = [697,770,852,941,1209,1336,1477];
inst_power = filter(ones(1,N)/N,1,y.*y);
threshold = 0.5*max(inst_power);
p_gt_t = zeros(1,length(y));
for i = (1:length(y))
    if(inst_power(i)>threshold)
        p_gt_t(i) = 1;
    else
        p_gt_t(i) = 0;
    end
end
clear i;
beginning = find(p_gt_t(2:length(y)) - p_gt_t(1:length(y)-1)== 1);
ending = find(p_gt_t(2:length(y)) - p_gt_t(1:length(y)-1)== -1);

len = ending - beginning + 1;
k = ceil(freqs' * len/Fs);

num = 0;
for n = 1:length(beginning)
    x = y(beginning(n):ending(n));
    fft2 = abs(fft(x));
    a = find(fft2(k(1:4,n)) == max(fft2(k(1:4,n))));
    b = find(fft2(k(5:7,n)) == max(fft2(k(5:7,n))));
    num = num*10 +find_num(a,b);
end
num
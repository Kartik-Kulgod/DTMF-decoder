clear;
clc;
[y,Fs] = audioread('dtmfA1.wav');
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
k = round(freqs' * len/Fs);

Wn = exp(sqrt(-1)*2*pi*k./len);
num = 0;

for h = 1:length(beginning)
    a = horzcat(ones(length(freqs),1),-Wn(:,h));
    x1 = vertcat(y(beginning(h):ending(h)),[0]);
    z1 = filter(1,a(1,:),x1);
    z2 = filter(1,a(2,:),x1);
    z3 = filter(1,a(3,:),x1);
    z4 = filter(1,a(4,:),x1);
    z5 = filter(1,a(5,:),x1);
    z6 = filter(1,a(6,:),x1);
    z7 = filter(1,a(7,:),x1);
    z = [z1(len(h)+1),z2(len(h)+1),z3(len(h)+1),z4(len(h)+1),z5(len(h)+1),z6(len(h)+1),z7(len(h)+1)];
    r = find(abs(z(1:4)) == max(abs(z(1:4))));
    c = find(abs(z(5:7)) == max(abs(z(5:7))));
    num = num*10 + find_num(r,c);
end
num   
    
    
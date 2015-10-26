clear; clc; close all;

%% LDR merging into HDR
% 1- naive LDR | 2- under/over | 3 - response function
method = 3;
scene_num = 4;
exp{1} =  [40,160,640,2000];
exp{4} = [25,60,125,200,500];
exp_time = exp{scene_num};
cp_size = 500;
img_stack = zeros(cp_size,cp_size,3,length(exp_time));

% loading image with different exposure time into stack
for i = 1: length(exp_time)
    impath = ['.\images\scene0', num2str(scene_num), '\cp_t', num2str(exp_time(i)),'.jpg'];
    toadd = im2double(imread(impath));
    toadd = imresize(toadd, [cp_size, cp_size],'bilinear');
    img_stack(:,:,:,i) = toadd;    
end

% apply hdr transform
exp_time = 1./exp_time;
if method == 1 % naive LDR
    hdr_naive = makehdr_naive(img_stack, exp_time);
    hdrwrite(hdr_naive,'.\hdr_images\HDR_naive.hdr');
    rgb = tonemap(hdr_naive);
    imwrite(rgb,'.\hdr_images\HDR_naive.jpg');
    ball_hdr = hdr_naive;
    
elseif method == 2 % under/over
    hdr_ovud = makehdr_overunder(img_stack, exp_time,0.02);
    hdrwrite(hdr_ovud,'.\hdr_images\HDR_weighted.hdr');
    rgb = tonemap(hdr_ovud);
    imwrite(rgb,'.\hdr_images\HDR_weighted.jpg');
    ball_hdr = hdr_ovud;
    
elseif method == 3 % response function
    hdr_rfunc = makehdr_respfunc(img_stack,exp_time,150);
    hdrwrite(hdr_rfunc,'.\hdr_images\HDR_rfunc.hdr');
    rgb = tonemap(hdr_rfunc);
    imwrite(rgb,'.\hdr_images\HDR_rfunc.jpg');
    ball_hdr = hdr_rfunc;
    
end

%% Panoramic transformations
latlon = mirrorball2latlon(ball_hdr); 

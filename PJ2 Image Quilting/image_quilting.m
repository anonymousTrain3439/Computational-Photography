clc; clear; close all;

%% image quilting
% load image
num = 4;
size = [51,41,41,15];
img = im2double(imread(['.\images\tx_',num2str(num),'.jpg']));
figure(1),imshow(img),title('The original image');
imwrite(img,['.\results\org_img_',num2str(num),'.jpg']);

% parameter settings
sample = img;
outsize = 400;
patchsize = size(num);

% image quilting method selection
rand_sample = false;
overlap_patches = false;
seam_finding = false;

if (rand_sample) 
    % Random sample image
    out_rand = quilt_random(sample, outsize, patchsize);
    figure(2),imshow(out_rand),title('The random sampled image');
    imwrite(out_rand,['.\results\rdm_sp_',num2str(num),'.jpg']);
end

if (overlap_patches)
    % Overlapping patches
    overlap = floor(patchsize / 5);
    tol = 0.1;
    out_over = quilt_simple(sample,outsize,patchsize,overlap,tol);
    
    figure(3),imshow(out_over),title('The overlapped image');
    imwrite(out_over,['.\results\ovlp_pch_',num2str(num),'.jpg']);
end

if (seam_finding)
        overlap = floor(patchsize / 5);
        tol = 0.1;
        out_seam = quilt_seam(sample,outsize,patchsize,overlap,tol);
        
        figure(4),imshow(out_seam),title('The seam finding image');
        imwrite(out_seam,['.\results\seam_fd_',num2str(num),'.jpg']);
end
%% texture transfer
clear;clc;close all;
% Loading image
num = 1;
size = [21];
sample_img = im2double(imread(['.\images\sam_',num2str(num),'.jpg']));
target_img = im2double(imread(['.\images\tar_',num2str(num),'.jpg']));

% Setting parameters
patchsize = size(num);
overlap = floor(patchsize / 5);
tol = 0.1;
alpha = 0.3;

% Texture transfering
tex_trans = texture_transfer(sample_img,target_img, patchsize,overlap,tol,alpha);

% Display settings
figure(5),
subplot(121),imshow(sample_img),title('The original texture image');
subplot(122),imshow(target_img),title('The original target image');
figure(6),imshow(tex_trans),title('The texture transfer result');
imwrite(tex_trans,['.\results\tx_transf_',num2str(num),'.jpg']);
clc;
clear;
close all;

run('../vlfeat-0.9.21/toolbox/vl_setup.m');

%% parameters
% image data number
img_num = 5;

% matching parameter
cutoff_ratio = 0.6;

% ransac parameters
iteration = 5000;
threshold = 0.5; 
%%

for i = 1:img_num
    
    %path = ['../assg1/im0',num2str(i),'.jpg'];
    path = ['../assg1/pic0',num2str(i),'.jpg'];
    img = imread(path);
    catalog{i} = img;
    
end


% stitching starts from the middle of the image stack to prevent large
% distortion at one end of the panorama
seq = zeros(img_num,1);
for j = 1:img_num
    idx = ((-1)^(j-1)) * ceil((j-1)/2) + ceil((img_num + 1) / 2);
    seq(j) = idx;
end


for k = 1:img_num-1
    
    if k == 1 
        img1 = catalog{seq(k)};
    else
        img1 = stitched_img;
    end
    img2 = catalog{seq(k+1)};
    
    img1_g = single(rgb2gray(img1));
    [f1,d1] = vl_sift(img1_g);
    img2_g = single(rgb2gray(img2));
    [f2,d2] = vl_sift(img2_g);
    match_list = matching(f1,d1,f2,d2,cutoff_ratio);
    
    match_list1 = match_list(1:3,:);
    match_list2 = match_list(4:6,:);
    
    [best_H, inliner_list] = ransac(match_list2, match_list1, iteration, threshold);
    [img2_t, x_min, y_min] = img_transform(img2, best_H);
    
    offset = [-x_min; -y_min];

    stitched_img = do_stitch(img1, img2_t, offset);
    disp('Stitching continues...');
    figure;
    imshow(stitched_img);
    
end

disp('Stitching done.');

% figure;
% imshow(stitched_img);


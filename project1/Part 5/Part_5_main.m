clc;
clear;
close all;
run('../vlfeat-0.9.21/toolbox/vl_setup.m');

% matching parameter
cutoff_ratio = 0.8;

% ransac parameters
iteration = 10000;
threshold = 1; 

path1 = '../assg1/im01.jpg';
path2 = '../assg1/im02.jpg';
img1 = imread(path1);
img2 = imread(path2);

img1_g = single(rgb2gray(img1));
[f1,d1] = vl_sift(img1_g);
img2_g = single(rgb2gray(img2));
[f2,d2] = vl_sift(img2_g);

match_list = matching(f1,d1,f2,d2, cutoff_ratio);

canvas = [img1 img2];

%% show all the matches

figure;
imshow(canvas);
title('Show all the matches');

hold on;

for i = 1:size(match_list,2)
   X = [match_list(1,i) match_list(4,i)+size(img1,2)];
   Y = [match_list(2,i) match_list(5,i)];
   plot(X,Y,'LineWidth',1);
end

hold off;

%% show all the inliner matches

figure;
imshow(canvas);
title('Show all the inlier matches');
hold on;

 match_list1 = match_list(1:3,:);
 match_list2 = match_list(4:6,:);

 [best_H, inliner_list] = ransac(match_list1, match_list2, iteration, threshold);

for i = 1:size(inliner_list,2)
   X = [inliner_list(1,i) inliner_list(4,i)+size(img1,2)];
   Y = [inliner_list(2,i) inliner_list(5,i)];
   plot(X,Y,'LineWidth',1);
end

hold off;

%% stitch image 1 to image 2

[img1_t, x_min, y_min] = img_transform(img1, best_H);

offset = [-x_min; -y_min];

stitched_1 = do_stitch(img2, img1_t, offset);
figure;
imshow(stitched_1);
title('stitch image 1 to image 2 using the best homography matrix');



%% stitch image 2 to image 1

[best_H, inliner_list] = ransac(match_list2, match_list1, iteration, threshold);
[img2_t, x_min, y_min] = img_transform(img2, best_H);

offset = [-x_min; -y_min];

stitched_2 = do_stitch(img1, img2_t, offset);
figure;
imshow(stitched_2);
title('stitch image 2 to image 1 using the best homograohy matrix');



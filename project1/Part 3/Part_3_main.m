clear;
clc;

[pts_img1, pts_img2, img1, img2] = Part_3_gui;

A = zeros(8,9);

for i = 1:4
    
    x1 = pts_img1(i,1);
    y1 = pts_img1(i,2);
    x2 = pts_img2(i,1);
    y2 = pts_img2(i,2);
    
    A(2*i-1,:) = [x1 y1 1 0 0 0 -x1*x2 -x2*y1 -x2];
    A(2*i,:) = [0 0 0 x1 y1 1 -y2*x1 -y1*y2 -y2];
  
end

[~,~,V] = svd(A);

H = reshape(V(:,end),[3,3]);
H = transpose(H);
disp(H);

f = img_transform(img1, H);

imshow(f);
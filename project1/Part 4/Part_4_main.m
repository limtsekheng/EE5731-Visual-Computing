clear;
clc;

[pts_img1, pts_img2, img1, img2] = Part_4_gui;

A = zeros(8,9);

for i = 1:4
    
    x1 = pts_img1(1,i);
    y1 = pts_img1(2,i);
    x2 = pts_img2(1,i);
    y2 = pts_img2(2,i);
    
    A(2*i-1,:) = [x2 y2 1 0 0 0 -x2*x1 -x1*y2 -x1];
    A(2*i,:) = [0 0 0 x2 y2 1 -y1*x2 -y2*y1 -y1];
  
end

[~,~,V] = svd(A);

H = reshape(V(:,end),[3,3]);
H = transpose(H);  

% transfer img2 to img1 space
[img2_t, x_min, y_min] = img_transform(img2, H);

offset = [-x_min; -y_min];

g = do_stitch(img1, img2_t, offset);

imshow(g);
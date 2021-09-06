function img_stitch = do_stitch(img1, img2, offset)

x_offset = offset(1);
y_offset = offset(2);

img1_x = size(img1,2);
img1_y = size(img1,1);
img2_x = size(img2,2);
img2_y = size(img2,1);

% determine the size of canvas
if x_offset < 0 
    canvas_x = max(img2_x, img1_x + x_offset) - x_offset;
else
    canvas_x = max(img2_x, img1_x + x_offset);  
end


if y_offset < 0
    canvas_y = max(img2_y, img1_y + y_offset) - y_offset;
else
    canvas_y = max(img2_y, img1_y + y_offset);
end

% create 2 canvases of same size, one for image 1 and the other for image 2
canvas1 = zeros(canvas_y, canvas_x, 3);
canvas2 = zeros(canvas_y, canvas_x, 3);

% determine the relative position of two images on canvas
if x_offset > 0 && y_offset > 0
    canvas1(1+y_offset : y_offset+img1_y, 1+x_offset : x_offset+img1_x, :) = img1(:,:,:);
    canvas2(1 : img2_y, 1 : img2_x, :) = img2(:,:,:);
    canvas1_loc = [1+y_offset;  y_offset+img1_y; 1+x_offset;  x_offset+img1_x];
    canvas2_loc = [1; img2_y; 1; img2_x];
    
elseif x_offset > 0 && y_offset < 0
    canvas1(1 : img1_y, 1+x_offset : x_offset+img1_x, :) = img1(:,:,:);
    canvas2(1-y_offset : img2_y-y_offset, 1 : img2_x, :) = img2(:,:,:);
    canvas1_loc = [1; img1_y; 1+x_offset; x_offset+img1_x];
    canvas2_loc = [1-y_offset; img2_y-y_offset; 1; img2_x];
    
elseif x_offset < 0 && y_offset > 0
    canvas1(1+y_offset : y_offset+img1_y, 1 : img1_x, :) = img1(:,:,:);
    canvas2(1 : img2_y, 1-x_offset : img2_x-x_offset, :) = img2(:,:,:);
    canvas1_loc = [1+y_offset; y_offset+img1_y; 1; img1_x];
    canvas2_loc = [1; img2_y; 1-x_offset; img2_x-x_offset];
    
elseif x_offset < 0 && y_offset < 0
    canvas1(1 : img1_y, 1 : img1_x, :) = img1(:,:,:);
    canvas2(1-y_offset : img2_y-y_offset, 1-x_offset : img2_x-x_offset, :) = img2(:,:,:);
    canvas1_loc = [1; img1_y; 1; img1_x];
    canvas2_loc = [1-y_offset; img2_y-y_offset; 1-x_offset; img2_x-x_offset];
    
end

% multi band blending
img_stitch = do_blending(canvas1, canvas2, canvas1_loc, canvas2_loc);


    
    




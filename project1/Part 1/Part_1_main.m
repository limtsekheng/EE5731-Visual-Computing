clc;
clear;
close all;


%% User input here

filename = '../assg1/im01.jpg';
kernel_name = 'haar';  % 'sobel', 'gaussian', 'haar'

haar_type = 'type_1';  % 'type_1', 'type_2', 'type_3', 'type_4', 'type_5' 
haar_x = 2;
haar_y = 2;

%% End of user input


I = imread(filename);
if size(I,3) == 3
    I = rgb2gray(I);
end
I = double(I);


if strcmp(kernel_name, 'sobel')
    Gx = sobel_x_init();
    Gy = sobel_y_init();
    Ix = do_2d_conv(I, Gx, 'sobel');
    Iy = do_2d_conv(I, Gy, 'sobel');
    result = (Ix.^2 + Iy.^2).^(0.5);
    
elseif strcmp(kernel_name, 'gaussian')
    filter = gaussian_init();
    result = do_2d_conv(I, filter, 'gaussian');

else
    filter = haar_init(haar_type, haar_x, haar_y);
    result = do_2d_conv(I, filter, 'haar');

end

result = result - min(result(:));
result = result ./ max(result(:));
imshow(result);



%% filter initialization function

function mask = sobel_x_init()
mask = [1 0 -1; 2 0 -2; 1 0 -1];
end


function mask = sobel_y_init()
mask = [1 2 1; 0 0 0; -1 -2 -1];
end


function mask = gaussian_init()
mask = [1 4 7 4 1; 4 16 26 16 4; 7 26 41 26 7; 4 16 26 16 4; 1 4 7 4 1]/273;
end


function mask = haar_init(type,row_scale,column_scale)

switch type
    case 'type_1'
        mask = ones(row_scale, column_scale*2);
        mask(:,column_scale+1:column_scale*2) = mask(:,column_scale+1:column_scale*2)*(-1);
    
    case 'type_2'
        mask = ones(row_scale*2, column_scale);
        mask(row_scale+1:row_scale*2,:) = mask(row_scale+1:row_scale*2,:)*(-1);

    case 'type_3'
        mask = ones(row_scale, column_scale*3);
        mask(:,column_scale+1:column_scale*2) = mask(:,column_scale+1:column_scale*2)*(-1);
        
    case 'type_4'
        mask = ones(row_scale*3, column_scale);
        mask(row_scale+1:row_scale*2,:) = mask(row_scale+1:row_scale*2,:)*(-1);
        
    case 'type_5'
        mask = ones(row_scale*2, column_scale*2);
        mask(1:row_scale,1:column_scale) = mask(1:row_scale,1:column_scale)*(-1);
        mask(row_scale+1:row_scale*2,column_scale+1:column_scale*2) = mask(row_scale+1:row_scale*2,column_scale+1:column_scale*2)*(-1);

end
    
end


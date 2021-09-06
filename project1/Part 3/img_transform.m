function img_out  = img_transform(img_in, H)
% img_in is input rgb image
% img_out is output rgb image
% H is homography matrix of size 3*3

x_size = size(img_in,2);
y_size = size(img_in,1);

% 4 corner points
tl = [1;1;1];
tr = [x_size;1;1];
bl = [1;y_size;1];
br = [x_size;y_size;1];

region = cat(2,tl,tr,bl,br);

new_region = H*region;

% 4 corner points location after homography transform
new_region_cartesian = new_region(1:2, :)./new_region(3,:);

% to determine the output image size
x_max = ceil(max(new_region_cartesian(1,:)));
x_min = floor(min(new_region_cartesian(1,:)));
y_max = ceil(max(new_region_cartesian(2,:)));
y_min = floor(min(new_region_cartesian(2,:)));

new_x_size = x_max - x_min;
new_y_size = y_max - y_min;

img_out = zeros(new_y_size, new_x_size, 3, 'uint8');


% initiate a coordinate map
[x,y] = meshgrid(linspace(1, new_x_size, new_x_size), linspace(1, new_y_size, new_y_size));

% reshape to homography coordinate format
map = [reshape(x,[],1), reshape(y,[],1), ones(new_x_size*new_y_size,1)];

% change output image coordinate to input image coordinate for subsequent
% matrix operation
map = map + [x_min y_min 0];

% inverse transform to get corresponding location on input image for every
% output image pixel
pre_loc = H\transpose(map);
pre_loc_cartesian = pre_loc(1:2,:)./pre_loc(3,:);

for k = 1:3
    intensity = interp2(double(img_in(:,:,k)),pre_loc_cartesian(1,:),pre_loc_cartesian(2,:));
    img_out(:,:,k) = uint8(reshape(intensity, [new_y_size, new_x_size]));
    
end


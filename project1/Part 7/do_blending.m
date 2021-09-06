function img_blending = do_blending(canvas1, canvas2, canvas1_loc, canvas2_loc)
    
y_size = size(canvas1,1);
x_size = size(canvas1,2);

% to resize the image to 16m*16n size for 5 layer gaussian pyramid operation
canvas1_resized = imresize(canvas1, [y_size + 16 - mod(y_size,16), x_size + 16 - mod(x_size,16)]);
canvas2_resized = imresize(canvas2, [y_size + 16 - mod(y_size,16), x_size + 16 - mod(x_size,16)]);

img_blending = zeros(size(canvas1_resized));

% to get the blending center line x coordinate on different pyramid scales
x_sorted = sort([canvas1_loc(3) canvas1_loc(4) canvas2_loc(3) canvas2_loc(4)]);

mid_line0 = round((x_sorted(2)+x_sorted(3))/2);
mid_line1 = round(mid_line0/2);
mid_line2 = round(mid_line1/2);
mid_line3 = round(mid_line2/2);
mid_line4 = round(mid_line3/2);


% to check if image 1 (on canvas1) is on the left of image 2 (on canvas 2)
if (canvas1_loc(3)+canvas1_loc(4))/2 < (canvas2_loc(3)+canvas2_loc(4))/2
    seq = true;
else
    seq = false;
end


for channel = 1:3
    
    kernel = fspecial('gaussian',[5,5],1);
    
    % gaussian pyramid for image 1
    G_A0 = canvas1_resized(:,:,channel);
    G_A1 = conv2(G_A0,kernel, 'same');
    G_A1 = G_A1(2:2:size(G_A1,1), 2:2:size(G_A1,2));
    G_A2 = conv2(G_A1,kernel, 'same');
    G_A2 = G_A2(2:2:size(G_A2,1), 2:2:size(G_A2,2));
    G_A3 = conv2(G_A2,kernel, 'same');
    G_A3 = G_A3(2:2:size(G_A3,1), 2:2:size(G_A3,2));
    G_A4 = conv2(G_A3,kernel, 'same');
    G_A4 = G_A4(2:2:size(G_A4,1), 2:2:size(G_A4,2));
    
    % gaussian pyramid for image 2
    G_B0 = canvas2_resized(:,:,channel);
    G_B1 = conv2(G_B0,kernel, 'same');
    G_B1 = G_B1(2:2:size(G_B1,1), 2:2:size(G_B1,2));
    G_B2 = conv2(G_B1,kernel, 'same');
    G_B2 = G_B2(2:2:size(G_B2,1), 2:2:size(G_B2,2));
    G_B3 = conv2(G_B2,kernel, 'same');
    G_B3 = G_B3(2:2:size(G_B3,1), 2:2:size(G_B3,2));
    G_B4 = conv2(G_B3,kernel, 'same');
    G_B4 = G_B4(2:2:size(G_B4,1), 2:2:size(G_B4,2));
    
    % laplacian pyramid for image 1
    L_A0 = double(G_A0)-imresize(G_A1,size(G_A0));
    L_A1 = double(G_A1)-imresize(G_A2,size(G_A1));
    L_A2 = double(G_A2)-imresize(G_A3,size(G_A2));
    L_A3 = double(G_A3)-imresize(G_A4,size(G_A3));
    L_A4 = double(G_A4);
    
    % laplacian pyramid for image 2
    L_B0 = double(G_B0)-imresize(G_B1,size(G_B0));
    L_B1 = double(G_B1)-imresize(G_B2,size(G_B1));
    L_B2 = double(G_B2)-imresize(G_B3,size(G_B2));
    L_B3 = double(G_B3)-imresize(G_B4,size(G_B3));
    L_B4 = double(G_B4);
    
    
    % create blending weight mask for different scales
    size0 = size(L_A0);
    %band_l = round(size0(2)/400);  % half band length (fixed for all scales)
    band_l = 10;
    mask0 = zeros(size0);
    mask0(:,1:mid_line0) = 1;
    mask0(:, mid_line0-band_l:mid_line0+band_l) = repmat(linspace(1,0,band_l*2+1),size0(1),1);
    
    size1 = size(L_A1);
    mask1 = zeros(size1);
    mask1(:,1:mid_line1) = 1;
    mask1(:, mid_line1-band_l:mid_line1+band_l) = repmat(linspace(1,0,band_l*2+1),size1(1),1);    
    
    size2 = size(L_A2);
    mask2 = zeros(size2);
    mask2(:,1:mid_line2) = 1;
    mask2(:, mid_line2-band_l:mid_line2+band_l) = repmat(linspace(1,0,band_l*2+1),size2(1),1); 
    
    size3 = size(L_A3);
    mask3 = zeros(size3);
    mask3(:,1:mid_line3) = 1;
    mask3(:, mid_line3-band_l:mid_line3+band_l) = repmat(linspace(1,0,band_l*2+1),size3(1),1);
    
    size4 = size(L_A4);
    mask4 = zeros(size4);
    mask4(:,1:mid_line4) = 1;
    mask4(:, mid_line4-band_l:mid_line4+band_l) = repmat(linspace(1,0,band_l*2+1),size4(1),1);
    
    % linear combination 
    if seq == true
        L_C0 = L_A0 .* mask0 + L_B0 .* (1-mask0);
        L_C1 = L_A1 .* mask1 + L_B1 .* (1-mask1);
        L_C2 = L_A2 .* mask2 + L_B2 .* (1-mask2);
        L_C3 = L_A3 .* mask3 + L_B3 .* (1-mask3);
        L_C4 = L_A4 .* mask4 + L_B4 .* (1-mask4);
        
    else
        L_C0 = L_B0 .* mask0 + L_A0 .* (1-mask0);
        L_C1 = L_B1 .* mask1 + L_A1 .* (1-mask1);
        L_C2 = L_B2 .* mask2 + L_A2 .* (1-mask2);
        L_C3 = L_B3 .* mask3 + L_A3 .* (1-mask3);
        L_C4 = L_B4 .* mask4 + L_A4 .* (1-mask4);
    end
    
    % blending output for single channel
    img_blending(:,:,channel) = L_C0+imresize(L_C1,size0)+imresize(L_C2,size0)+imresize(L_C3,size0)+imresize(L_C4,size0);

    
end
 

img_blending = uint8(img_blending);

end
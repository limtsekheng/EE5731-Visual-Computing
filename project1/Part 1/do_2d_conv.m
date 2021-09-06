function conv_result = do_2d_conv(image, kernel, kernel_name)

size_image_x = size(image,2);
size_image_y = size(image,1);

% flip horizontally and vertically is equivalent to 180 degree rotation
kernel = flip(kernel,1);
kernel = flip(kernel,2);

if strcmp(kernel_name, 'sobel') || strcmp(kernel_name, 'gaussian')
    % square kernel size
    size_kernel = size(kernel,1);

    % offset to prevent out of boundary
    offset = floor(size_kernel/2);

    temp_result = zeros(size_image_y, size_image_x, 'double');
    
    for i = (1 + offset) : (size_image_y - offset)
        for j = (1 + offset) : (size_image_x - offset)
            temp = image(i - offset : i + offset, j - offset : j + offset);
            temp_result(i,j) = sum(sum(temp .* kernel));
        end
    end
    
    conv_result = temp_result(1 + offset : size_image_y - offset, 1 + offset : size_image_x - offset);

else
    size_kernel_x = size(kernel,2);
    size_kernel_y = size(kernel,1);
    
    temp_result = zeros(size_image_y, size_image_x, 'double');
    
    for i = size_kernel_y : size_image_y
        for j = size_kernel_x : size_image_x
            temp = image((i - size_kernel_y + 1) : i, (j - size_kernel_x + 1) : j);
            temp_result(i,j) = sum(sum(temp .* kernel));
        end
    end
    
    conv_result = temp_result(size_kernel_y : size_image_y, size_kernel_x : size_image_x);
    
end

end

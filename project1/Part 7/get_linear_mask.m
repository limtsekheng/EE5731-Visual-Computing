function linear_mask = get_linear_mask(canvas_loc)

    [X1,Y1] = meshgrid(linspace(0,1,floor((canvas_loc(4)-canvas1_loc(3)+1)/2)), linspace(0,1,floor((canvas_loc(2)-canvas1_loc(1)+1)/2)));
    [X2,Y2] = meshgrid(linspace(1,0,ceil((canvas_loc(4)-canvas1_loc(3)+1)/2)), linspace(0,1,floor((canvas_loc(2)-canvas1_loc(1)+1)/2)));
    [X3,Y3] = meshgrid(linspace(0,1,floor((canvas_loc(4)-canvas1_loc(3)+1)/2)), linspace(1,0,ceil((canvas_loc(2)-canvas1_loc(1)+1)/2)));
    [X4,Y4] = meshgrid(linspace(1,0,ceil((canvas_loc(4)-canvas1_loc(3)+1)/2)), linspace(1,0,ceil((canvas_loc(2)-canvas1_loc(1)+1)/2)));
    
    X = cat(1, cat(2, X1, X2), cat(2, X3, X4));
    Y = cat(1, cat(2, Y1, Y2), cat(2, Y3, Y4));
    
    linear_mask = X.*Y;

end
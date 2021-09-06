function match_list = matching(f1,d1,f2,d2,cutoff_ratio)
% return match_list (6*N matrix): first three rows are img1 key point
% homography coordinates, followed by img2 key point homography coordinates.


match_list = [];

for i = 1:size(d1,2)
   
    diff = double(d2-d1(:,i));
    distance = zeros(1,size(diff,2));
    
    for j = 1:size(diff,2)
        distance(j) = norm(diff(:,j));
    end
    
    [~,index] = min(distance);
    
    sort_distance = sort(distance);
    
    if sort_distance(1)/sort_distance(2) < cutoff_ratio
        match_list = cat(2,match_list,[f1(1:2,i); 1; f2(1:2,index); 1]);
    end
    
end
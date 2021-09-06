function [best_H, inliner_list] = ransac(match_list1, match_list2, iteration, threshold)

inliner_list = [];

for i = 1:iteration
    select = randperm(size(match_list1, 2));
    index = select(1:10);  % random select 10 sets of points for homography matrix computation
    data1 = match_list1(:,index);
    data2 = match_list2(:,index);
    
    H = get_H_matrix(data1, data2);
    
    data2_cal = H*match_list1(:,:);
    data2_cal = data2_cal(:,:)./data2_cal(3,:);
    
    diff = data2_cal(:,:) - match_list2(:,:);
    
    distance = zeros(1,size(diff,2));
    
    temp_inliner_list = [];
    
    for j = 1:size(diff,2)
        distance(j) = norm(diff(:,j));

        if distance(j) <threshold
            temp = cat(1, match_list1(:,j), match_list2(:,j));
            temp_inliner_list = cat(2, temp_inliner_list, temp);
        end
    end
    
    if size(temp_inliner_list,2) > size(inliner_list,2)
        inliner_list = temp_inliner_list;
    end
end  


best_data1 = inliner_list(1:3,:);
best_data2 = inliner_list(4:6,:);

best_H = get_H_matrix(best_data1, best_data2); 

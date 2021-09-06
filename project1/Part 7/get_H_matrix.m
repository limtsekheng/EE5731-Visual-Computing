function H = get_H_matrix(data1, data2)


A = zeros(size(data1,2)*2,9);

for i = 1:size(data1,2)
    
    x1 = data1(1,i);
    y1 = data1(2,i);
    x2 = data2(1,i);
    y2 = data2(2,i);
    
    A(2*i-1,:) = [x1 y1 1 0 0 0 -x1*x2 -x2*y1 -x2];
    A(2*i,:) = [0 0 0 x1 y1 1 -y2*x1 -y1*y2 -y2];
  
end

[~,~,V] = svd(A);

H = reshape(V(:,end),[3,3]);
H = transpose(H);


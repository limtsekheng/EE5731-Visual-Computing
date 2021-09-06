clc;
clear;
close all;

addpath('../GCMex');

lambda = 80;

img = imread('../assg2/bayes_in.jpg');
[h, w, ~] = size(img);

source_color = [0, 0, 255];  % blue foreground label 0
sink_color = [245, 210, 110]; % yellow background label 1

img_t = double(reshape(img,[],3));

C = 2;
N = h*w;

cls = zeros(1,N);


unary = zeros(C,N);

for i = 1:N
    unary(1,i) = dist(source_color, img_t(i,:));
    unary(2,i) = dist(sink_color, img_t(i,:));
    if unary(1,i) > unary(2,i)
        cls(1,i) = 1;     
    end
end


% pairwise = sparse(N,N);
% 
% for i = 1:N-1
%     if mod(i,h) == 0
%         pairwise(i,i+h) = 1;
%     elseif i > N-h
%         pairwise(i,i+1) = 1;
%     else
%         pairwise(i,i+1) = 1;
%         pairwise(i,i+h) = 1;
%     end
% end
% 
% pairwise = pairwise + pairwise';


below_nbr = diag(sparse(repmat([ones(1,h-1),0],1,w)),1);
below_nbr = below_nbr(1:end-1,1:end-1);

right_nbr = diag(sparse(ones(1,N-h)),h);

pairwise = below_nbr + right_nbr;
pairwise = pairwise + pairwise';



labelcost = [0 1; 1 0]*lambda;

[labels, ~, ~] = GCMex(double(cls), single(unary), pairwise, single(labelcost));


denoised = zeros(N,3);
for i = 1:N
    if labels(i) == 0
        denoised(i,:) = source_color;
    else
        denoised(i,:) = sink_color;
    end
end
denoised = uint8(reshape(denoised,[h,w,3]));


imshow(denoised);



function result = dist(A, B)
   result = sum(abs(A-B))/3;
end
        
        
        

        
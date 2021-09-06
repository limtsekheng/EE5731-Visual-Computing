clc;
clear;
close all;

addpath('../GCMex');

%%
lambda = 0.015;  % good at 0.015
eta = 10; % good at 10
C = 50; % good at 50
%%

img1 = imread('../assg2/im2.png');
img2 = imread('../assg2/im6.png');

[h,w,~] = size(img1);

img1 = double(img1)/255;
img2 = double(img2)/255;

img1 = reshape(img1,[],3);
img2 = reshape(img2,[],3);


N = h*w;

tic

cls = zeros(1,N);


unary = ones(C,N);

for  d = 1:C
    
    unary(d,(h*d+1):end) = dist(img1((h*d+1):end,:) - img2(1:(end-h*d),:));
end



below_nbr = diag(sparse(repmat([ones(1,h-1),0],1,w)),1);
below_nbr = below_nbr(1:end-1,1:end-1);

right_nbr = diag(sparse(ones(1,N-h)),h);

pairwise = below_nbr + right_nbr;
pairwise = pairwise + pairwise';

 

labelcost = min((meshgrid(1:C) - meshgrid(1:C)').^2,eta); 
labelcost = labelcost * lambda;


[labels, ~, ~] = GCMex(double(cls), single(unary), pairwise, single(labelcost),1);

dmap = reshape(labels, h, w);


dmap = dmap ./ max(dmap(:));

imshow(dmap);

toc

function result = dist(A)


%result = (sum(A.^2,2))';
result = (sum(abs(A),2))';

end



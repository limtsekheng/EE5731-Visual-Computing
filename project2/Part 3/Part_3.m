clc;
clear;
close all;

addpath('../GCMex');

%%
lambda = 0.02; %0.02
C = 50;
dmin = 0;
dmax = 0.0085; %0.01
D = linspace(dmin,dmax,C);
eta = 25;
%%


img1 = imread('../assg2/test00.jpg');
img2 = imread('../assg2/test09.jpg');

img1 = double(img1)/255;
img2 = double(img2)/255;

file = fopen('../assg2/cameras.txt','r');
K1 = fscanf(file,'%f',[3,3])';
R1 = fscanf(file,'%f',[3,3])';
T1 = fscanf(file,'%f',[1,3]);

K2 = fscanf(file,'%f',[3,3])';
R2 = fscanf(file,'%f',[3,3])';
T2 = fscanf(file,'%f',[1,3]);


[h,w,~] = size(img1);

N = h*w;


tic

cls = zeros(1,N);



unary = ones(C,N);

[X,Y] = meshgrid(1:w,1:h);

coord_1 = [X(:),Y(:),ones(N,1)]';  % 3*N, pixel travel vertically

img1_t = reshape(img1,[],3);  % N*3 
img2_t = reshape(img2,[],3);  % N*3

k = 0;
for  d = D
    
    coord_2 = K2 * R2' * R1 / K1 * coord_1 + d * K2 * R2' * (T1 - T2)';
    coord_2 = coord_2(1:3,:) ./ coord_2(3,:);
    coord_2 = round(coord_2);  % 3*N
    
    valid_location = all(coord_2(1,:) <= w & coord_2(2,:) <= h & coord_2(1:2,:) > 0); 
    
    k = k+1;
    
    lin_idx = sub2ind([h, w], coord_2(2,valid_location), coord_2(1,valid_location));
    unary(k, valid_location) = dist(img1_t(valid_location,:) - img2_t(lin_idx,:));
    
end


toc

tic

below_nbr = diag(sparse(repmat([ones(1,h-1),0],1,w)),1);
below_nbr = below_nbr(1:end-1,1:end-1);

right_nbr = diag(sparse(ones(1,N-h)),h);

pairwise = below_nbr + right_nbr;
pairwise = pairwise + pairwise';



labelcost = min((meshgrid(1:C) - meshgrid(1:C)').^2,eta);
labelcost = labelcost * lambda;

toc

tic

[labels, ~, ~] = GCMex(double(cls), single(unary), pairwise, single(labelcost),1);

dmap = reshape(labels, h, w);

dmap = dmap ./ max(dmap(:));

imshow(dmap);

toc


function result = dist(A)

%result = (sum(A.^2,2))';
result = (sum(abs(A),2))';

end
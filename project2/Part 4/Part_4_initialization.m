clc;
clear;
close all;

addpath('../GCMex');

file = fopen('../assg2/Road/cameras.txt','r');
total_frame_num = fscanf(file,'%f',1);

%%
frame_num = 5;
start_frame = 0;  % start from 0
%%

K = zeros(3,3,total_frame_num);
R = zeros(3,3,total_frame_num);
T = zeros(3,1,total_frame_num);

for i = 1:total_frame_num   
K(:,:,i) = fscanf(file,'%f',[3,3])';
R(:,:,i) = fscanf(file,'%f',[3,3])';
T(:,:,i) = fscanf(file,'%f',[1,3])';
end

K(:,:,1:frame_num) = K(:,:,start_frame + 1 : start_frame + frame_num);
R(:,:,1:frame_num) = R(:,:,start_frame + 1 : start_frame + frame_num);
T(:,:,1:frame_num) = T(:,:,start_frame + 1 : start_frame + frame_num);

folder = '../assg2/Road/src/';
for i = 1:frame_num
    if i+start_frame-1<10
        path = strcat(folder,'test000',num2str(i+start_frame-1),'.jpg');
    else
        path = strcat(folder,'test00',num2str(i+start_frame-1),'.jpg');
    end
    img{i} = double(imread(path))/255;
end

[h,w,~] = size(img{1});
N = h*w;

%%
lambda = 0.016;  % 0.016
C = 50;
dmin = 0;
dmax = 0.01;
D = linspace(dmin,dmax,C);
eta = 25;
sigma_c = 1;  % 1
%%

cls = zeros(1,N);


below_nbr = diag(sparse(repmat([ones(1,h-1),0],1,w)),1);
below_nbr = below_nbr(1:end-1,1:end-1);

right_nbr = diag(sparse(ones(1,N-h)),h);

pairwise = below_nbr + right_nbr;
pairwise = pairwise + pairwise';


labelcost = min(abs(meshgrid(1:C) - meshgrid(1:C)'),eta);  %L1 distance
labelcost = labelcost * lambda;





tic

unary_all = ones(C,N,frame_num);

[X,Y] = meshgrid(1:w,1:h);
coord_main = [X(:),Y(:),ones(N,1)]';  % 3*N, pixel travel vertically

for i = 1:frame_num
    
    img_main = img{i};
    img_main = reshape(img_main,[],3);
    K_main = K(:,:,i);
    R_main = R(:,:,i);
    T_main = T(:,:,i);
    
    f_d = zeros(C,N);
    
    for j = 1:frame_num
        
        if j == i
            continue;
        end
        
        img_other = img{j};
        img_other = reshape(img_other,[],3);
        K_other = K(:,:,j);
        R_other = R(:,:,j);
        T_other = T(:,:,j);
        
        k = 0;
        p_c = ones(C,N);
        
        for d = D
            
            coord_other = K_other * R_other' * R_main / K_main * coord_main + d * K_other * R_other' * (T_main - T_other);
            coord_other = coord_other(1:3,:) ./ coord_other(3,:);
            coord_other = round(coord_other);  % 3*N
            valid_location = all(coord_other(1,:) <= w & coord_other(2,:) <= h & coord_other(1:2,:) > 0); 
            k = k+1;
            lin_idx = sub2ind([h, w], coord_other(2,valid_location), coord_other(1,valid_location));
            p_c(k,valid_location) = dist(img_main(valid_location,:) - img_other(lin_idx,:));
            
        end
        
        p_c = sigma_c./(sigma_c + p_c);
        f_d = f_d + p_c;
        
    end
    
     
    unary_all(:,:,i) = 1 - f_d./max(f_d,[],1);
end

toc



dmap = zeros(h,w,frame_num);

for frame = 1:frame_num
    
    tic
    
    unary = unary_all(:,:,frame);
    [labels, ~, ~] = GCMex(double(cls), single(unary), pairwise, single(labelcost),1);
    
    labels = reshape(labels, h, w);
    
    dmap(:,:,frame) = (dmax - dmin) / (C-1) * labels;
    
    labels = labels ./ max(labels(:));
    
    figure;
    imshow(labels,'border','tight','initialmagnification','fit');
     
    toc
    
end

save('Dinit.mat','dmap');


function result = dist(A)

result = (sqrt(sum(A.^2,2)))';

end
clc;
clear;
close all;
run('../vlfeat-0.9.21/toolbox/vl_setup.m');

path = '../assg1/im01.jpg';
I = imread(path);
imshow(I);
hold on;
I = single(rgb2gray(I));



[f,d] = vl_sift(I);

perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;
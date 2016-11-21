%   Matlad code implementing "Level Set Evolution WithoutRe-initialization: A New Variational Formulation"

clear;
close all;
clc;

% Img=imread('three.bmp');     % example works well
Img=imread('twoCells.bmp');  % example works well
% Img=imread('vessel.bmp');    % example does NOT work well
U=Img(:,:,1);
I=double(U);

% get the size
[nrow,ncol] =size(U);

%initialize LSF as binary step function
c0=3;
initialLSF=c0*ones(size(U));
initialLSF(5:nrow-5, 5:ncol-5)=-c0;  
phi_0=initialLSF;

figure; mesh(phi_0); title('Signed Distance Function')

delta_t = 5; %time step
mu = 0.2/delta_t; %distRictTerm coefficient
nu = 1.5; % areaTerm coefficient
lambda=5; % legthTerm coefficient

epsilon=1.5; %used in Dirac function 
sigma=1.5; %gaussian lowpass filter standard deviation
g=edge_detector(I,sigma);%公式中的g, 边缘检测子
[gx,gy]=gradient(g);%g的梯度会在每次循环中用到

% iteration should begin from here
phi=phi_0;
figure(2);
imagesc(uint8(I));colormap(gray)
hold on;
plotLevelSet(phi,0,'r');

numIter = 1;
for k=1:240,
    phi = new_revolution(I, phi,g,gx, gy, mu, nu, lambda, delta_t, epsilon, numIter);   % update level set function
    if mod(k,4)==0
        pause(0.05);
%        figure(1);mesh(phi);
        figure(2);
        imagesc(uint8(I));colormap(gray)
        hold on;
        plotLevelSet(phi,0,'r');
    end    
end;


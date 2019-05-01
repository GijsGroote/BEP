clear;
clc;

% todo: create a understandible function of this file, or delete entire
% file

I = imread('vakantie-delft.jpg');
[r,c,d] = size(I);
p = 0.80; % hoeveel procent van de pixels je wil verwijderen
B = randperm(r*c,round(r*c*p)); %random picks van alle beschikbare pixels
A = reshape(I,[r*c,1,3]); % Kolom vector maken van I (3 dimensies)

% Zet de "uitgekozen" pixels op NaN
for n = 1 : length(B)
        A(B(n),1,:) = NaN;
end

C = reshape(A,[r,c,3]); % Maak van de kolom vector A weer in de orginele vorm van de Image

imshow(C)
imwrite(C,'que.png');

    
%Program to identify number plate
clc;
close all;
clear all;

%image considered can be changed here
im = imread('Number Plate Images/image1.png');

figure('Name','Original Image');
imshow(im);

im = medfilt3(im);
imgray = rgb2gray(im);

figure('Name','Greyscale Image');
imshow(imgray);

figure('Name','Filtered Image');
imshow(im);

imbin = imbinarize(imgray);

figure('Name','Binarized Image');
imshow(imbin)

im = edge(imgray, 'prewitt');

figure('Name','Edge Enhanced Image');
imshow(im)

%Below mentioned steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

%crop the number plate area
im = imcrop(imbin, boundingBox);

%remove some object if it width is too long or too small than 500
im = bwareaopen(~im, 500); 

%get width of the image
[h, w] = size(im);
figure('Name','Localised Image')
imshow(im);

%read letter
Iprops=regionprops(im,'BoundingBox','Area', 'Image'); 
count = numel(Iprops);

%to construct Bounding Boxes
figure('Name','Bounding Boxes Image')
imshow(im)
hold on
for k = 1:count
    CurrBB = Iprops(k).BoundingBox;
    rectangle('Position',[CurrBB(1),CurrBB(2),CurrBB(3),CurrBB(4)],'EdgeColor','g','LineWidth',2)
end

% Initializing the variable of number plate string.
noPlate=[]; 

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) && oh>(h/3)
       % Reading the letter corresponding the binary image 'N'.
       letter=Letter_detection(Iprops(i).Image); 
       % Appending every subsequent character in noPlate variable.
       noPlate=[noPlate letter]; 
   end
   figure(i+7)
   imshow(Iprops(i).Image)
end

%displaying the result
disp('The Vehicle Number Plate is : ')
disp(noPlate);
%% Mengmi Zhang %%
%% Date: June 6th, 2016%%
%% Topic: Future saliency map evaluation%%
clear all; close all; clc;

NumFrames = 32; %predict next 32 future frames
imgsizew = 128;
BatchSize= 32;
FrameSize = 32;
TotalImg = 32; %total number of images

resultdir = '../results/gtea_gaze_m16/';
savedir = 'gtea_gaze_m16'; %prefix of saved mat files

yellow = uint8([255 255 0]);
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',yellow, 'FillColor','White');
aaemat = nan(TotalImg,NumFrames);
aucmat = nan(TotalImg,NumFrames);

for i =1 : TotalImg   
   
    display(['processing future frames starting from: ' num2str(i)]);
    for j = 1:NumFrames
        display(['processing: ' num2str(j)]);
               
        test = load([resultdir savedir '_' num2str(i) '_' num2str(j) '.mat']);
        test = squeeze(test.x);
               
        %read in camera frame
        %upngstr = sprintf('%03d', input.video);
        %downpngstr = sprintf('%010d', input.frame);
        %img = imread(['../GTEA_Gaze_Dataset/GTEA_Gaze_Dataset/png/' upngstr '/' downpngstr '.png']);        
        
        %extract predicted fixation location
        [num idx] = max(test(:));
        [x y] = ind2sub(size(test),idx); 
        fixx = x(1); %vertical
        fixy = y(1); %horinzontal
              
        
        %smooth predicted saliency map and display
        test = mat2gray(test);
        G = fspecial('gaussian',[50 50],5);            
        test = imfilter(test,G,'same');
        test = mat2gray(test);
        test = imresize(test,[480 640]);
        imshow(test);
        pause; %press SPACE to continue to the next one

%         %comment out to overlay predicted saliency map on camera frame (img)
%         imshow(heatmap_overlay(img, test));
%         drawnow;
%         pause(1);
        
        %% evaluation starts here: add your own metrics here %%
        % Example metrics are given below
        % Ibinary is the ground truth fixation map; (x1, y1) and (x2, y2)
        % are the groud truth fixation coordinates
        %% compute AUC
        %iauc = calcAUCscore(test, Ibinary);
        %aucmat(i,j) = mean(iauc); %store in aucmat

        %% compute AAE
        %convert all coordinates to the same coordinate systems
        %fixgt = [y1 y2; x1 x2]; %fixation coordinate with respect to frame size 
        %fixgt = mean(fixgt,2);
        %fixgt(1,1) = fixgt(1,1) -240;%fixgt(1,1) = fixgt(1,1)/38*480 -240;
        %fixgt(2,1) = fixgt(2,1)-320;%fixgt(2,1) = fixgt(2,1)/50*640-320;        
        %x = zeros(2,1);
        %x(2,:) = fixy/64*640 - 320; %x  x(2,:) = x(2,:)/56*640 - 320; %x
        %x(1,:) = fixx/64*480 - 240; %y  x(1,:) = x(1,:)/56*480 - 240;
        
        %compute average angular error in degrees
        %d = 320/tan(pi/6); % [1280 960 60 deg 46 deg]   d = 320/tan(pi/6);
        %A = [x(2,:)  x(1,:) d];
        %C = [fixgt(2,1) fixgt(1,1) d];
        %B = [0 0 0];
        %angle = atan2(norm(cross(A-B,C-B)),dot(A-B,C-B));
        %angle = radtodeg(angle);        
        %aaemat(i,j) = angle; %store in aaemat
        
        
    end
    
    
end

    

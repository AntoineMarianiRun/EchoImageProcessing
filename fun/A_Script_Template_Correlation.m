video =  uiGetVideo(); 
selected_frame = video.frame{1};

% selected_frame = imread('C:\Users\Stage\Desktop\csm_ATELIERS_LE_TAMPON-30_6ee3587386.jpg');
%% 
heigthBox = 57;
widthBox = 27;
[X,Y,templateImage] = setImageTemplate(selected_frame,heigthBox,widthBox);
% [X3,Y3,patternImage3] = setImagePattern(selected_frame,200);

figure('Name','Pattern','Color',[1 1 1])
image(templateImage)
%%
frames = video.frame;
tempate = templateImage;
row = Y;
col = X;
nPixCol = 30;
nPixRow = 20;
rateOfChange = 10;

tic
[row,col,minValue] = tracking(frames,tempate,row,col,nPixRow,nPixCol,rateOfChange);
toc
%%

heigthBox = 501;
widthBox = 501;

Image_ = corpImageAsRectangle(selected_frame,X,Y,heigthBox,widthBox);


% figure('Name','Image','Color',[1 1 1])
% image(selected_frame)


figure('Name','Pattern','Color',[1 1 1])
image(patternImage)

figure('Name','Image','Color',[1 1 1])
image(Image_)


%% compare image with same size 
% [X2,Y2,patternImage2] = setImagePattern(selected_frame,51);
% [absError] =  comparaisonImage(patternImage2,patternImage);


%% pattern fitting 
method = "Crop";
[errMatrix] = compareImage2Pattern(Image_,patternImage,method);
% [errMatrix] = compareImage2Pattern(selected_frame,patternImage,method);
[rowOffset,colOffset,minValue] = minError(errMatrix);

%% illustration 
plotErrorMartixAndImage(errMatrix,Image_)
% plotErrorMartixAndImage(errMatrix,patternImage3)

% plotHeatMapErrorMatrix(errMatrix)
% 
% plot3DErrorMatrix(errMatrix)


% plotErrorMartixAndImage(errMatrix,selected_frame)

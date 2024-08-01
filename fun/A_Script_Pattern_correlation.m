video =  uiGetVideo(); 

selected_frame = video.frame{1};

[X,Y,patternImage] = setImagePattern(selected_frame,57);
[X3,Y3,patternImage3] = setImagePattern(selected_frame,200);

figure
image(patternImage)


%% compare image with same size 
% [X2,Y2,patternImage2] = setImagePattern(selected_frame,51);
% [absError] =  comparaisonImage(patternImage2,patternImage);


%% pattern fitting 
method = "Crop";
[errMatrix] = compareImage2Pattern(patternImage3,patternImage,method);


%% illustration 
plotErrorMartixAndImage(errMatrix,patternImage3)




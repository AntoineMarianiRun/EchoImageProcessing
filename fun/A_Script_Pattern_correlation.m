video =  uiGetVideo(); 

selected_frame = video.frame{1};

[X,Y,patternImage] = setImagePattern(selected_frame,51);
[X2,Y2,patternImage2] = setImagePattern(selected_frame,51);
[X3,Y3,patternImage3] = setImagePattern(selected_frame,400);


[absError] =  comparaisonImage(patternImage2,patternImage);

[errMatrix] = compareImage2Pattern(selected_frame,patternImage)

plotErrorMatrx(errMatrix)

imshow(patternImage)


% Script test
video =  uiGetVideo(); 

% Shape = setSquareShape(video.frame{1}); 

Shape = setCustumShape(video.frame{1}); 


results = colorCalculation(video.frame,...
    video.time.SWindex,...
    video.colorScale.colorScaleRGBdouble,...
    video.colorScale.colorScaleValue,...
    video.coef,...
    Shape,...
    video.time.Bmode);

figureShearTemporalEvolution(results)

figureFrameColorHistogram(video,1,1,results)

videoRead(video.frame,video.videoObject)
% Script test
videoPath = 'C:\Users\Stage\Desktop\GIT\EchoImageProcessing\exemple\A_Exemple_Bmode.avi'



[frames, video_object] = load_video(videoPath)
%%

selected_frame = frames{1} ;

[coef_x,coef_y] = scale_image(frames)

[X,Y] = set_square(selected_frame)

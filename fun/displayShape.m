function displayShape(selected_frame,Shape,brightness)
    % Create a 3D mask by replicating the inShape matrix across the third dimension
    mask = repmat(Shape, [1, 1, 3]);

    % Create a dimmed version of the original frame (brightness)
    shadedBackground = uint8(double(selected_frame) * brightness);
    
    % Blend the original image with the shaded background using the mask
    outputImage = selected_frame;
    outputImage(~mask) = shadedBackground(~mask);

    % plot
    fig = figure('Name', 'selected zone','Color', [1 1 1],'ToolBar','none','MenuBar','none'); % figure
    axes_im = axes('Parent', fig ,'Position',[0 0 1 1]) ;              % axis
    image(selected_frame,'Parent',axes_im);
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));
    image(outputImage)
end
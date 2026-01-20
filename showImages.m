% C is only shown if it is nonzero
function showImages(original, retransformed, C)
    figure
    
    subplot(1,2,1);
    imshow(original);
    title("Original image");
    subplot(1,2,2);
    imshow(retransformed);
    title("Retransformed image");
    
    if (C ~= 0)
        figure
        imshow(C)
    end
end
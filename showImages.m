% C is only shown if it is nonzero
function showImages(original, retransformed, C, s)
    figure
    
    subplot(1,2,1);
    imshow(original);
    title("Original image, ground truth");
    subplot(1,2,2);
    imshow(retransformed);
    title("Retransformed image, CS example");
    
    if (nnz(C) ~= 0)
        figure
        imshow(C);
        title("C Matrix");
    end
    if (nnz(s) ~= 0)
        figure
        subplot(1,2,1);
        histogram(s,-50:0.001:50);
        title("Histogram of s (only showing area -50:50)");
        subplot(1,2,2);
        plot(s);
        title("Values of s");
    end
end
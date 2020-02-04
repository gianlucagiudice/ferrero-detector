table_pixels = [];

A = imread("images/original/IMG_8652.JPG");
imageSegmenter(A);
[L,N] = superpixels(A,500);
figure(1);
BW = boundarymask(L);
imshow(imoverlay(A,BW,'cyan'))
outputImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
for labelVal = 1:N
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(A(redIdx));
    outputImage(greenIdx) = mean(A(greenIdx));
    outputImage(blueIdx) = mean(A(blueIdx));
end    

figure(2);
imshow(outputImage);
function errors = analyze_box_1(image, debug)
   [w, ~] = size(image);
   image = imresize(image, [500 500]);

   c2delta = 30;
   c6delta = 30;
   c3delta = 50;
   c5delta = 40;

   c1 = round(w/8);
   c2 = round(w/4);
   c3 = c1 + c2;
   c4 = round(w/2);
   c5 = round(w/2) + c1;
   c6 = round(w/2) + c2;
   c7 = round(w/2) + c3;

   centers = [c1 c3; c1 c1; c1 c5; c1 c7; c7 c1; c7 c3; c7 c5; c7 c7; c3 c1; c3 c7; c5 c1; c5 c7];
   centers = [centers; c2+c2delta c2+c2delta; c2+c2delta c4; c2+c2delta c6; c6-c6delta c2+c2delta];
   centers = [centers; c6-c6delta c4; c6-c6delta c6+c6delta; c4 c2+c2delta; c4 c6+c6delta];
   centers = [centers; c3+c3delta c3+c3delta; c5-c5delta c3+c3delta; c3+c3delta c5-c5delta; c5-c5delta c5-c5delta];


   image = rgb2hsv(image);
   A = image(:,:,2);

   [L,N] = superpixels(image,300, 'Compactness', 20);
   figure(1);
   BW = boundarymask(L);

   outputImage = zeros(size(A),'like',A);
   idx = label2idx(L);
   numRows = size(A,1);
   numCols = size(A,2);
   for labelVal = 1:N
      redIdx = idx{labelVal};
      outputImage(redIdx) = mean(A(redIdx));
   end    

   figure
   imshow(outputImage);

%{
 image = histeq(image);
   image = medfilt2(image, [30 30], 'symmetric');

   threshold = graythresh(image);
   bw = imcomplement(imbinarize(image, threshold));
   se = strel('disk', 40);
   bw = imclose(bw, se); 
%}

end
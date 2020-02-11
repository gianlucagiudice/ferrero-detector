function regions = cut_type2(image)
   [w, ~] = size(image);
   regions = cell(24);
   circle_radius = w / 8 * 1.1;

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

   %Outer
   boxes(1) = crop_centroid(image, [c1 c3], circle_radius);
   boxes(2) = crop_centroid(image, [c1 c1], circle_radius);
   boxes(3) = crop_centroid(image, [c1 c3], circle_radius);
   boxes(4) = crop_centroid(image, [c1 c5], circle_radius);
   boxes(5) = crop_centroid(image, [c1 c7], circle_radius);
   boxes(6) = crop_centroid(image, [c7 c1], circle_radius);
   boxes(7) = crop_centroid(image, [c7 c3], circle_radius);
   boxes(8) = crop_centroid(image, [c7 c5], circle_radius);
   boxes(9) = crop_centroid(image, [c7 c7], circle_radius);
   boxes(10) = crop_centroid(image, [c3 c1], circle_radius);
   boxes(11) = crop_centroid(image, [c3 c7], circle_radius);
   boxes(12) = crop_centroid(image, [c5 c1], circle_radius);
   boxes(13) = crop_centroid(image, [c5 c7], circle_radius);

   % Middle
   boxes(14) = crop_centroid(image, [c2+c2delta c2+c2delta], circle_radius);
   boxes(15) = crop_centroid(image, [c2+c2delta c4], circle_radius);
   boxes(16) = crop_centroid(image, [c2+c2delta c6], circle_radius);
   boxes(17) = crop_centroid(image, [c6-c6delta c2+c2delta], circle_radius);
   boxes(18) = crop_centroid(image, [c6-c6delta c4], circle_radius);
   boxes(19) = crop_centroid(image, [c6-c6delta c6+c6delta], circle_radius);
   boxes(20) = crop_centroid(image, [c4 c2+c2delta], circle_radius);
   boxes(21) = crop_centroid(image, [c4 c6+c6delta], circle_radius);

   % Center
   boxes(22) = crop_centroid(image, [c3+c3delta c3+c3delta], circle_radius);
   boxes(23) = crop_centroid(image, [c5-c5delta c3+c3delta], circle_radius);
   boxes(24) = crop_centroid(image, [c3+c3delta c5-c5delta], circle_radius);
   boxes(25) = crop_centroid(image, [c5-c5delta c5-c5delta], circle_radius); 

   imshow(image);
end
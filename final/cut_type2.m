function regions = cut_type2(image)
   [w, ~] = size(image);
   regions = cell(24, 1);
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

   centers = [c1 c3; c1 c1; c1 c5; c1 c7; c7 c1; c7 c3; c7 c5; c7 c7; c3 c1; c3 c7; c5 c1; c5 c7];
   centers = [centers; c2+c2delta c2+c2delta; c2+c2delta c4; c2+c2delta c6; c6-c6delta c2+c2delta];
   centers = [centers; c6-c6delta c4; c6-c6delta c6+c6delta; c4 c2+c2delta; c4 c6+c6delta];
   centers = [centers; c3+c3delta c3+c3delta; c5-c5delta c3+c3delta; c3+c3delta c5-c5delta; c5-c5delta c5-c5delta];

   for i = 1:length(centers)
      regions{i}.pixels = crop_centroid(image, centers(i, :), circle_radius);
      regions{i}.radius = circle_radius;
      regions{i}.center = centers(i, :);
   end
end
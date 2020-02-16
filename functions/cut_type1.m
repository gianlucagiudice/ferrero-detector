%% Cut type 1
% Cut the square box in a list of 24 regions
function regions = cut_type1(image, debug)
   [w, ~] = size(image);
   regions = cell(24, 1);
   circle_radius = w / 8 * 3/5;

   %% Top choccolates
   regions{1}.center = round([w/8, w/8]);
   regions{2}.center = round([w/2 - w/8, w/8]);
   regions{3}.center = round([w/2 + w/8, w/8]);
   regions{4}.center = round([w - w/8, w/8]);

   %% Rightmost
   regions{5}.center = round([w - w/8, w/2 - w/8]);
   regions{6}.center = round([w - w/8, w/2 + w/8]);
   regions{7}.center = round([w - w/8, w - w/8]);
   
   %% Bottom
   regions{8}.center = round([w/2 + w/8, w - w/8]);
   regions{9}.center = round([w/2 - w/8, w - w/8]);
   regions{10}.center = round([w/8, w - w/8]);
   
   %% Leftmost
   regions{11}.center = round([w/8, w/2 + w/8]);
   regions{12}.center = round([w/8, w/2 - w/8]);

   
   %% Inner square
   regions{13}.center = round([w/4, w/4]);
   regions{14}.center = round([w/2, w/4]);
   regions{15}.center = round([w - w/4, w/4]);

   regions{16}.center = round([w - w/4, w/2]);
   regions{17}.center = round([w - w/4, w/2 + w/4]);

   regions{18}.center = round([w/2, w - w/4]);
   regions{19}.center = round([w/4, w - w/4]);

   regions{20}.center = round([w/4, w/2]);
   
   %% Smallest square
   p = 0.8;
   regions{21}.center = round([w/2 - w/8 * p, w/2 - w/8 * p]);
   regions{22}.center = round([w/2 + w/8 * p, w/2 - w/8 * p]);
   regions{23}.center = round([w/2 + w/8 * p, w/2 + w/8 * p]);
   regions{24}.center = round([w/2 - w/8 * p, w/2 + w/8 * p]);


   for i = 1:length(regions)
      regions{i}.value = crop_centroid(image, regions{i}.center, circle_radius);
      regions{i}.radius = circle_radius;
   end
 

   if debug
      figure(7);
      subplot(1,1,1);
      imshow(image);
      hold on
      for i = 1:24
         center = regions{i}.center;
         x = center(1);
         y = center(2);
         plot(x, y, 'r+', 'LineWidth', 3, 'MarkerSize', 30);
      end
      hold off

      figure(70);
      for i = 1:24
         subplot(4,6,i);
         imshow(regions{i}.value);
      end

   end

end

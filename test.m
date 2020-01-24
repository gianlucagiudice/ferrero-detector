lbp_training = [];
glcm_training = [];
ghist_training = [];
hue_training = [];

window_size = 25;

disp('Training');
for i = 3:3
   image = imread(['rocher/frags/' num2str(i) '.jpg']);
   gray = rgb2gray(image);
   [rows, cols, ~] = size(image);
   disp("Training image " + num2str(i));

   for r = 1 : floor(rows / window_size)
      for c = 1 : floor(cols / window_size)
         viewport = image(1 + window_size * (r-1) : r*window_size, 1 + window_size * (c-1) : c*window_size);
         lbp_training = [lbp_training; compute_lbp(viewport)];
         glcm_training = [glcm_training; compute_glcm(viewport)];
         ghist_training = [ghist_training; compute_ghist(viewport)];
      end
   end

   disp("End training " + num2str(i));
end
disp("End training");

mean_lbp = mean(lbp_training);
mean_glcm = mean(glcm_training); 
mean_ghist = mean(ghist_training);

target = im2double(imread('images/12.jpg'));
[rows, cols, ~] = size(target);
out = zeros(rows, cols, 3);

for r = 1 : floor(rows / window_size)
   for c = 1:floor(cols / window_size)
      viewport = target(1 + window_size * (r-1) : r*window_size, 1 + window_size * (c-1) : c*window_size);

      lbp = compute_lbp(viewport);
      glcm = compute_glcm(viewport);
      ghist = compute_ghist(viewport);

      out(1 + window_size * (r-1) : r*window_size, 1 + window_size * (c-1) : c*window_size, 1) = pdist2(lbp, mean_lbp);
      out(1 + window_size * (r-1) : r*window_size, 1 + window_size * (c-1) : c*window_size, 2) = pdist2(ghist, mean_ghist);
      out(1 + window_size * (r-1) : r*window_size, 1 + window_size * (c-1) : c*window_size, 3) = pdist2(glcm, mean_glcm);
   end
end

figure(1);
imshow(imcomplement(out(:, :, 1))); title('LBP');
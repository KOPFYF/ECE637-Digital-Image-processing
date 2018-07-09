gray_level = 180;
x_gray = gray_level*ones(16,256);
unit = [255 255 0 0;
    255 255 0 0;
    0 0 255 255
    0 0 255 255];
x_check = repmat(unit,4,4*16);
x_unit = [x_check;x_gray];
x = repmat(x_unit,8,1);
figure(12);
image(x+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);
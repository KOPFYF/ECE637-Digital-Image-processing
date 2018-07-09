function [f_diff] = error_Diffusion(f)
	f_l = 255 * (double(f) / 255).^2.2;
	f_diff = padarray(f_l, [1 1]); % zero pad

    [m,n] = size(f_diff)
	for i = 2:m - 1
		for j = 2:n - 1
			f_orig = f_diff(i,j);
			f_diff(i,j) = (f_diff(i,j) > 127) * 255;
			error = f_orig - f_diff(i,j);
			f_diff(i,j+1) = f_diff(i,j+1) + error*(7/16);
			f_diff(i+1,j+1) = f_diff(i+1,j+1) + error*(1/16);
			f_diff(i+1,j) = f_diff(i+1,j) + error*(5/16);
			f_diff(i+1,j-1) = f_diff(i+1,j-1) + error*(3/16);
		end
	end

	f_diff = f_diff(2:end-1, 2:end-1);

end
function fid = fidelity(f,b)
	f = double(f);
	b = double(b);

	f_l = 255 * (f / 255).^2.2;
	sigma = 2;
	[i, j] = meshgrid(-3:1:3, -3:1:3);
	h = exp(-(i.^2 + j.^2)/(2*sigma));
	h = h / sum(h(:));

	f_lh = conv2(f_l, h, 'same'); % the same size as f_l
	b_lh = conv2(b, h, 'same'); % the same size as b
	f_lt = 255 * (f_lh / 255).^(1/3);
	b_lt = 255 * (b_lh / 255).^(1/3);

	[M, N] = size(f_lt);
	fid = sqrt((1 / (N * M)) * sum(sum((f_lt - b_lt).^2)));

end
function [err, errlog] = compute_rmse(data,t2,Y2)

% t1 and Y1 are the data
% t2 and Y2 are the model simulation

t1 = data.xdata;
Y1 = data.ydata;

N = numel(Y1);
Y3 = interp1(t2,Y2,t1);

sq = (Y1-Y3).^2;
sqlog = (log(Y1)-log(Y3)).^2;

err = 1/N * sqrt(sum(sq(:)));
errlog = 1/N * sqrt(sum(sqlog(:)));

end
function y = gaussian(x,mu,sigma)
%put mean and std (not variance) as inputs
 y = 1/(sqrt(2*pi)*sigma) .* exp(-0.5*((x-mu)./sigma).^2);
end


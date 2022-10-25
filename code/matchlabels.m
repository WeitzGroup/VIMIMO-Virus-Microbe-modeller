function [ID1, ID2] = matchlabels(A,B)
% reorder labels in B to match those in A, output is ID1 and ID2
% A is the 'master' and B gets reordered
% checks for extra entries in B
% matches must be exact

% to reorder a vector X, do:
% X = X(ID1);
% X = X(ID2);

ID1 = ismember(B,A);
[~,~,ID2] = intersect(A,B(ID1),'stable');

end



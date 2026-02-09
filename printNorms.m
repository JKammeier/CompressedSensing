function [l0,l1,l2] = printNorms(vector)
% Prints the L1 and L2 norms, as well as L0 of a vector.
%   Here, L0 is the ratio of nonzero entries to the length of the vector.

    l0 = nnz(vector) / numel(vector);
    l1 = norm(vector,1);
    l2 = norm(vector,2);

    fprintf("l0: %f\nl1: %f\nl2: %f\n\n", l0, l1, l2);
end
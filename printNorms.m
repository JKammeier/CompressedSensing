function [l0,l1,l2] = printNorms(vector)
%Prints the L1 and L2 norms, as well as L0 of a vector.
%   Here, L0 is the ration of nonzero entries to the length of the vector.

    l0 = nnz(vector)/length(vector);
    l1 = norm(vector,1);
    l2 = norm(vector,2);

    fprintf("l0: %d\nl1: %d\nl2: %d\n\n", l0, l1, l2);
end
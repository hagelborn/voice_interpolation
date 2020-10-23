function [interp] = dtw_interpolation(left,left_ind,right,right_ind,k)
%interpolation using our own method. The left and right arguments are the
%envelopes to be interpolated. The left_ind and right ind are the assigned
%indices from the left and right signal with the optimal mass transport
%plan. (The first two columns of in the sparse representation.) The
%interpolation coefficient, k, specifiec the proportion of left v. right envelope.


path_len = length(left_ind);
%adding an extra bin to avoid rounding errors.
len = max([length(left),length(right)])+1;
interp = zeros(len,1);

% vector to keep track of the weights passing through a certain bin.
line_vec = zeros(len,1);

for i = 1:path_len
    %Calculate interpolated position
    ind = (1-k)*left_ind(i) + k*right_ind(i);
    less = floor(ind);
    more = ceil(ind);
    %weight based on distance from bins
    weight = ind-less;
    if weight == 0
        interp(less) = interp(less) + (1-k)*left(left_ind(i)) + k*right(right_ind(i));
        line_vec(less) = line_vec(less) +1;
    else
        interp(less) = interp(less) + (1-weight)*((1-k)*left(left_ind(i)) + k*right(right_ind(i)));
        interp(more) = interp(more) + weight*((1-k)*left(left_ind(i)) + k*right(right_ind(i)));
        line_vec(less) = line_vec(less) + (1-weight);
        line_vec(more) = line_vec(more) + weight;
    end
end
% Combine last two bins, created to avoid rounding errors.
interp(end-1) = interp(end-1)+interp(end);
interp = interp(1:end-1);
ind = (line_vec(1:end-1) ~= 0);
%normalize with weights.
interp(ind) = interp(ind)./line_vec(ind);

end

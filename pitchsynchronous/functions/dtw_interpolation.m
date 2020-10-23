function [interp] = dtw_interpolation(left,left_ind,right,right_ind,k)
%interpolation using dynamic time warping, k is the interpolation
%coefficient. This means 0 corresponds to the left signal and k = 1 to the
%right.

%this is not yet right
path_len = length(left_ind);
len = max([length(left),length(right)])+1;
interp = zeros(len,1);

% vector to keep track of how many lines passes through a certain bin
line_vec = zeros(len,1);

for i = 1:path_len
    ind = (1-k)*left_ind(i) + k*right_ind(i);
    less = floor(ind);
    more = ceil(ind);
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
interp(end-1) = interp(end-1)+interp(end);
interp = interp(1:end-1);
ind = (line_vec(1:end-1) ~= 0);
interp(ind) = interp(ind)./line_vec(ind);

end

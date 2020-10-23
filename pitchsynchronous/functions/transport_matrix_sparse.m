function [T] = transport_matrix_sparse(X,Y)
    % Calculates a sparse representation of the transport matrix between
    % the distributions X,Y. The matrix describes how the masses in X are
    % reassigned to masses in Y in the optimal mass transport plan.
    i = 1;
    j = 1;
    rho_x = abs(X(i));
    rho_y = abs(Y(j));
    x_len = length(X);
    y_len = length(Y);
    T = zeros(length(X)+length(Y)-1,3);
    T_idx = 1;
    while true
        if rho_x <= rho_y
            T(T_idx,:) = [i,j,rho_x]; 
            rho_y = rho_y - rho_x;
            i = i+1;
            T_idx = T_idx+1;
            if i > x_len
                T(T_idx:end,1) = i-1;
                T(T_idx:end,2) = j+1:y_len;
                T(T_idx:end,3) = 0;
                break
            end
            rho_x = abs(X(i));
        else
            T(T_idx,:) = [i,j,rho_y];
            rho_x = rho_x-rho_y;
            j = j+1;
            T_idx = T_idx+1;
            if j >y_len
                T(T_idx:end,1) = i+1:x_len;
                T(T_idx:end,2) = j-1;
                T(T_idx:end,3) = 0;
                break
            end
            rho_y = abs(Y(j));
        end
    end

end


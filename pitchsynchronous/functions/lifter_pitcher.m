function [lifter, pitcher] = lifter_pitcher(cepstrum,lifter_order)
    % Divides cepstrum into rectangular lifter and "pitcher"(remaining information)
    % based on lifter order
    lifter = cepstrum;
    pitcher = cepstrum;
    lifter(lifter_order+2:end-(lifter_order)) = 0;
    pitcher(1:lifter_order+1) = 0;
    pitcher(end-lifter_order+1:end) = 0;
end
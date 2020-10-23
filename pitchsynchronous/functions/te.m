function envelope = te(x,tol,lifter_order,plotit)
% Estimates true envelope by iterative cepstral liftering
if nargin < 2
    tol = 2;
    lifter_order = 20;
    plotit = 0;
elseif nargin < 3
    lifter_order = 20;
    plotit = 0;
elseif nargin < 4
    plotit = 0;
else

padd = 2^nextpow2(length(x));

win = hamming(length(x));
x = x.*win;
X = fft(x,padd);
Aold = log(abs(X));
A0 = Aold;

ceps = real(ifft(Aold));
[lifter, ~] = lifter_pitcher(ceps,lifter_order);
Vold = real(fft(lifter));


cont = 1;
if plotit
    figure;
end

tol2 = 0;
while cont
    Aold = Aold - tol2;
    Anew = max(Vold,Aold);
    ceps = ifft(Anew);
    [lifter, ~] = lifter_pitcher(ceps,lifter_order);
    Vnew = real(fft(lifter));
    maxdiff = max(A0 - Vnew);
    maxdiff = exp(maxdiff);
    maxdiff = db(maxdiff);
    peak_miss = maxdiff - tol2 > tol;
    
    if plotit
        plot(A0)
        hold on
        plot(Vnew)
        pause(0.5)
        hold off
    end
  
   if peak_miss
      cont = 1; 
      Aold = Anew;
      Vold = Vnew;
   else
       cont = 0;
   end
end
envelope = exp(Vnew);

end
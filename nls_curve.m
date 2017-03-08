% J. Macoskey - I-GUTL
% U of Michigan
% 3/8/17
%
% Purpose: nonlinear least-squares curve fitting for Doppler-backscatter
% histology data analysis

function [x_fit,y_fit] = nls_curve(x,y,x0)
    warning('off')
    fun = @(x,xdata)x(1)*exp(x(2)*xdata);
    lsq = lsqcurvefit(fun,x0,x,y);
    x_fit = x(1):1:x(end);
    y_fit = fun(lsq,x_fit);
end
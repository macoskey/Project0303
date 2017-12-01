% J. Macoskey - I-GUTL
% U of Michigan
% 3/8/17
%
% Purpose: nonlinear least-squares curve fitting for Doppler-backscatter
% histology data analysis

function [x_fit,y_fit,resnorm,resid,exitflag,output,lambda,jacobian] = nls_curve(x,y,x0)
    warning('off')
%     fun = @(x,xdata)x(1)*exp(x(2)*xdata);
    fun = @(x,xdata)x(1)*exp(x(2)*xdata) + x(3)*exp(x(4)*xdata);
    [lsq,resnorm,resid,exitflag,output,lambda,jacobian] = lsqcurvefit(fun,x0,x,y);
    x_fit = x(1):1:x(end);
    y_fit = fun(lsq,x_fit);
end
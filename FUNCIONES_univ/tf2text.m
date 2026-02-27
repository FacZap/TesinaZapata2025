function [ totalfrac, tfobj ] = tf2tex( tfobj, sstr, input, output)
% TF2TEX Convert a transfer function to LaTeX math code
%   TOTALFRAC = TF2TEX(TFOBJ) convert 1-on-1 transfer function
%   TOTALFRAC = TF2TEX(TFOBJ,SSTR) convert 1-on-1 transfer function, using 
%       a different LaTeX text s (default SSTR='s')
%   TOTALFRAC = TF2TEX(TFOBJ,SSTR,INPUT,OUTPUT) convert the transfer
%       function from input INPUT to output OUTPUT of a multi-dimensional
%       transfer function object, using a different LaTeX text s 
%       (default SSTR='s')
%   To speed up LaTeX reporting, this function converts a numerator and
%   denominator array that is taken from a MATLAB tf object to LaTex math
%   code.
[num,den] = tfdata(tfobj);
switch nargin
    case 4
        num = num{output,input};
        den = den{output,input};
        tfobj = tf(num,den);
    case 2
        num = num{1};
        den = den{1};
    case 1
        num = num{1};
        den = den{1};        
        sstr = 's';
    otherwise
        error('Wrong number of input arguments');
end
totalfrac = '\frac';
for numden = 1:2
    if numden == 1
        array = num;
    else
        array = den;
    end
    
    firstflag = true;
    totalfrac = strcat(totalfrac,'{');
    for i = 1:length(array)
        if array(i) ~= 0
            pmstr = '+'; % define negative or positive concatenation sign.
            if array(i) < 0
                pmstr = '-';
            end
            if ~firstflag || strcmp(pmstr,'-')
                totalfrac = strcat(totalfrac,pmstr);
            end
            if array(i)~=1 || i == length(array)
                totalfrac = strcat(totalfrac, num2str(array(i)));
            end
            if i < length(array)
                totalfrac = strcat(totalfrac, sstr);
            end
            if i < length(array)-1
                totalfrac = strcat(totalfrac, '^{', num2str(length(array)-i),'}');
            end
            firstflag = false;
        end
    end
    totalfrac = strcat(totalfrac, '}');
end
end
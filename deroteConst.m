function [derotatedConstProj] = deroteConst(constProj)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    numRotations=100;
    values = zeros(numRotations,1);
    for idx=1:numRotations
       tmp=constProj.*exp(1i*pi/2*(idx/numRotations));
       values(idx)=var((abs(real(tmp)))+1i*(abs(imag(tmp))));
       figure(10); plot(abs(real(tmp))+1i*abs(imag(tmp)), '.');
       xlim([0 1.1])
       ylim([0 1.1])
       pause(.05);
    end
    [~,idx]=min(values);
    derotatedConstProj=constProj.*exp(1i*pi/2*(idx/numRotations));
    scatterplot(derotatedConstProj);
    title('Phase Corrected Signal');

end


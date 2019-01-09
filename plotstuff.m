function    plotstuff(ii,corrMatrix,dShift,iDop,PRN)
    figure(ii);
%     surf(corrMatrix,'edgecolor','none');
   plot(corrMatrix(iDop,:))
%     x=size(corrMatrix);
%     ylabel(['Doppler Shifts: ' num2str(x(1))])
    xlabel('Code Phase')
%     zlabel('Correlation')
    title(['PRN ' num2str(PRN)])

end
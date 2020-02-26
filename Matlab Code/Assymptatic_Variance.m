
%****************************************
%                 Variance of Volatility Estimates
i=0;
N=3000;
for rho= 0.65:0.005:.765
    myfun = @(x,rho) ff(x,rho);
    fun = @(x) myfun(x,rho);
    i=i+1;
    nu(i)=fzero(fun,[3 9]);
    for j=1:10000
        Z=random('T',nu(i),N,1);
        s(j)=var(Z);
        k(j)=kurtosis(Z);
    end
    S=sum(s)/length(s);
    K=sum(k)/length(k);
    As_Var_sigma(i)=(S/N)*(1-rho^2)/(rho^2);
    As_Var_s(i)=S*(K+2)/(4*N);
end
plot(nu,As_Var_sigma,'--rs','LineWidth',1,'MarkerSize',5,'MarkerFaceColor',[1 0 0])
hold on
plot(nu,As_Var_s,':ko','LineWidth',1,'MarkerSize',5,'MarkerFaceColor',[0 0 0])
title('Variance of Volatility Estimates')
xlabel('\nu')
ylabel('Variance')
legend({'G-EWMA','EWMA'})
set(gca, 'FontName', 'Times New Roman')
xlim([3.08 7.8])
grid on
%****************************************
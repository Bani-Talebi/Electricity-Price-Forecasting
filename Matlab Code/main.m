%                 Data Extraction
data=Canada.VarName1;
%****************************************
%            Log Return Calculation
l=length(data);
temp=log(data);
temp=temp(2:l)-temp(1:l-1);
log_ret=temp-mean(temp);
%****************************************
%               rho Calculation
x=log_ret;
y=sign(x);
y=y-mean(y);
rho=sum(x.*y)/sqrt(sum(x.^2)*sum(y.^2));
%****************************************
%                 Finding nu
myfun = @(x,rho) ff(x,rho);
fun = @(x) myfun(x,rho);
nu=fzero(fun,3);
%****************************************
%   Volatility Calculation Using Generalized EWMA
 T=length(log_ret);
 abs_ret=abs(log_ret);
alpha=[0.01:0.01:0.3];
for i=1:length(alpha)
    s=mean(abs_ret(1:30));
    SSE1=0;
    for j=1:T
        error=abs_ret(j)/rho-s;
        SSE1=error^2+SSE1;
        s=alpha(i)/rho*abs_ret(j)+(1-alpha(i))*s;
    end
    SSE_alpha1(i)=SSE1;
end
[m,index]=min(SSE_alpha1);
alpha_opt=alpha(index);
MSE_op=min(SSE_alpha1)/T;
rmse_vol_ewma=sqrt(MSE_op);
s=mean(abs_ret(1:30));
for i=1:T
    forcat_one_vol(i)=s;
    s=alpha_opt*abs_ret(i)/rho+(1-alpha_opt)*s;
end
vol_forcast=s;
%****************************************
%         Volatility Calculation Using EWMA
sq_ret=log_ret.^2;
for i=1:length(alpha)
    s=mean(sq_ret(1:30));
    SSE2=0;
    for j=1:T
        error=sq_ret(j)-s;
        SSE2=error^2+SSE2;
        s=alpha(i)*sq_ret(j)+(1-alpha(i))*s;
    end
    SSE_alpha2(i)=SSE2;
end
[m,index]=min(SSE_alpha2);
alpha_opt2=alpha(index);
MSE_op2=min(SSE_alpha2)/T;
rmse_ewma_sq=sqrt(MSE_op2);
s=mean(sq_ret(1:30));
for i=1:T
    forcat_one_var(i)=s;
    s=alpha_opt2*sq_ret(i)+(1-alpha_opt2)*s;
end
sq_ewma_forecast=sqrt(s);
%****************************************
%          VaR Calculation
p=[0.01:0.01:0.5];
F_Inv_R=tinv(p,nu);
VaR=-vol_forcast*F_Inv_R;
plot(p,VaR,'r','LineWidth',1)
xlim([0.01 0.5])
title('G-EWMA estimate of Value at Risk')
ylabel('VaR')
xlabel('Confidence Level')
set(gca, 'FontName', 'Times New Roman')
grid on
%****************************************
%             Back Testing
p=length(log_ret)-100;
q=length(log_ret);
t=p:q;
ret=log_ret(p:q);
Vol_EWMA=forcat_one_var(p:q);
Vol_GEWMA=forcat_one_vol(p:q);
Confidence_Level=0.03;
F_Inv_R=tinv(Confidence_Level,nu);
VaR_EWMA=sqrt(Vol_EWMA)*F_Inv_R;
VaR_GEWMA=Vol_GEWMA*F_Inv_R;
figure
plot(t,ret,'r','LineWidth',1);
hold on
plot(t,VaR_EWMA,'-.k','LineWidth',1)
plot(t,VaR_GEWMA,'--b','LineWidth',1)
title('Ontario Electricity VaR Forcast and Back Testing')
xlabel('Time Index')
ylabel('Log Return')
set(gca, 'FontName', 'Times New Roman')
legend({'Log Return','EWMA VaR','G-EWMA VaR'})
xlim([p q])
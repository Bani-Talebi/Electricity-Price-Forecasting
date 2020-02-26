%***************************************************
%       Double Exponential Smoothing Simulation
%                 Behrouz Banitalebi
%               banitalb@myumanitoba.ca
%Reference:
%Statistical Methods for Forecasting, by Abraham, 
%B. and Ledolter, J. (1983).Published by John Wiley
%***************************************************
y=Demand.VarName1;
y=y';
y=y/1000;
l=length(y);
x=1:l;
% plot(x,y)
% hold on
P=polyfit(x,y,1);
beta0=P(2);
beta1=P(1);
Q=polyfit(x,y,2);
b0=Q(3);
b1=Q(2);
b2=Q(1);
% y1=beta0+beta1*x;
% y2=b0+b1*x+b2*x.^2;
% plot(x,y1,'r','LineWidth',1)
% plot(x,y2,'g','LineWidth',1)
% title('Regression Model of Thermostat Sales')
% xlabel('t')
% ylabel('Supply')
% set(gca, 'FontName', 'Times New Roman')

%****************DES Optimum Alpha*************
alpha=0.01:0.01:1;
for i=1:length(alpha)
    S1=beta0-(1-alpha(i))/alpha(i)*beta1;
    S2=beta0-2*(1-alpha(i))/alpha(i)*beta1;
    SSE=0;
    for j=1:l
        error=y(j)-(2+(alpha(i)/(1-alpha(i))))*S1+(1+(alpha(i)/(1-alpha(i))))*S2;
        SSE=SSE+error^2;
        S1(i)=alpha(i)*y(j)+(1-alpha(i))*S1;
        S2(i)=alpha(i)*S1(i)+(1-alpha(i))*S2;
        S1=S1(i);
        S2=S2(i);
    end
    SSE_DES(i)=SSE;
end
% figure
% plot(alpha,SSE_DES,'r','LineWidth',1)
% hold on
% grid on
% title('Estimation Error vs \alpha')
% xlabel('\alpha')
% ylabel('Estimation Error')
% set(gca, 'FontName', 'Times New Roman')
%******************TES Optimum Alpha****************
for i=1:length(alpha)
    a=alpha(i);
    w=1-a;
    s1=b0-w/a*b1+0.5*b2*w*(2-a)/a^2;
    s2=b0-2*b1*w/a+b2*w*(3-2*a)/a^2;
    s3=b0-b1*3*w/a+1.5*b2*w*(4-3*a)/a^2;
    SSE=0;
    for j=1:l
        error=y(j)-((3+a*(6-5*a)/(2*w^2)+a^2/(w^2))*s1-(3+a*(5-4*a)/w^2+2*a^2/w^2)*s2+(1+a*(4-3*a)/(2*w^2)+a^2/(w^2))*s3);
        SSE=SSE+error^2;
        s1(i)=a*y(j)+(1-a)*s1;
        s2(i)=a*s1(i)+(1-a)*s2;
        s3(i)=a*s2(i)+(1-a)*s3;
        s1=s1(i);
        s2=s2(i);
        s3=s3(i);
    end
    SSE_TES(i)=SSE;
end
% plot(alpha,SSE_TES,'g','LineWidth',1)
% legend({'DES','TES'})
%***************************************************
%******************DES Forecast********************
[m,index]=min(SSE_DES);
a=alpha(index);
S1=beta0-(1-a)/a*beta1;
S2=beta0-2*(1-a)/a*beta1;
for i=1:l
    z1(i)=(2+a/(1-a))*S1-(1+a/(1-a))*S2;
    S1=a*y(i)+(1-a)*S1;
    S2=a*S1+(1-a)*S2;
end
z1(l+1)=(2+a/(1-a))*S1-(1+a/(1-a))*S2;
figure
a2=length(y);
a1=a2-24;
indx=0:24;
p1=y(a1:a2);
p2=z1(a1:a2);
plot(indx,p1,':k','LineWidth',2)
hold on
plot(indx,p2,'--ro','LineWidth',1,'MarkerSize',3,'MarkerFaceColor',[1 0 0])
ylabel('Electricity Supply (GW)')
xlabel('Hour')
title('Hourly Electricity Supply Forecast')
set(gca, 'FontName', 'Times New Roman')

%%******************************************************
%******************TES Forecast********************
[m,index]=min(SSE_TES);
a=alpha(index);
w=1-a;
s1=b0-w/a*b1+0.5*b2*w*(2-a)/a^2;
s2=b0-2*b1*w/a+b2*w*(3-2*a)/a^2;
s3=b0-b1*3*w/a+1.5*b2*w*(4-3*a)/a^2;
for i=1:l
    z2(i)=(3+a*(6-5*a)/(2*w^2)+a^2/(w^2))*s1-(3+a*(5-4*a)/w^2+2*a^2/w^2)*s2+(1+a*(4-3*a)/(2*w^2)+a^2/(w^2))*s3;
    s1=a*y(i)+(1-a)*s1;
    s2=a*s1+(1-a)*s2;
    s3=a*s2+(1-a)*s3;
end
z2(l+1)=(3+a*(6-5*a)/(2*w^2)+a^2/(w^2))*s1-(3+a*(5-4*a)/w^2+2*a^2/w^2)*s2+(1+a*(4-3*a)/(2*w^2)+a^2/(w^2))*s3;
p3=z2(a1:a2);
plot(indx,p3,'-.b^','LineWidth',1,'MarkerSize',3,'MarkerFaceColor',[0 0 1])
legend({'Observed Electricity Demand','DES Forecast of Electricity Demand','TES Forecast of Electricity Demand'})
xlim([0 24])
ylim([min(p3) max(p3)])
grid on
% axes('position',[.1 .5 .4 .4])
% box on
% b2=length(y);
% b1=a2-24;
% ind=b1:b2;
% plot(ind,y(b1:b2),':r','LineWidth',2)
% hold on
% plot(ind,z1(b1:b2),'-.k','LineWidth',1)
% hold on
% plot(ind,z2(b1:b2),'--b','LineWidth',1)
% xlim([b1 b2])
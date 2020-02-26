x1=[0   120 120 500 500 700 700 800 800 870 870 940 940 1000 1000];
y1=[200 200 150 150 100 100 60  60  30  30  20  20  10    10   1];
plot(x1,y1,'k','LineWidth',1)
ylim([0 200])
hold on
x2=[0 150 150 350 350 700 700 800 800 870 870 920 920 1000  1000 1100 1100 1250 1250 1350 1350   1500];
y2=[0  0   10  10  15  15  25  25  30  30  50  50  80   80  100   100  130 130   150 150   200    200];
plot(x2,y2,'r','LineWidth',1)
ylim([0 220])
xlabel('Quantity (MWh)')
ylabel('Price CAD/MWh')
title('Merit Order and Equilibrium')
annotation('textbox', [0.2, 0.7, 0.1, 0.1], 'String', "Demand",'FitBoxToText','on')
annotation('textbox', [0.7, 0.7, 0.1, 0.1],'Color','red', 'String',"Supply",'FitBoxToText','on')
set(gca, 'FontName', 'Times New Roman')

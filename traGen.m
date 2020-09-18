function [H,M,PLA] = traGen(cruH,cruM)
%根据巡航高度和巡航马赫数生成飞行轨迹
%包括起飞、爬升、巡航三个过程
%起飞
H1=[0 0];M1=[0 0.25];PLA1=[82 82];
t1=1:1:150;N1=length(t1);
H1=linspace(H1(1),H1(2),N1);
M1=linspace(M1(1),M1(2),N1);
PLA1=linspace(PLA1(1),PLA1(2),N1);
%爬升
H2=[0 cruH];M2=[0.25 cruM];PLA2=[70 70];
t2=151:1:1500;N2=length(t2);
H2=linspace(H2(1),H2(2),N2);
M2=linspace(M2(1),M2(2),N2);
PLA2=linspace(PLA2(1),PLA2(2),N2);
%巡航
H3=[cruH cruH];M3=[cruM cruM];PLA3=[65 65];
t3=1501:1:1800;N3=length(t3);
H3=linspace(H3(1),H3(2),N3);
M3=linspace(M3(1),M3(2),N3);
PLA3=linspace(PLA3(1),PLA3(2),N3);
%全程
H=[H1 H2 H3];
M=[M1 M2 M3];
PLA=[PLA1 PLA2 PLA3];
t=[t1 t2 t3];
%图示
% figure();
% subplot(311);plot(t,H,'LineWidth',2);ylabel('高度/km');axis([0 2000 0 H(end)+1]);
% subplot(312);plot(t,M,'LineWidth',2);ylabel('马赫数');axis([0 2000 0 M(end)+0.2]);
% subplot(313);plot(t,PLA,'LineWidth',2);ylabel('PLA');axis([0 2000 40 90]);
% suptitle('经典起飞/爬升/巡航轨迹');
end


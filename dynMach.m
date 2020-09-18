%%
clear all;clc;
%model setup
addpath('..');
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%set up parameters
num_step=200;
PNF=zeros(1,num_step);
PNC=zeros(1,num_step);
F=zeros(1,num_step);
WFB=zeros(1,num_step);
%set up initial condition
H=0;M=0;
engine.PLA=5;
engine.ComputeIdes();
engine.GetGuessValue();
engine.MainEngineWT(H,M,1.4618,0.2888);
step=1;
engine.WFB
while(step<=num_step)
    if(step==num_step/2)
        M=0.5; %改变马赫数
    end
    %engine.limitChange();
    engine.DemostrateDTOnce(H,M,1.4618,0.2888);
    PNF(step)=engine.PNF;
    PNC(step)=engine.PNC;
    F(step)=engine.F;
    WFB(step)=engine.WFB;
    step=step+1;
end
ts_PNF=timeseries(PNF,0:0.001:0.001*(num_step-1),'name','PNF');
ts_PNC=timeseries(PNC,0:0.001:0.001*(num_step-1),'name','PNC');
%ts_all = tscollection({ts_PNF;ts_PNC})
subplot(121);plot(ts_PNF);xlim([0.1 0.2]);
subplot(122);plot(ts_PNC);xlim([0.1 0.2]);
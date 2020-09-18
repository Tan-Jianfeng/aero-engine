%%
clear all;clc;
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%initialize parameters
num_single_step=200;
%H=0km,M=0,PLA在20~80之间
PLA_begin=20;PLA_end=80;
%PLA每隔1°
deltaPLA=10;
NP=(PLA_end-PLA_begin)/deltaPLA+1;
PNC=zeros(1,NP);
WFB=zeros(1,NP);
T5=zeros(1,NP);
P5=zeros(1,NP);
P16=zeros(1,NP);
%T16=zeros(1,NP);
T8=zeros(1,NP);
P8=zeros(1,NP);
PRF=zeros(1,NP);
PRC=zeros(1,NP);
PITG=zeros(1,NP);
PILG=zeros(1,NP);
F=zeros(1,NP);

tic
%initial condition
for l=1:NP
    engine.PLA=(l-1)*deltaPLA+20;
    t=toc;
    fprintf("%0.2f:PLA:%0.0f\n",t,engine.PLA);
    engine.ComputeIdes();
    engine.GetGuessValue();
    engine.MainEngineWT(0,0,1.4618,0.2888);
    step=1;
    WFBtemp=1.4618;
    while(step<=num_single_step)
        engine.DemostrateDTOnce(0,1,WFBtemp,0.2888);
        WFBtemp=engine.WFB;
        step=step+1;
    end
    %data storage
    PNC(l)=engine.PNC;
    WFB(l)=engine.WFB;
    T5(l)=engine.T5;
    P5(l)=engine.P5;
    P16(l)=engine.P16;
    T8(l)=engine.T8;
    P8(l)=engine.P8;
    PRF(l)=engine.PRF;
    PRC(l)=engine.PRC;
    PITG(l)=engine.PITG;
    PILG(l)=engine.PILG;
    F(l)=engine.F;
end

%%
%save data for training in python
save ss00_data_2080 PNC WFB T5 P5 P16 T8 P8 PRF PRC PITG PILG F
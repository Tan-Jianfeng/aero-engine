%%
clear all;clc;
%model setup
addpath('..');
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%initialize parameters
%高度在0~5km范围内，马赫数在0~1之间，PLA在20~60之间
%高度每隔0.5km，马赫数每隔0.05，PLA每隔2°
num_step=200;
NH=11;NM=21;NP=21;
PNC=zeros(NH,NM,NP);
WFB=zeros(NH,NM,NP);
T5=zeros(NH,NM,NP);
P5=zeros(NH,NM,NP);
P16=zeros(NH,NM,NP);
%T16=zeros(NH,NM,NP);
T8=zeros(NH,NM,NP);
P8=zeros(NH,NM,NP);
PRF=zeros(NH,NM,NP);
PRC=zeros(NH,NM,NP);
PITG=zeros(NH,NM,NP);
PILG=zeros(NH,NM,NP);
F=zeros(NH,NM,NP);

tic
%initial condition
for m=5:NH
    H=0.5*(m-1);
    for n=1:NM
        M=0.05*(n-1);
        for l=1:NP
            engine.PLA=2*(l-1)+20;
            t=toc;
            fprintf("%f:H:%f,Mach:%f,PLA:%f\n",t,H,M,engine.PLA);
            engine.ComputeIdes();
            engine.GetGuessValue();
            engine.MainEngineWT(H,M,1.4618,0.2888);
            step=1;
            WFBtemp=1.4618;
            while(step<=num_step)
                engine.DemostrateDTOnce(H,M,WFBtemp,0.2888);
                WFBtemp=engine.WFB;
                step=step+1;
            end
            %data storage
            PNC(m,n,l)=engine.PNC;
            WFB(m,n,l)=engine.WFB;
            T5(m,n,l)=engine.T5;
            P5(m,n,l)=engine.P5;
            P16(m,n,l)=engine.P16;
            T8(m,n,l)=engine.T8;
            P8(m,n,l)=engine.P8;
            PRF(m,n,l)=engine.PRF;
            PRC(m,n,l)=engine.PRC;
            PITG(m,n,l)=engine.PITG;
            PILG(m,n,l)=engine.PILG;
            F(m,n,l)=engine.F;
        end
    end
end
%%
%save data for training in python
save ss_data PNC WFB T5 P5 P16 T8 P8 PRF PRC PITG PILG F
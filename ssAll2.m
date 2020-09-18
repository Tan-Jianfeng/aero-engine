%%
clear all;clc;
%model setup
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%初始化参数
%高度在0~12km范围内，马赫数在0~1.2之间，PLA在65~85之间
%高度每隔0.5km，马赫数每隔0.1，PLA每隔2°
%准备采样的测量量为高度、马赫数、低压涡轮出口总压P46、高压转子转速
num_step=200;
NH=26;NM=13;NP=10;
ssData2=zeros(4000,7);
k=1877;
tic
for m=17:NH
    H=0.5*(m-1);
    for n=4:NM
        M=0.1*(n-1);
        InflyFlag=engine.infly(H,M);
        if(InflyFlag)
            for l=7:NP
                try
                    engine.PLA=2*(l-1)+65;
                    t=toc;
                    fprintf("%0.2f:第%0.0f个稳态点,H:%0.1f,Mach:%0.1f,PLA:%0.0f\n",t,k,H,M,engine.PLA);
                    engine.ComputeIdes();
                    engine.GetGuessValue();
                    WFBtemp=engine.WFB;
                    A8temp=engine.A8;
                    engine.MainEngineWT(H,M,WFBtemp,A8temp);
                    step=1;
                    while(step<=num_step)
                        engine.DemostrateDTOnce(H,M,WFBtemp,0.2888);
                        WFBtemp=engine.WFB;
                        step=step+1;
                    end
                    ssData2(k,:)=[H,M,engine.PNC,engine.P46,engine.F,engine.WFB,engine.WFA];
                    k=k+1;
                catch
                    warning("%0.2f:第%0.0f个稳态点,H:%0.1f,Mach:%0.1f,PLA:%0.0f未迭代至平衡点\n",t,k,H,M,engine.PLA);
                end
            end
        else
            fprintf("H:%0.2f,Mach:%0.2f不在飞行包线内\n",H,M);
        end
    end
end
%%
%save data for training in python
save ssData2 ssData2
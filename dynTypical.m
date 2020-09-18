%%
clear all;clc;
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
num_features=9;    %测量的参数个数
cruH=[8 9 10 11 12];
cruM=[0.8 0.9 1 1.1 1.2];
dynData=cell(length(cruH)*length(cruM),1);
%根据ESN程序来定这个训练数据的格式
%%
for i=1:length(cruH)
    for j=1:length(cruM)
        [H,M,PLA] = traGen(cruH(i),cruM(j));    %生成飞行轨迹
        assert(engine.infly(H(end),M(end)),'高度、马赫数不在包线范围，请重新输入！');
        N=length(H);
        dynData{(i-1)*length(cruH)+j}=zeros(N,num_features);
        %先让发动机运行至初始稳定状态
        engine.ComputeIdes();
        engine.GetGuessValue();
        engine.MainEngineWT(0,0,1.4618,0.2888);
        engine.PLA=PLA(1);
        step=1;
        WFBtemp=engine.WFB;
        while(step<=400)
            engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
            WFBtemp=engine.WFB;
            step=step+1;
        end
        step=1;
        while(step<=N)
            %高度马赫数PLA的变化步长为1s，而这个热力学计算的在C++模型里面的步长为定时器的步长55ms
            %所以在包线变化一个步长的时间内，热力学计算大约需要迭代20次
            for m=1:5
                engine.DemostrateDTOnce(H(step),M(step),WFBtemp,0.2888);
            end
            engine.PLA=PLA(step);
            WFBtemp=engine.WFB;
            data_once=[H(step),M(step),engine.PNC,engine.PNF,engine.A8...
                engine.P46,engine.F,engine.WFB,engine.WFA];
            dynData{(i-1)*length(cruH)+j}(step,:)=data_once;
            step=step+1;
        end
    end
end
%%
%画图
for i=n:size(dynData{1},2)
    figure();
    plot(dynData{1}(:,n));
end
%保存数据
save dynData dynData

close all;
clear cruH cruM PLA data_once WFBtemp num_features H M N step i j m n
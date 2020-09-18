%%
clear all;clc;
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%发动机动态点选取
PLAs=[25,35,45,55,65,...
      55,45,35,25,...
      35,45,65,...
      45,35,25,...
      35,55,65,...
      55,35,25,...
      45,55,65,...
      55,45,25,...
      35,65,...
      35,25,...
      55,65,...
      55,25,...
      45,65,...
      45,25,...
      65,...
      25];
t1=[0:1:40];
figure()
stairs(t1,PLAs,'linewidth',2)
axis([0,45,20,65]);
%========采样重要参数设置===========
num_single_steps=400;
num_features=13;
N=size(PLAs,2);
%%
dyn_train_middle=zeros(num_features,N*num_single_steps);
%生成训练数据
%先让发动机运行至初始稳定状态
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=25;
engine.MainEngineWT(0,0,1.4618,0.2888);
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
tic
for i=1:N
    engine.PLA=PLAs(i);
    time=toc;
    fprintf("%f:第%d组PLA\n",time,i);
    step=1;
    while(step<=num_single_steps)
        data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
        dyn_train_middle(:,(i-1)*num_single_steps+step)=data_once;
        engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
        WFBtemp=engine.WFB;
        step=step+1;
    end
end
save dynPLA_train dyn_train_middle
%%
%测试动态点选取
PLAs_test=[30,40,50,60,...
      50,40,30,...
      40,60,...
      40,30,...
      50,60,...
      50,30,...
      60,...
      30];
t=[0:1:16];
figure()
stairs(t,PLAs_test,'linewidth',2)
axis([0,17,25,65]);
%========采样重要参数设置===========
num_single_steps=400;
num_features=13;
Ntest=size(PLAs_test,2);
%%
dyn_test_middle=zeros(num_features,Ntest*num_single_steps);
%生成测试数据
%先让发动机运行至初始稳定状态
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=30;
engine.MainEngineWT(0,0,1.4618,0.2888);
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
tic
for i=1:Ntest
    engine.PLA=PLAs_test(i);
    time=toc;
    fprintf("%f:第%d组PLA\n",time,i);
    step=1;
    while(step<=num_single_steps)
        data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
        dyn_test_middle(:,(i-1)*num_single_steps+step)=data_once;
        engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
        WFBtemp=engine.WFB;
        step=step+1;
    end
end
save dynPLA_test_middle dyn_test_middle
%%
%生成测试数据1(PLA：30->60->30)
dyn_middle_test1=zeros(num_features,num_single_steps);
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=30;
engine.MainEngineWT(0,0,1.4618,0.2888);
%先让发动机运行至稳定
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
%开始调节PLA角度
up_time=1;
down_time=num_single_steps;
step=1;
while(step<=2*num_single_steps)
    if(step==up_time)
        engine.PLA=60; %上推油门杆
    end
    if(step==down_time)
        engine.PLA=30; %下推油门杆
    end
    data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
    dyn_middle_test1(:,step)=data_once;
    WFBtemp=engine.WFB;
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    step=step+1;
end
save dynPLA_middle_test1 dyn_middle_test1
%%
%生成测试数据2(PLA：20->80->20)
dyn_data_test2=zeros(num_features,num_single_steps);
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=20;
engine.MainEngineWT(0,0,1.4618,0.2888);
%先让发动机运行至稳定
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
%开始调节PLA
up_time=1;
down_time=num_single_steps;
step=1;
while(step<=2*num_single_steps)
    if(step==up_time)
        engine.PLA=70; %上推油门杆
    end
    if(step==down_time)
        engine.PLA=20; %下推油门杆
    end
    data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
    dyn_data_test2(:,step)=data_once;
    WFBtemp=engine.WFB;
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    step=step+1;
end
% for i=1:13
%     figure()
%     plot(dyn_data_test2(i,:))
% end
%plot(dyn_data_test2(13,:))
save dyn_PLA_test2 dyn_data_test2
%%
%生成测试数据3(工作点H:0.5km,M:0.2)
H=0.1;M=0.1;
dyn_data_test3=zeros(num_features,num_single_steps);
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=20;
engine.MainEngineWT(H,M,1.4618,0.2888);
%先让发动机运行至稳定
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(H,M,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
%开始调节PLA
up_time=1;
down_time=num_single_steps;
step=1;
while(step<=2*num_single_steps)
    if(step==up_time)
        engine.PLA=60; %上推油门杆
    end
    if(step==down_time)
        engine.PLA=20; %下推油门杆
    end
    data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
    dyn_data_test3(:,step)=data_once;
    WFBtemp=engine.WFB;
    engine.DemostrateDTOnce(H,M,WFBtemp,0.2888);
    step=step+1;
end
% for i=1:13
%     figure()
%     plot(dyn_data_test2(i,:))
% end
%plot(dyn_data_test2(13,:))
save dyn_PLA_test3 dyn_data_test3
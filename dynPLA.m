%%
clear all;clc;
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%��������̬��ѡȡ
PLAs=[20,30,40,50,60,...
      50,40,30,20,...
      30,40,60,...
      40,30,20,...
      30,50,60,...
      50,30,20,...
      40,50,60,...
      50,40,20,...
      30,60,...
      30,20,...
      50,60,...
      50,20,...
      40,60,...
      40,20,...
      60,...
      20];
t=[0:1:40];
figure()
stairs(t,PLAs,'linewidth',2)
axis([0,45,20,65]);
%========������Ҫ��������===========
num_single_steps=400;
num_features=13;
N=size(PLAs,2);
%%
dyn_data_train=zeros(num_features,N*num_single_steps);

%����ѵ������
%���÷�������������ʼ�ȶ�״̬
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=20;
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
    fprintf("%f:��%d��PLA\n",time,i);
    step=1;
    while(step<=num_single_steps)
        data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
        dyn_data_train(:,(i-1)*num_single_steps+step)=data_once;
        engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
        WFBtemp=engine.WFB;
        step=step+1;
    end
end
save dyn_PLA_train dyn_data_train
%%
%���ɲ�������1(PLA��25->55->25)
dyn_data_test1=zeros(num_features,num_single_steps);
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=30;
engine.MainEngineWT(0,0,1.4618,0.2888);
%���÷������������ȶ�
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
%��ʼ����PLA�Ƕ�
up_time=1;
down_time=num_single_steps;
step=1;
while(step<=2*num_single_steps)
    if(step==up_time)
        engine.PLA=50; %�������Ÿ�
    end
    if(step==down_time)
        engine.PLA=30; %�������Ÿ�
    end
    data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...
            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
            engine.PITG,engine.PILG,engine.F]';
    dyn_data_test1(:,step)=data_once;
    WFBtemp=engine.WFB;
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    step=step+1;
end
save dyn_PLA_test1 dyn_data_test1
%%
%���ɲ�������2(PLA��20->80->20)
dyn_data_test2=zeros(num_features,num_single_steps);
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=20;
engine.MainEngineWT(0,0,1.4618,0.2888);
%���÷������������ȶ�
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(0,0,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
%��ʼ����PLA
up_time=1;
down_time=num_single_steps;
step=1;
while(step<=2*num_single_steps)
    if(step==up_time)
        engine.PLA=70; %�������Ÿ�
    end
    if(step==down_time)
        engine.PLA=20; %�������Ÿ�
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
%���ɲ�������3(������H:0.5km,M:0.2)
H=0.1;M=0.1;
dyn_data_test3=zeros(num_features,num_single_steps);
engine.ComputeIdes();
engine.GetGuessValue();
engine.PLA=20;
engine.MainEngineWT(H,M,1.4618,0.2888);
%���÷������������ȶ�
step=1;
WFBtemp=engine.WFB;
while(step<=num_single_steps)
    engine.DemostrateDTOnce(H,M,WFBtemp,0.2888);
    WFBtemp=engine.WFB;
    step=step+1;
end
%��ʼ����PLA
up_time=1;
down_time=num_single_steps;
step=1;
while(step<=2*num_single_steps)
    if(step==up_time)
        engine.PLA=60; %�������Ÿ�
    end
    if(step==down_time)
        engine.PLA=20; %�������Ÿ�
    end
    data_once=[engine.PLA,engine.PNC,engine.WFB,engine.T5,engine.P5,...            engine.P16,engine.T8,engine.P8,engine.PRF,engine.PRC,...
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
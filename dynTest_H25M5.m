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
num_step=600;
num_feature=6;
up_time=200;
down_time=400;
dyn_data_all=zeros(num_feature,num_step);

engine.ComputeIdes();
engine.GetGuessValue();

%initial condition
H=0.25;M=0.05;
engine.PLA=20;
engine.MainEngineWT(H,M,1.4618,0.2888);
step=1;
while(step<=num_step)
    if(step==up_time)
        engine.PLA=60; %上推油门杆
    end
    if(step==down_time)
        engine.PLA=20; %下推油门杆
    end
    %data storage
    dyn_data_all(1,step)=engine.PNC;
    dyn_data_all(2,step)=engine.WFB;
    dyn_data_all(3,step)=engine.T5;
    dyn_data_all(4,step)=engine.P5;
    dyn_data_all(5,step)=engine.AM8;
    dyn_data_all(6,step)=engine.F;
    step=step+1;
    engine.DemostrateDTOnce(H,M,WFB(step-1),0.2888);
end
%%
%data illustration
time=0:0.001:0.001*(num_step-1);
ts_PNC=timeseries(dyn_data_all(1,:),time,'name','PNC');
ts_WFB=timeseries(dyn_data_all(2,:),time,'name','W_f/(kg/s)');
ts_T5=timeseries(dyn_data_all(3,:),time,'name','T5/K');
ts_P5=timeseries(dyn_data_all(4,:),time,'name','P5/Pa');
ts_M8=timeseries(dyn_data_all(5,:),time,'name','M_8');
ts_F=timeseries(dyn_data_all(6,:),time,'name','F/N');
e1=tsdata.event('上推油门杆',up_time*0.001);
e2=tsdata.event('下推油门杆',down_time*0.001);
ts_PNC = addevent(ts_PNC,e1);
ts_WFB=addevent(ts_WFB,e1);
ts_T5=addevent(ts_T5,e1);
ts_P5=addevent(ts_P5,e1);
ts_M8=addevent(ts_M8,e1);
ts_F=addevent(ts_F,e1);
ts_PNC = addevent(ts_PNC,e2);
ts_WFB=addevent(ts_WFB,e2);
ts_T5=addevent(ts_T5,e2);
ts_P5=addevent(ts_P5,e2);
ts_M8=addevent(ts_M8,e2);
ts_F=addevent(ts_F,e2);
xlim1=[0.1 0.001*(num_step-1)];
subplot(num_feature,1);plot(ts_PNC);xlim(xlim1);title('高压相似转速');
subplot(num_feature,2);plot(ts_WFB);xlim(xlim1);title('主燃油量');
subplot(num_feature,3);plot(ts_T5);xlim(xlim1);title('尾喷管进口总温');
subplot(num_feature,4);plot(ts_P5);xlim(xlim1);title('尾喷管进口总压');
subplot(num_feature,5);plot(ts_M8);xlim(xlim1);title('尾喷管喉道处马赫数');
subplot(num_feature,6);plot(ts_F);xlim(xlim1);title('推力');
%%
%save data for training in python
save dyn_data_test dyn_data_all
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
up_time=200;
down_time=400;
NX=5;NY=6;
PNC=zeros(NX,NY,num_step);
WFB=zeros(NX,NY,num_step);
T5=zeros(NX,NY,num_step);
P5=zeros(NX,NY,num_step);
F=zeros(NX,NY,num_step);

%initial condition
for i=1:NX
    for j=1:NY
        H=0.5*(i-1);
        M=0.1*(j-1);
        engine.PLA=20;
        engine.ComputeIdes();
        engine.GetGuessValue();
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
            PNC(i,j,step)=engine.PNC;
            WFB(i,j,step)=engine.WFB;
            T5(i,j,step)=engine.T5;
            P5(i,j,step)=engine.P5;
            F(i,j,step)=engine.F;
            step=step+1;
            engine.DemostrateDTOnce(H,M,WFB(i,j,step-1),0.2888);
        end
    end
end
%%
%data illustration
time=0:0.001:0.001*(num_step-1);
for i=1:NX
    for j=1:NY
        ts_PNC=timeseries(PNC(i,j,:),time,'name','PNC');
        ts_WFB=timeseries(WFB(i,j,:),time,'name','W_f/(kg/s)');
        ts_T5=timeseries(T5(i,j,:),time,'name','T5/K');
        ts_P5=timeseries(P5(i,j,:),time,'name','P5/Pa');
        ts_F=timeseries(F(i,j,:),time,'name','F/N');
        e1=tsdata.event('上推油门杆',up_time*0.001);
        e2=tsdata.event('下推油门杆',down_time*0.001);
        ts_PNC = addevent(ts_PNC,e1);
        ts_WFB=addevent(ts_WFB,e1);
        ts_T5=addevent(ts_T5,e1);
        ts_P5=addevent(ts_P5,e1);
        ts_F=addevent(ts_F,e1);
        ts_PNC = addevent(ts_PNC,e2);
        ts_WFB=addevent(ts_WFB,e2);
        ts_T5=addevent(ts_T5,e2);
        ts_P5=addevent(ts_P5,e2);
        ts_F=addevent(ts_F,e2);
        xlim1=[0.1 0.001*(num_step-1)];
        figure(i*j-1);
        subplot(511);plot(ts_PNC);xlim(xlim1);title('高压相似转速');
        subplot(512);plot(ts_WFB);xlim(xlim1);title('主燃油量');
        subplot(513);plot(ts_T5);xlim(xlim1);title('尾喷管进口总温');
        subplot(514);plot(ts_P5);xlim(xlim1);title('尾喷管进口总压');
        subplot(515);plot(ts_F);xlim(xlim1);title('推力');
    end
end
%%
%save data for training in python
PNC=PNC(:,:,201:600);
WFB=WFB(:,:,201:600);
T5=T5(:,:,201:600);
P5=P5(:,:,201:600);
F=F(:,:,201:600);
save dyn_data PNC WFB T5 P5 F
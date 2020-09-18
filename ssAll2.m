%%
clear all;clc;
%model setup
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
%��ʼ������
%�߶���0~12km��Χ�ڣ��������0~1.2֮�䣬PLA��65~85֮��
%�߶�ÿ��0.5km�������ÿ��0.1��PLAÿ��2��
%׼�������Ĳ�����Ϊ�߶ȡ����������ѹ���ֳ�����ѹP46����ѹת��ת��
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
                    fprintf("%0.2f:��%0.0f����̬��,H:%0.1f,Mach:%0.1f,PLA:%0.0f\n",t,k,H,M,engine.PLA);
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
                    warning("%0.2f:��%0.0f����̬��,H:%0.1f,Mach:%0.1f,PLA:%0.0fδ������ƽ���\n",t,k,H,M,engine.PLA);
                end
            end
        else
            fprintf("H:%0.2f,Mach:%0.2f���ڷ��а�����\n",H,M);
        end
    end
end
%%
%save data for training in python
save ssData2 ssData2
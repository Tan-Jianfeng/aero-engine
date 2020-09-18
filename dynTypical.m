%%
clear all;clc;
import wsX.Engine
import wsX.Controller
engine=Engine();
engine.controller=Controller();
%%
num_features=9;    %�����Ĳ�������
cruH=[8 9 10 11 12];
cruM=[0.8 0.9 1 1.1 1.2];
dynData=cell(length(cruH)*length(cruM),1);
%����ESN�����������ѵ�����ݵĸ�ʽ
%%
for i=1:length(cruH)
    for j=1:length(cruM)
        [H,M,PLA] = traGen(cruH(i),cruM(j));    %���ɷ��й켣
        assert(engine.infly(H(end),M(end)),'�߶ȡ���������ڰ��߷�Χ�����������룡');
        N=length(H);
        dynData{(i-1)*length(cruH)+j}=zeros(N,num_features);
        %���÷�������������ʼ�ȶ�״̬
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
            %�߶������PLA�ı仯����Ϊ1s�����������ѧ�������C++ģ������Ĳ���Ϊ��ʱ���Ĳ���55ms
            %�����ڰ��߱仯һ��������ʱ���ڣ�����ѧ�����Լ��Ҫ����20��
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
%��ͼ
for i=n:size(dynData{1},2)
    figure();
    plot(dynData{1}(:,n));
end
%��������
save dynData dynData

close all;
clear cruH cruM PLA data_once WFBtemp num_features H M N step i j m n
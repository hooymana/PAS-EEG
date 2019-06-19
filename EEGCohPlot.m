%Import Coherence data
clear; close all
%load('C:\Users\Andrew\Google Drive\Study 2\Pilot Data\EEG\NicoloPASPre\CoAllhiICA.mat');
%load('C:\Users\Andrew\Google Drive\Study 2\Pilot Data\EEG\NicoloPASPost\CoAllhiICA.mat');
%load('C:\Users\Andrew\Google Drive\Study 2\Pilot Data\EEG\PAS2Alex\CoAllhiICA.mat')
%load('C:\Users\Andrew\Google Drive\Study 2\Pilot Data\EEG\PAS1Alex\CoAllhiICA.mat')
%load('C:\Users\Andrew\Google Drive\Study 1\Data\EEG\iTBSpre\CoAllhiICA.mat')
%load('C:\Users\Andrew\Google Drive\Study 1\Data\EEG\iTBSpost\CoAllhiICA.mat')
%import desired EEG locations
cd('C:\Users\Andrew\Google Drive\Study 1\Data\Survey')
load('ChanStruct.mat')
load('ElecPairs.mat')
load('Labels.mat')
%load('PAS004')
cd('C:\Users\Andrew\Google Drive\Study 1\Data\Survey\eeglab13_6_5b')
group = 1;
eeglab
%load('G:\My Drive\Study 2\Pilot Data\EEG\A_PAS\RS3.mat')

if group ==2
    load('G:\My Drive\Study 2\Data\PAS005\Coh\CoRS')
    Coh=CoherenceHi;
    B=Coh(1,:);
    P500pre=Coh(4,:);
    P500post=Coh(5,:);
    P5pre=Coh(2,:);
    P5post=Coh(3,:);
    CoDiff=(P500post-P500pre);%-(P5post-P5pre);
end


if group == 1
    count = 1;
    for i = [1,3,4,6,7,8,9,10,11,5]
        load(['G:\My Drive\Study 2\Data\PAS00',num2str(i),'\Coh\CoRS'])
        %CoAllhiICA1Pre=CoherenceLo(1,:);
        %CoAllhiICA1Post=CoherenceLo(2,:);
        
        %tt=CoherenceLo;
        %tt=AOSCBetaHiNormAll;
        tt=CoherenceHi;
        if i == 2 || i ==  3 || i == 6 || i == 8 || i ==10 || i == 5
            tmp=tt;
            tmp1=[tmp(1,:);tmp(4,:);tmp(5,:);tmp(2,:);tmp(3,:)];
            Coh(count,:,:)=tmp1;
            B2(count,:)=tmp(2,:);
        else
            Coh(count,:,:)=tt;
            B2(count,:)=tt(2,:);            
        end
        
        count=count+1;
    end
    %Load new 2nd baseline
    load('G:\My Drive\Study 2\Data\PASAll\CoRS2.mat')
    Cohm=mean(Coh,1);
    B2=mean(B2);
    B2=reshape(B2,[1 1 1830]);
    %B=Cohm(1,1,:);
    
    P500pre=Cohm(1,4,:);
    P500post=Cohm(1,5,:);
    P5pre=Cohm(1,2,:);
    P5post=Cohm(1,3,:);
    %CoDiff=((P5post-P5pre)-(B2-B))-((P500post-P500pre)-(B2-B));
    %CoDiff=P5post-P500post;
    %CoDiff=(P5post-P5pre)-(P500post-P500pre);
    CoDiff=(P5post-P5pre);%-(B2-B);
    %CoDiff=B2-B;
    CoDiff = reshape(CoDiff,[],size(CoDiff,2),1)';
end
%Coh=AOSCBetaAll;
%Coh=CoherenceHi;
%AF8 to C6 is 1435
%Subtract Pre - Post Coherence Values

%CoDiff=CoAllhiICA1Post-CoAllhiICA1Pre;
%Index Channel you want

ROI=['AF8'];

if ~isempty(ROI)
    
    ind=[1:12,14:18,20:31,33:64];
    Index=find(contains(ElecPairs,ROI));
    %Remove Channels you don't want
    %Index(12)=[];%T8
    %Index(16)=[];%T7
    
    %CoDiff=CoAllhiICA1Pre;
    
    in=find(contains(LabelMod,ROI))-1;
    
    if strcmp(ROI, 'C6')
        Index=[ 49  108  166  223  279  334  388  441  493  544  594  643  691  738  784  829  873 916  958  999 1039 1078 1116 1153 1189 1224 1258 1291 1323 1354 1384 1413 1441 1468 1494 1519 1543 1566 1588 1609 1629 1648 1666 1684 1685 1686 1687 1688 1689 1690 1691 1692 1693 1694 1695 1696 1697 1698 1699 1700]-6;
        in = 43;
    end
    
    CoBetaChange=CoDiff(Index);
    P5=squeeze(P5post(1,1,Index))';
    P5pre=squeeze(P5pre(1,1,Index))';
    P500=squeeze(P500post(1,1,Index))';
    P500pre=squeeze(P500pre(1,1,Index))';
    B2=squeeze(B2(1,1,Index))';
    %CohAll(count2,:,:)=[CoherenceLo;CoherenceHi;CoherenceB;CoherenceA;CoherenceG];
    %CohAOS(count2,:,:)=[AOSCBetaLo;AOSCBetaHi;AOSCBeta;AOSCBetaHiNorm;AOSCBetaLoNorm;AOSCBetaNorm];
    %B5=squeeze(mean(CohAOS(:,4,:)));
    B5=squeeze(mean(CohAll(:,2,:)));
    B5(33)=0;
    B5=B5';
    %B5=[B5 .5356];
    P5=[P5(1:in) 0 P5(in+1:end)];
    P5pre=[P5pre(1:in) 0 P5pre(in+1:end)];
    P500=[P500(1:in) 0 P500(in+1:end)];
    P500pre=[P500pre(1:in) 0 P500pre(in+1:end)];
    B2=[B2(1:in) 0 B2(in+1:end)];
    CoBetaChange1=((P500-P500pre))%-(B2-B5);
    %CoBetaChange1=((P5-P5pre))-((P500-P500pre));
    %CoBetaChange1=[CoBetaChange(1:in) 0 CoBetaChange(in+1:end)];
    CoBetaChangeT=CoBetaChange1>0.095;
    CoBetaChangeD=(CoBetaChange1<-0.095)*-1;
    CoBetaChangeF=CoBetaChangeT+CoBetaChangeD;
    figure;
    topoplot(CoBetaChangeT,EEG3.locs,'electrodes','labels')
    colorbar
    %title({['Change in resting Beta Coherence between ', ROI,' (X)'], 'and all electrode pairs'},'FontSize',10)
end

if isempty(ROI)
    figure;
    ind=[1:12,14:18,20:31,33:64];
    count=1;
    for i = ind
        ROI=Label{i};
        Index=find(contains(ElecPairs,ROI));
        %Remove Channels you don't want
        %Index(12)=[];%T8
        %Index(16)=[];%T7
        
        
        
        %Subtract Pre - Post Coherence Values
        CoDiff=CoAllhiICA1Post-CoAllhiICA1Pre;
        
        %CoDiff=CoAllhiICA1Pre;
        
        in=find(contains(LabelMod,ROI))-1;
        
        CoBetaChange=CoDiff(Index);
        CoBetaChange1=[CoBetaChange(1:in) 0 CoBetaChange(in+1:end)];
        
        %Plot differences
        subplot(6,11,count)
        hold on
        %topoplot(CoBetaChange1,EEG3.locs,'electrodes','labels')
        topoplot(CoBetaChange1,EEG3.locs)
        %title({['Change in resting Beta Coherence between ', ROI,' (X)'], 'and all electrode pairs (Post-Pre)'},'FontSize',10)
        title(ROI)
        count=count+1;
    end
end

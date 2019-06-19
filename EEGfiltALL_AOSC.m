clear
close all
%Channels = 1:64;
%without M1 - 13 M2 - 19 electrodes for ICA data
Channels=[1:12,14:18,20:63];
%Channels=[1 2];
%For non-ICA Data remove EOG
%Channels=[1:12,14:18,20:31,33:64];
down=2;
DataAll=zeros(64,245761);
%CoAll=zeros(1,2016);
%Without M1 M2
%CoAlllo1819=zeros(1,1830);
%CoAllhi1819=zeros(1,1830);
y=[1];
%time=zeros(1,2016);
%Without M1 M2
%time=zeros(1,1891);
count=1;
count2=1;
for p = [1,3,4,6:11]
    for t = y
        %load(['L:\MBNL\CURRENT LAB MEMBERS\Andrew\Study 1\Data\EEG\P00',num2str(t),'S001\Trial01.mat'])
        %load(['G:\My Drive\Study 1\Data\EEG\P00',num2str(t),'S001\EEG_ica.mat'])
        %load(['G:\My Drive\Study 1\Data\EEG\P00',num2str(t),'S001\EEG_ica.mat'])
        load(['G:\My Drive\Study 2\Data\PAS00',num2str(p),'\RS',num2str(t),'\EEG_ica.mat'])
        %load('L:\MBNL\CURRENT LAB MEMBERS\Andrew\Project 1\EEG_ica')
        %Use 4 minutes
        
        %     if t < 6
        %         Trial.EEG=Trial.EEG(:,30*2048:(2048*4.5*60));
        %         Fsds = Trial.Fs/down;
        %         EEGds=resample(Trial.EEG',Fsds,Trial.Fs); % downsample to Fsds
        %     end
        %
        %     if t == 6
        %         Trial.EEG=double(Trial01.EEG);
        %         Trial.EEG=Trial.EEG(:,30*2048:(2048*4.5*60));
        %         Trial.Fs=2048;
        %         Fsds = Trial.Fs/2;
        %         EEGds=resample(Trial.EEG',Fsds,Trial.Fs); % downsample to Fsds
        %     end
        %
        %     if t > 6
        %         Trial.EEG=Trial.EEG.Data(:,30*2048:(2048*4.5*60));
        %         Trial.Fs=2048;
        %         Fsds = Trial.Fs/2;
        %         EEGds=resample(Trial.EEG',Fsds,Trial.Fs); % downsample to Fsds
        %     end
        
        %Convert to double
        Trial.EEG=double(EEG_ica);
        %Trial.EEG=Trial.EEG(:,30*2048:(2048*3.5*60));
        Trial.EEG=Trial.EEG(:,30*1*2048:(2048*4.5*60));
        Trial.Fs=2048;
        Fsds = Trial.Fs;
        %EEGds=resample(Trial.EEG',Fsds,Trial.Fs); % downsample to Fsds
        EEGds=Trial.EEG;
        %DataAll(:,:,t)=EEGds;
        freq=[2 80];
        normfreq=freq/(2048/down);
        [b1,a1]=butter(4,normfreq,'bandpass');
        %w0=60/(2048/2);
        %bw=w0/35;
        %Coherencelo=zeros(1,1830);
        %Coherencehi=zeros(1,1830);
        % Channel 5 = F3, 46 = C2, C3 = 15, C4 = 17,  FC5 = 9, C5 = 44, P3 = 25, FT7=58
        % Broca's area is FC5
        %[b2,a2]=iirnotch(w0,bw);
        for i = 1:length(Channels)
            %filtData=filtfilt(b1,a1,Trial.EEG(i,:));
            %downsampled
            filtData=filtfilt(b1,a1,EEGds(Channels(i),:));
            %notch
            %Trial.filtDataN(i,:)=filtfilt(b2,a2,filtData);
            Trial.filtDataN(Channels(i),:)=filtData;
        end
        %nfft=2^nextpow2(length(Trial.EEG));
        nfft=2^nextpow2(length(EEGds));
        %[Cxy, F]=mscohere(Trial.filtDataN(1,:),Trial.filtDataN(2,:),hanning(1024),512,nfft,Trial.Fs);
        
        j=1;
        %x=2;
        k=1;
        tic
        for i = 1:length(Channels)
            %for i = 1:length(Channels)-1
            %for j = x:length(Channels)
            %[Cxy, F]=mscohere(EEGds(i,1:5),EEGds(j,1:5), hanning(2),0,1,1);
            [Cxy, F]=mscohere(Trial.filtDataN(Channels(33),:),Trial.filtDataN(Channels(i),:), hanning(Fsds),0,nfft,Fsds);
            %44 is connection with C6
            %              figure; plot(F,Cxy,'linewidth',2)
            %              title('Measurement of Beta Coherence between F3 and C3')
            %              xlabel('Beta Frequency (20 - 30 Hz)')
            %              ylabel('Coherence Amplitude')
            
            BetaLo=find(F>12.5 & F<19.99);
            BetaHi=find(F>20 & F<30.99);
            Beta=find(F>12.5 & F<30.99);
            Alph=find(F>4.99 & F<15);
            Gma=find(F>39.99 & F<60);
            Bias=find(F>600 & F<800);
            [Plo, ~]=findpeaks(Cxy(BetaLo));
            [Phi, ~]=findpeaks(Cxy(BetaHi));
            [P, ~]=findpeaks(Cxy(Beta));
            [Af, ~]=findpeaks(Cxy(Alph));
            [Gm, ~]=findpeaks(Cxy(Gma));
            if isempty(Plo)
                %P = 0;
                Plo = mean(Cxy(BetaLo));
            end
            
            if isempty(Phi)
                %P = 0;
                Phi = mean(Cxy(BetaHi));
            end
            
            if isempty(P)
                %P = 0;
                P = mean(Cxy(Beta));
            end
            
            if isempty(Af)
                %P = 0;
                Af = mean(Cxy(Alph));
            end
            
            if isempty(Gm)
                %P = 0;
                Gm = mean(Cxy(Gma));
            end
            
            %             if length(P) > 1
            %                 P = P(1);
            %             end
            %Store each coherence for each participant here
            Coherencelo(k)=max(Plo);
            Coherencehi(k)=max(Phi);
            Coherenceb(k)=max(P);
            Coherencea(k)=max(Af);
            Coherenceg(k)=max(Gm);
            %Coherence(k)=Cxy(1);
            FzBetaHi= atanh(sqrt(Cxy(BetaHi)));
            FzBetaLo= atanh(sqrt(Cxy(BetaLo)));
            FzBeta= atanh(sqrt(Cxy(Beta)));
            ZBetaHi = ( FzBetaHi / sqrt(1 / 2))-mean(zscore(Cxy(Bias)));
            %figure; plot(F(BetaHi),ZBetaHi,'linewidth',2)
            ZBetaLo = ( FzBetaLo / sqrt(1 / 2))-mean(zscore(Cxy(Bias)));
            ZBeta = ( FzBeta / sqrt(1 / 2))-mean(zscore(Cxy(Bias)));
            AOSCBetaHi(k)=sum (ZBetaHi ( ZBetaHi > 1.65 ));
            AOSCBetaLo(k)=sum (ZBetaLo ( ZBetaLo > 1.65 ));
            AOSCBeta(k)=sum (ZBeta ( ZBeta > 1.65 ));
            AOSCBetaHiNorm(k)=sum(ZBetaHi>1.65)/length(ZBetaHi);
            AOSCBetaLoNorm(k)=sum(ZBetaLo>1.65)/length(ZBetaLo);
            AOSCBetaNorm(k)=sum(ZBeta>1.65)/length(ZBeta);
            BetaLoMean(k)=mean(Cxy(BetaLo));
            BetaHiMean(k)=mean(Cxy(BetaHi));
            BetaMean(k)=mean(Cxy(Beta));
            AOCBetaHiNorm(k)=sum(ZBetaHi)/length(ZBetaHi);
            AOCBetaLoNorm(k)=sum(ZBetaLo)/length(ZBetaLo);
            AOCBetaNorm(k)=sum(ZBeta)/length(ZBeta);
            k=k+1;
            
            %end
            %%x=x+1;
        end
        AOSCBetaHiAll(count,:)=AOSCBetaLo;
        AOSCBetaLoAll(count,:)=AOSCBetaHi;
        AOSCBetaAll(count,:)=AOSCBeta;
        AOSCBetaHiNormAll(count,:)=AOSCBetaHiNorm;
        AOSCBetaLoNormAll(count,:)=AOSCBetaLoNorm;
        AOSCBetaNormAll(count,:)=AOSCBetaNorm;
        CoherenceHi(count,:)=Coherencehi;
        CoherenceLo(count,:)=Coherencelo;
        CoherenceB(count,:)=Coherenceb;
        CoherenceA(count,:)=Coherencea;
        CoherenceG(count,:)=Coherenceg;
        BetaHiMeanAll(count,:)=BetaHiMean;
        BetaLoMeanAll(count,:)=BetaLoMean;
        BetaMeanAll(count,:)=BetaMean;
        AOCBetaHiNormAll(count,:)=AOCBetaHiNorm;
        AOCBetaLoNormAll(count,:)=AOCBetaLoNorm;
        AOCBetaNormAll(count,:)=AOCBetaNorm;
        count = count + 1;
        
        clock
        toc
        %         save(['G:\My Drive\Study 1\Data\EEG\P00',num2str(t),'S001\Coh.mat'],...
        %             'AOSCBetaHiAll','AOSCBetaHiNormAll','CoherenceHi','BetaHiMeanAll')
        %         save(['G:\My Drive\Study 1\Data\EEG\P00',num2str(t),'S001\Coh'],...
        %             'AOSCBetaLoAll','AOSCBetaLoNormAll','CoherenceLo','BetaLoMeanAll','-append')
        
        
        
    end
    count=1;
    CohAll(count2,:,:)=[CoherenceLo;CoherenceHi;CoherenceB;CoherenceA;CoherenceG];
    CohAOS(count2,:,:)=[AOSCBetaLo;AOSCBetaHi;AOSCBeta;AOSCBetaHiNorm;AOSCBetaLoNorm;AOSCBetaNorm];
    count2=count2+1;
end
save(['G:\My Drive\Study 2\Data\PASAll\CoRS2.mat'],...
    'CoherenceHi', 'CoherenceLo', 'CoherenceB', 'CoherenceA', 'CoherenceG',...
    'CohAll','CohAOS')
% save(['G:\My Drive\Study 2\Data\PAS0010\Coh\CoRS.mat'],...
%     'AOSCBetaHiAll','AOSCBetaHiNormAll','CoherenceHi','BetaHiMeanAll','AOCBetaHiNormAll')
% save(['G:\My Drive\Study 2\Data\PAS0010\Coh\CoRS.mat'],...
%     'AOSCBetaLoAll','AOSCBetaLoNormAll','CoherenceLo','BetaLoMeanAll','AOCBetaLoNormAll','-append')
% save(['G:\My Drive\Study 2\Data\PAS0010\Coh\CoRS.mat'],...
%     'AOSCBetaAll','AOSCBetaNormAll','CoherenceB','BetaMeanAll','AOCBetaNormAll','-append')

%save('L:\MBNL\CURRENT LAB MEMBERS\Andrew\Project 1\AllBetaLoICA2.mat','CoAllloICA2')
%save('L:\MBNL\CURRENT LAB MEMBERS\Andrew\Project 1\AllBetaHiICA2.mat','CoAllhiICA2')
%save('C:\Users\hooyman\Google Drive\Study 2\Pilot Data\EEG\PAS1Alex\CoAllloICA.mat','CoAllloICA1PreA','-append')
%save('C:\Users\hooyman\Google Drive\Study 2\Pilot Data\EEG\PAS1Alex\CoAllhiICA.mat','CoAllhiICA1PreA','-append')
%figure;plot(Coherence(1:15))
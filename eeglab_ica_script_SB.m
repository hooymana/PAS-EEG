clear; close all;
%---- this part is just loading the data:
tic
partic='RS3';
folder='G:\My Drive\Study 2\Data\PAS007\';
FileName = [folder,partic,'\Trial.mat']; % replace with your own file directory
%FileName='G:\My Drive\Study 1\Data\EEG\P0034S001\Trial.mat';
MatFileName = FileName(end-20:end-4); % optional
load(FileName);
SubjectName = MatFileName(1:8); % optional
%load('C:\Users\Andrew\Google Drive\Study 1\Project1\ep.mat')
%Fs = round(Trial.Fs); % the samplingn frequency
Fs=2048;
%eegdata=PASconv;
eegdata = Trial.EEG.Data; % put the data into a new variable to load from eeglab
%T=round(length(eegdata)/Fs);
eegdata = eegdata(:,1:2048*300);
%---- here we define events as 1, 2 etc. into a dummy channel 65. you can just define 1 for the start
%of each 3-sec epoch (for example) in that case you do
%eegdata(65,[1:3*Fs:30*Fs]) = 1 (assuming your data is 30 seconds long).
%eegdata(65,[3*Fs:6*Fs:300*Fs]) = 2; % hold
eegdata(65,[4*Fs:9*Fs:300*Fs]) = 2;
eegdata(65,[1:3*Fs:300*Fs]) = 1; 

%eegdata(65,[3.5*Fs:9*Fs:452*Fs]) = 1; % prep
%eegdata(65,[l])=1;
cd('G:\My Drive\Study 1\Data\Survey\eeglab13_6_5b') % this is just putting me back into the eeglab directory, optional if you're already there
eeglab; % open eeglab

EEG = pop_importdata('dataformat','array','nbchan',0,'data','eegdata','setname',MatFileName,'srate',2048,'subject',SubjectName,'pnts',0,'xmin',0); % import the matlab variable 'eegdata'
EEG = eeg_checkset( EEG ); % this is just something eeglab does by default after each operation so you'll see this a lot here.
EEG = pop_chanevent(EEG, 65,'edge','leading','edgelen',0); % import events from "channel" 65 and remove the dummy channel 
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','C:\Users\Andrew\Documents\MATLAB\Databaser\eeglab13_6_5b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp','load',{'C:\Users\Andrew\Documents\MATLAB\Databaser\eeglab13_6_5b\antlocations64.ced' 'filetype' 'autodetect'}); % import channel locations and names (only replace the antlocations64.ced part with your own location for this file)
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG,'nochannel',{'EOG'}); % remove EOG (ground) channel (#32)
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, [], 1, 6760, true, [], 1); % High Pass Filter at 1 Hz
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 59, 61, 6760, 1, [], 1); % notch filter at 60 Hz
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {'1'}, [0 3], 'newname', [MatFileName 'epochs'], 'epochinfo', 'yes'); % extract epochs, in your case you put [0 3] if you are using 3-second epochs starting at event '1'
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, []); % remove the baseline using the
% first 500 ms of each epoch % optional, you can also just leave the
% interval as [] to use the entire epoch as baseline. here it's not in
% seconds, but ms.
EEG = eeg_checkset( EEG );
EEG = pop_runica(EEG, 'extended',1,'pca',10, 'icatype', 'runica'); % run ICA decomposition with 10 components and (faster) algorithm 'binica'. if binica doesn't work use 'runica'
EEG = eeg_checkset( EEG );
pop_selectcomps(EEG, [1:10] ); % plot independent components to mark for rejection
uiwait(msgbox('Click OK after marking components to reject.')); % wait until components to reject are selected
toc
EEG = eeg_checkset( EEG );
RejectedComp = EEG.reject.gcompreject; % keep a variable with rejected component numbers (just for you in case you need to look back)
EEG = pop_subcomp( EEG, find(RejectedComp~=0), 1); % remove selected components
EEG = eeg_checkset( EEG );

EEG_ica = EEG.data(:,:); % put the ICA-pruned data back into a long 2D array instead of an epoch-by-epoch 3d array. 
%EEG_icaPost2=EEG_ica;
cd([folder,partic])
%cd('G:\My Drive\Study 1\Data\EEG\P0034S001')
save('EEG_ica.mat','EEG_ica')

% save your data (optional)
% save(['/Users/Sarine/Desktop/eeglab test ucm data/', MatFileName, '_eeglaboutput.mat'], 'EEG','RejectedComp')

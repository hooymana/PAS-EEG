# PAS-EEG
ICA and Coherence Calculation for resting state EEG (MATLAB)

Within this repository are three files: eeglab_ica_script, EEGfiltALL_AOSC, EEGCohPlot.

eeglab_ica_script is for the application of ICA on raw eeg files. There are comments throughout the script to indicate where paths for a new computer should be placed.

EEGfiltALL_AOSC filters and calculates coherence for all electrodes except M1 and M2. These are located behind the ear on our 64 led EEG cap and were not used in our analysis.

EEGCohPlot a script to visualize the calculated coherence map of the entire scalp to a reference electrode. Currently it is set to AF8 because that was our area of interest. Included with this script are other files that need to be loaded for the visualization to work.

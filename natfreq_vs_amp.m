%% Natural Frequency vs Amplitude
% Properties are from vibrating string example of COMSOL
% Viscous damping 1E6 & 1E6
% Frequency step 0.1

%% PART I: import data from .txt

clc
clear
fid = fopen('natfreq_vs_amp.txt','rt');
% open .txt file with rt argument (read text)

vib_data = textscan(fid, '%f %f %f', 'HeaderLines', 1);
% get 3 floating number

s0_fac = vib_data(1:end,1);
% read from row 1 to end, column 1

nat_freq = vib_data(1:end,2);
% read from row 1 to end, column 2

nf_amp = vib_data(1:end,3);
% read from row 1 to end, column 3

fclose(fid);
% close 'Clean_PPG.txt'

s0_fac = cell2mat(s0_fac);
nat_freq = cell2mat(nat_freq);
nf_amp = cell2mat(nf_amp);

data_mat(:,1) = s0_fac;
data_mat(:,2) = nat_freq;
data_mat(:,3) = nf_amp;

%% Part II: Plotting

% Create a scatter plot
figure;
hold on;

scatter(nat_freq, nf_amp, 'filled');

% Set labels and title
xlabel('Frequency');
ylabel('Amplitude');
title('Scatter Plot of Frequency vs Amplitude');
% ylim([0 max(nf_amp)])

% Add legends
legend('Data Points');

% Adjust the aspect ratio to preserve the distances between points
% axis equal;

% Grid on for better readability
grid on;


% Hold off to stop adding to the current plot
hold off;
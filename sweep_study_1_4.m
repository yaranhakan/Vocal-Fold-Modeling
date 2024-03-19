% Freq Response Study 1

clc
clear


fileNames = {'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\polip x5000.txt'};

% Plot all graphs seperately
tiled_plotting = false;

% Show the aggregated graph
agr_tf_plotting = true;

% View the first and the last graphs
view_first_last = true;

% View all data (needs view_first_last = 0)
comp_view = false;

% Moving mean smoothing
mov_mean = 0;

% Legend ON/OFF
lgd = true;

sweep_study_func(fileNames, tiled_plotting, agr_tf_plotting, comp_view, ...
    view_first_last, mov_mean, lgd);
%%

% (healthy data, polyp data, smoothing factor)
plot_domain_probe_data('C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\polipsiz x8000.txt', ...
    'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\polip x8000.txt', 60);

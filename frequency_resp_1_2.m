%% Freq Resonse Study 1
%   Written by O. Hakan Yaran
%   Istanbul Technical University, 2024

clc
clear

%% PART I: import data from .txt

% Define file names
fileNames = {'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\-3.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\-2.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\-1.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\0.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\1.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\2.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\3.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\4.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\5.txt', ...
             'C:\Users\yaran\Desktop\EDL\Vocal Fold\Data\Frequency Response Data 1\6.txt'};

% Preallocate cell array to store data
data = cell(size(fileNames));

% Loop through each file
for i = 1:numel(fileNames)
    % Open the file for reading
    fid = fopen(fileNames{i}, 'r');
    
    % Read the data, skipping the first 5 lines
    data{i} = textscan(fid, '%d %f %f', 'HeaderLines', 5);
    
    % Close the file
    fclose(fid);
end

% Access the data for each file
data_fn3 = data{1};
data_fn2 = data{2};
data_fn1 = data{3};
data_f0 = data{4};
data_fp1 = data{5};
data_fp2 = data{6};
data_fp3 = data{7};
data_fp4 = data{8};
data_fp5 = data{9};
data_fp6 = data{10};

% % Extract the columns

% index = data_fn3{1};
% displacement_z_real = real(data_fn3{2});
% displacement_y_real = real(data_fn3{3});

% %% Plot the Data
% 
% % Extract the data for one file
% index = data_fn3{1};
% % displacement_z_real = real(data_fn3{2});
% displacement_y_real = real(data_fn3{3});
% 
% % Plot displacement_z_real vs. index
% figure;
% plot(index, displacement_y_real, 'b-', 'LineWidth', 1.5);
% xlabel('Index');
% ylabel('Displacement on Y-axis (Real part)');
% title('Plot of Displacement on Z-axis vs. Index');
% grid on;

%%

% Create a figure
fig = figure;

% Extract the data for all files
index = cell(numel(data), 1);
displacement_z_real = cell(numel(data), 1);
displacement_y_real = cell(numel(data), 1);

for i = 1:numel(data)
    index{i} = data{i}{1};
    displacement_z_real{i} = real(data{i}{2});
    displacement_y_real{i} = real(data{i}{3});
end

% Initial dataset to plot
selectedDataIndex = 1;

% Plot the initial dataset
plotData(selectedDataIndex, index, displacement_y_real);

% Create a dropdown menu to select dataset
dropdown = uicontrol('Style', 'popupmenu', ...
                     'String', {'-3', '-2', '-1', '0', '1', '2', '3', '4', '5', '6', 'Sum Z-axis', 'Sum Y-axis'}, ...
                     'Position', [20, 20, 100, 20], ...
                     'Callback', {@dropdownCallback, index, displacement_z_real, displacement_y_real});

% Dropdown callback function
function dropdownCallback(source, ~, index, displacement_z_real, displacement_y_real)
    selectedDataIndex = source.Value;
    if selectedDataIndex <= numel(index)  % Plot individual datasets
        plotData(selectedDataIndex, index, displacement_y_real);
    elseif selectedDataIndex == numel(index) + 1  % Plot sum of Z-axis displacements
        plotSum(index, displacement_z_real, 'Sum of Displacements on Z-axis', 'b-');
    else  % Plot sum of Y-axis displacements
        plotSum(index, displacement_y_real, 'Sum of Displacements on Y-axis', 'r-');
    end
end

% Plot function
function plotData(indexToPlot, index, displacement_y_real)
    % Clear the axes instead of the entire figure
    cla;
    hold on;
    plot(index{indexToPlot}, displacement_y_real{indexToPlot}, 'b-', 'LineWidth', 1.5);
    xlabel('Index');
    ylabel('Displacement on Y-axis (Real part)');
    title(['Plot of Displacement on Y-axis vs. Index for Dataset ', num2str(indexToPlot - 3)]);
    grid on;
    hold off;
end

% Plot function for sum of displacements
function plotSum(index, displacements, titleStr, color)
    % Compute the sum of displacements across all datasets
    sumDisplacements = zeros(size(index{1}));
    for i = 1:numel(displacements)
        sumDisplacements = sumDisplacements + displacements{i};
    end
    
    % Plot the sum of displacements
    cla;
    hold on;
    plot(index{1}, sumDisplacements, color, 'LineWidth', 1.5);
    xlabel('Index');
    ylabel('Sum of Displacements');
    title(titleStr);
    grid on;
    hold off;
end




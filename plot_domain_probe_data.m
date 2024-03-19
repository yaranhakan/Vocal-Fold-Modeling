function plot_domain_probe_data(file1_path, file2_path, moving_avg_period)
    % Read model names from the first line of each file
    model_name1 = extract_model_name(file1_path);
    model_name2 = extract_model_name(file2_path);

    % Process and plot data from the first file
    [freq1, avg_domain_probe1] = process_data(file1_path, moving_avg_period);

    % Process and plot data from the second file
    [freq2, avg_domain_probe2] = process_data(file2_path, moving_avg_period);

    % Plot domain probe readings from both files
    figure;
    hold on;
    if moving_avg_period > 0
        % If moving average is applied, plot the smoothed data
        plot(freq1, avg_domain_probe1, 'b', 'LineWidth', 2);
        plot(freq2, avg_domain_probe2, 'r', 'LineWidth', 2);
    else
        % If moving average is not applied, plot the aggregated data
        plot(freq1, avg_domain_probe1, 'b', 'LineWidth', 2);
        plot(freq2, avg_domain_probe2, 'r', 'LineWidth', 2);
    end

    % Customize plot
    xlabel('Frekans (Hz)');
    ylabel('Genlik (m)');
    title('Frekans Tepkisi Grafiği');
    legend('Sağlıklı ses teli', 'Polipli ses teli');
    grid on;
    hold off;
end

function [freq, avg_domain_probe] = process_data(file_path, moving_avg_period)
    % Read data, skipping header
    data = readmatrix(file_path, 'NumHeaderLines', 5);
    freq = unique(data(:, 2)); % Frequencies
    avg_domain_probe = zeros(size(freq));
    
    % Calculate average displacement for each frequency
    for i = 1:length(freq)
        idx = data(:, 2) == freq(i);
        avg_domain_probe(i) = mean(data(idx, 4)); % Assuming displacement is in the fourth column
    end
    
    % Apply moving average if specified
    if moving_avg_period > 0
        avg_domain_probe = movmean(avg_domain_probe, moving_avg_period);
    end
end

function model_name = extract_model_name(file_path)
    fid = fopen(file_path, 'r');
    model_name = fgetl(fid); % Read the first line
    fclose(fid);
    
    % Extract model name and format it for legend
    model_name = strrep(model_name, '% Model:', '');
    model_name = strtrim(model_name);
    [~, model_name, ~] = fileparts(model_name); % Extract model name without extension
    model_name = strrep(model_name, '_', ' ');
end

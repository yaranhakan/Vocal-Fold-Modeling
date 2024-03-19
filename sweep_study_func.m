function sweep_study_func(fileNames, tiled_plotting, agr_tf_plotting, comp_view, view_first_last, mov_mean, lgd)
    % Data import

    % Preallocate cell array to store data
    data = cell(size(fileNames));

    % Loop through each file
    for i = 1:numel(fileNames)
        % Open the file for reading
        fid = fopen(fileNames{i}, 'r');

        % Read the data, skipping the first 5 lines
        data{i} = textscan(fid, '%d %f %f %f', 'HeaderLines', 5);

        % Close the file
        fclose(fid);
    end

    % Access the data for each file
    data_sweep = data{1};

    % Extract the columns
    fl_val = data_sweep{1};
    freq = data_sweep{2};
    displacement_boundary = real(data_sweep{3});
    displacement_domain = real(data_sweep{4});

    %% Signal Processing

%     % Find the beginning, end, and step size of the frequency range
%     freq_begin = min(freq);
%     freq_end = max(freq);
%     freq_step = freq(2) - freq(1);  % Assuming frequency values are evenly spaced

    % Get unique fl_val values and their corresponding indices
    unique_fl_val = unique(fl_val);

    % Preallocate cell arrays to store data for each fl_val
    displacement_boundary_data = cell(size(unique_fl_val));
    displacement_domain_data = cell(size(unique_fl_val));

    % Loop over each unique fl_val
    for i = 1:numel(unique_fl_val)
        % Find indices corresponding to the current fl_val
        indices = find(fl_val == unique_fl_val(i));

        % Store displacement data for the current fl_val
        displacement_boundary_data{i} = displacement_boundary(indices);
        displacement_domain_data{i} = displacement_domain(indices);
    end

    %% Plotting

    if tiled_plotting == true

        % Create figure for separate plots
        fig = figure;

        % Set up tiled layout
        t_layout = tiledlayout(fig, 'flow', 'TileSpacing', 'compact');

        % Store all displacement data together
        all_displacement = [displacement_boundary; displacement_domain];

        % Find the maximum amplitude for y-axis scaling
        max_amplitude = max(all_displacement);

        % Initialize empty plot handles
        boundary_plot = gobjects(size(unique_fl_val)); % For R2014b and later
        domain_plot = gobjects(size(unique_fl_val)); % For R2014b and later

        % Loop over each unique fl_val to plot the data separately
        for i = 1:numel(unique_fl_val)
            % Get frequency and displacement data for the current fl_val
            freq_i = freq(fl_val == unique_fl_val(i));
            displacement_boundary_i = displacement_boundary(fl_val == unique_fl_val(i));
            displacement_domain_i = displacement_domain(fl_val == unique_fl_val(i));

            % Create axes for the current plot
            nexttile(t_layout);

            % Plot boundary data with red color
            boundary_plot(i) = plot(freq_i, displacement_boundary_i, 'r', 'DisplayName', ['Boundary, fl\_val = ', num2str(unique_fl_val(i))]);
            hold on;

            % Plot domain data with blue color
            domain_plot(i) = plot(freq_i, displacement_domain_i, 'b', 'DisplayName', ['Domain, fl\_val = ', num2str(unique_fl_val(i))]);

            % Set y-axis limits
            ylim([0, max_amplitude]);

            % Add labels and title for each plot
            xlabel('Frequency');
            ylabel('Amplitude');
            title(['Frequency vs Displacement Fields for fl\_val = ', num2str(unique_fl_val(i))]);
            if lgd
                legend([boundary_plot(i), domain_plot(i)], 'Location', 'best');
            end
        end
    end

    %% Aggregate Displacement Domain Data for Each Frequency

    if agr_tf_plotting == true

        % Initialize variables to store aggregated displacement domain data
        aggregated_freq = unique(freq);
        aggregated_displacement_domain = zeros(size(aggregated_freq));

        % Loop over each unique frequency
        for i = 1:numel(aggregated_freq)
            % Find indices corresponding to the current frequency
            indices = freq == aggregated_freq(i);

            % Sum up displacement domain data for the current frequency
            aggregated_displacement_domain(i) = sum(displacement_domain(indices));
        end

        % Plot Aggregated Displacement Domain Data

        % Create a new figure
        figure;

        % Plot aggregated displacement domain data
        if ~view_first_last
            plot(aggregated_freq, aggregated_displacement_domain, 'k', 'DisplayName', 'Aggregated Displacement Domain');
        end

        % Add labels and title
        xlabel('Frequency');
        ylabel('Total Displacement Domain');
        title('Total Displacement Domain vs Frequency');
    %     legend('Location', 'best');

        % Check if component view is enabled
        if comp_view || (view_first_last && ~comp_view)
            hold on; % Hold the current axes for overlaying plots

            % Loop over each unique fl_val to plot the data on top of aggregated graph
            if view_first_last
                % Only view the first and last graphs
                freq_i_first = freq(fl_val == unique_fl_val(1));
                displacement_domain_i_first = displacement_domain(fl_val == unique_fl_val(1));
                plot(freq_i_first, displacement_domain_i_first, 'DisplayName', ['Domain, fl\_val = ', num2str(unique_fl_val(1))]);

                freq_i_last = freq(fl_val == unique_fl_val(end));
                displacement_domain_i_last = displacement_domain(fl_val == unique_fl_val(end));
                plot(freq_i_last, displacement_domain_i_last, 'DisplayName', ['Domain, fl\_val = ', num2str(unique_fl_val(end))]);

                % Plot aggregated displacement domain data on top
                if ~isempty(aggregated_displacement_domain)
                    plot(aggregated_freq, aggregated_displacement_domain, 'k', 'DisplayName', 'Aggregated Displacement Domain');
                end
            else
                % View all graphs
                for i = 1:numel(unique_fl_val)
                    % Get frequency and displacement data for the current fl_val
                    freq_i = freq(fl_val == unique_fl_val(i));
                    displacement_domain_i = displacement_domain(fl_val == unique_fl_val(i));

                    % Plot domain data for each fl_val
                    plot(freq_i, displacement_domain_i, 'DisplayName', ['Domain, fl\_val = ', num2str(unique_fl_val(i))]);
                end

                % Plot aggregated displacement domain data
                if ~isempty(aggregated_displacement_domain)
                    plot(aggregated_freq, aggregated_displacement_domain, 'k', 'DisplayName', 'Aggregated Displacement Domain');
                end
            end
            
            if mov_mean > 0
                % Apply moving mean to smooth the aggregated graph
                aggregated_displacement_domain = movmean(aggregated_displacement_domain, mov_mean);
                plot(aggregated_freq, aggregated_displacement_domain, 'r', 'LineWidth', 2, 'DisplayName', ['Smoothed Aggregated Displacement Domain (mov\_mean = ', num2str(mov_mean), ')']);
            end

            hold off; % Release the hold
        end
        
        if lgd
            legend('Location', 'best');
        end
    end
end

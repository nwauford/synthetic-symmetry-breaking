function out = func_fig2_rep1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %                              
%                           By Noreen Wauford                         %
%                   using pipeline by Breanna DiAndreth               %               
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usrC = strsplit(pwd,'/');
currpath =strjoin(usrC,'/');

flow_analysis_code_path = ['/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/Flow/Analysis/release 3 pipeline'];

if strcmp(currpath(end-4:end), 'rep 1')
    data_path = [currpath '/'];
else
    data_path = [currpath '/Fig 2 rep 1/'];
end

% Define working colors used in the experiment:
% Single-color control files:

SC_files={[data_path 'TrypMedia_EXP8lasers_B_080.fcs'], [data_path 'TrypMedia_EXP8lasers_Y_081.fcs'],  [data_path 'TrypMedia_EXP8lasers_R_082.fcs']};


% Which channel to measure them in (give unique identifiers as all or part of channel name in the same order:
channel_names = {'Pacific Blue-A', 'FITC-A', 'PE-A'};
% Give the channels unique variable names in the same order to assign them
% sub-indexes of subdata
[chB, chY, chR] = subsref(num2cell([1:numel(channel_names)]), substruct('{}', {1:numel(channel_names)}));


%% set up gating, control and compensation and save in metadata
addpath(genpath(flow_analysis_code_path))
format shortg

% create a morphology gate to identify live cells using non-transfected
% cells control file
my_morpho_gate = createMorphoGate(SC_files{1});

chIDs = getChannelNum(SC_files{1},channel_names);

% get channel numbers for those that will be used in this experiment
channelIDs = getChannelNum(SC_files{1},channel_names);

% calculate the compensation parameters that will be used to matrix
% compensate data
[AF, comp_matrix]= calcCompCoeffs(SC_files,channelIDs,my_morpho_gate);



%% analysis

% change this to 0 to use previous GMM fit, or 1 to re-fit
refit_gmm = 0;

frac_r_only = zeros(8,8);
frac_b_only = zeros(8,8);
frac_y_only = zeros(8,8);

all_wells = zeros(0,3);


% flow plotting parameters

dot_size = 0.08;
transparency = 0.8;
cells_to_plot = 2820;
cells_to_plot_3d = 1000;
            
r_color = [192, 82, 97]./255;
y_color = [255,185,15]./255;
b_color = [0,154,205]./255;

if refit_gmm
    
    % create array of .fcs file names
    
    myFiles = dir(fullfile(data_path,'*.fcs'));
    
    % combine all wells into one array
    
    for s = 1:length(myFiles)
        if strcmp(myFiles(s).name(1:3), 'Spe')
            dat_raw = getflowdata([data_path myFiles(s).name],channelIDs, my_morpho_gate);
               dat_comp = compensate(dat_raw,AF,comp_matrix);

               all_wells = [all_wells;dat_comp];
        end
    end


    % fit GMM to all wells combined

    GMModel_All = fitgmdist(lin2logicle(all_wells(:, :)),3);


    % sample 10,000 random cells

    all_well_subset = all_wells(randsample(length(all_wells), 10000), :);

    % cluster them by GMM

    cluster_all = cluster(GMModel_All,lin2logicle(all_well_subset(:, :)));

    i_1 = cluster_all == 1;
    c_1 = all_well_subset(i_1, :);

    i_2 = cluster_all == 2;
    c_2 = all_well_subset(i_2, :);

    i_3 = cluster_all == 3;
    c_3 = all_well_subset(i_3, :);

    [m, i_max_1] = max(mean(c_1, 1));
    [m, i_max_2] = max(mean(c_2, 1));
    [m, i_max_3] = max(mean(c_3, 1));

    % label clusters by channel
    if i_max_1 == 3
       i_r_only = cluster_all == 1;
       r_only = all_well_subset(i_r_only, :);
    elseif i_max_2 == 3
       i_r_only = cluster_all == 2;
       r_only = all_well_subset(i_r_only, :);
    else
       i_r_only = cluster_all == 3;
       r_only = all_well_subset(i_r_only, :);
    end

    if i_max_1 == 2
       i_y_only = cluster_all == 1;
       y_only = all_well_subset(i_y_only, :);
    elseif i_max_2 == 2
       i_y_only = cluster_all == 2;
       y_only = all_well_subset(i_y_only, :);
    else
       i_y_only = cluster_all == 3;
       y_only = all_well_subset(i_y_only, :);
    end

    if i_max_1 == 1
       i_b_only = cluster_all == 1;
       b_only = all_well_subset(i_b_only, :);
    elseif i_max_2 == 1
       i_b_only = cluster_all == 2;
       b_only = all_well_subset(i_b_only, :);
    else
       i_b_only = cluster_all == 3;
       b_only = all_well_subset(i_b_only, :);
    end

    % 3D scatter plot of GMM populations

    fig = figure;
    scatter3(lin2logicle(r_only(:,chR)),lin2logicle(r_only(:,chY)),lin2logicle(r_only(:,chB)),dot_size, r_color,'.');
    hold on
    scatter3(lin2logicle(y_only(:,chR)),lin2logicle(y_only(:,chY)),lin2logicle(y_only(:,chB)), dot_size, y_color,'.');
    scatter3(lin2logicle(b_only(:,chR)),lin2logicle(b_only(:,chY)), lin2logicle(b_only(:,chB)), dot_size, b_color, '.');

    box on
    biexpaxis_self_scaling(gca)
    view(163,10)
    xlabel('mKate (a.u.)')
    ylabel('EYFP (a.u.)')
    zlabel('EBFP (a.u.)')

    figname = 'rep1_3D_GMM_dists.png';
    saveas(fig,figname,'png')
    title('\fontsize{20}Replicate 1')

    azimuth = linspace(163, -197, 100);
    ViewZ = [azimuth; ones(1, 100).*10]';
    CaptureFigVid(ViewZ, 'rep1_Rotating_3D_GMM_Dists')
    
    % create arrays for saving GMM fits
    b_only_wells_r1 = ones(50000, 3, 64) .* NaN;
    y_only_wells_r1 = ones(50000, 3, 64) .* NaN;
    r_only_wells_r1 = ones(50000, 3, 64) .* NaN;
    b_only_subsets_r1 = ones(2820, 3, 64) .* NaN;
    y_only_subsets_r1 = ones(2820, 3, 64) .* NaN;
    r_only_subsets_r1 = ones(2820, 3, 64) .* NaN;


else
    load('b_only_wells_r1.mat')
    load('y_only_wells_r1.mat')
    load('r_only_wells_r1.mat')
    load('b_only_subsets_r1.mat')
    load('y_only_subsets_r1.mat')
    load('r_only_subsets_r1.mat')
end



% create 8x8 figure to display R vs Y flow plots

fig_ry = figure;
ha_ry = tight_subplot(8,8,[0.005 0.005],[.05 .05],[0.02 0.02]);
set(gcf, 'Position', [24 1 855 796])

% create 8x8 figure to display B vs Y flow plots

fig_by = figure;
ha_by = tight_subplot(8,8,[0.005 0.005],[.05 .05],[0.02 0.02]);
set(gcf, 'Position', [24 1 855 796])

% create 8x8 figure to display B vs R flow plots

fig_br = figure;
ha_br = tight_subplot(8,8,[0.005 0.005],[.05 .05],[0.02 0.02]);
set(gcf, 'Position', [24 1 855 796])

% create 8x8 figure to display 3D flow plots

fig_3d = figure;
ha_3d = tight_subplot(8,8,[0.005 0.005],[.05 .05],[0.02 0.02]);
set(gcf, 'Position', [24 1 855 796])

 for i = 1:64
    if refit_gmm
        for s = 1:length(myFiles)
            if str2num(myFiles(s).name(end-5:end-4)) == i
                            
                myFiles(s).name

               dat_raw = getflowdata([data_path myFiles(s).name],channelIDs, my_morpho_gate);
               dat_comp = compensate(dat_raw,AF,comp_matrix);

               % threshold by GMM

               cluster_all = cluster(GMModel_All,lin2logicle(dat_comp(:, :)));


               % label clusters by channel
               
               if i_max_1 == 3
                   i_r_only = cluster_all == 1;
                   r_only = dat_comp(i_r_only, :);
               elseif i_max_2 == 3
                   i_r_only = cluster_all == 2;
                   r_only = dat_comp(i_r_only, :);
               else
                   i_r_only = cluster_all == 3;
                   r_only = dat_comp(i_r_only, :);
               end

               if i_max_1 == 2
                   i_y_only = cluster_all == 1;
                   y_only = dat_comp(i_y_only, :);
               elseif i_max_2 == 2
                   i_y_only = cluster_all == 2;
                   y_only = dat_comp(i_y_only, :);
               else
                   i_y_only = cluster_all == 3;
                   y_only = dat_comp(i_y_only, :);
               end

               if i_max_1 == 1
                   i_b_only = cluster_all == 1;
                   b_only = dat_comp(i_b_only, :);
               elseif i_max_2 == 1
                   i_b_only = cluster_all == 2;
                   b_only = dat_comp(i_b_only, :);
               else
                   i_b_only = cluster_all == 3;
                   b_only = dat_comp(i_b_only, :);
               end
               
               b_only_wells_r1(1:length(b_only), :, i) = b_only;
               y_only_wells_r1(1:length(y_only), :, i) = y_only;
               r_only_wells_r1(1:length(r_only), :, i) = r_only;
               
            end
        end
    else
                
                b_only = b_only_wells_r1(:, :, i);
                b_only = b_only(~isnan(b_only));
                dim1 = length(b_only) / 3;
                b_only = reshape(b_only, [dim1, 3]);
                
                y_only = y_only_wells_r1(:, :, i);
                y_only = y_only(~isnan(y_only));
                dim1 = length(y_only) / 3;
                y_only = reshape(y_only, [dim1, 3]);
                
                r_only = r_only_wells_r1(:, :, i);
                r_only = r_only(~isnan(r_only));
                dim1 = length(r_only) / 3;
                r_only = reshape(r_only, [dim1, 3]);
    end
           
           
           
           % count fractions in each population
           
           total_r = length(r_only);
            total_y = length(y_only);
            total_b = length(b_only);

            total_all = total_r + total_y + total_b;
            
             total_all = total_r + total_y + total_b;
            
            f_r = total_r / total_all;
            f_y = total_y / total_all;
            f_b = total_b / total_all;


            x_ind = floor(i / 8) + 1;
            y_ind = rem(i, 8);
            if y_ind == 0
                x_ind = x_ind - 1;
                y_ind = 8;
            end

            frac_r_only(x_ind, y_ind) = f_r;
            frac_y_only(x_ind, y_ind) = f_y;
            frac_b_only(x_ind, y_ind) = f_b;
            
           
           % plot same number of cells in each subplot
           

            if refit_gmm
            
                dat_comp = dat_comp(1:cells_to_plot, :);
                
                % threshold by GMM

               cluster_all = cluster(GMModel_All,lin2logicle(dat_comp(:, :)));


               % label clusters by channel
               
               if i_max_1 == 3
                   i_r_only = cluster_all == 1;
                   r_only_subset = dat_comp(i_r_only, :);
               elseif i_max_2 == 3
                   i_r_only = cluster_all == 2;
                   r_only_subset = dat_comp(i_r_only, :);
               else
                   i_r_only = cluster_all == 3;
                   r_only_subset = dat_comp(i_r_only, :);
               end

               if i_max_1 == 2
                   i_y_only = cluster_all == 1;
                   y_only_subset = dat_comp(i_y_only, :);
               elseif i_max_2 == 2
                   i_y_only = cluster_all == 2;
                   y_only_subset = dat_comp(i_y_only, :);
               else
                   i_y_only = cluster_all == 3;
                   y_only_subset = dat_comp(i_y_only, :);
               end

               if i_max_1 == 1
                   i_b_only = cluster_all == 1;
                   b_only_subset = dat_comp(i_b_only, :);
               elseif i_max_2 == 1
                   i_b_only = cluster_all == 2;
                   b_only_subset = dat_comp(i_b_only, :);
               else
                   i_b_only = cluster_all == 3;
                   b_only_subset = dat_comp(i_b_only, :);
               end
               
               b_only_subsets_r1(1:length(b_only_subset), :, i) = b_only_subset;
               y_only_subsets_r1(1:length(y_only_subset), :, i) = y_only_subset;
               r_only_subsets_r1(1:length(r_only_subset), :, i) = r_only_subset;

               
            else
                b_only_subset = b_only_subsets_r1(:, :, i);
                b_only_subset = b_only_subset(~isnan(b_only_subset));
                dim1 = length(b_only_subset) / 3;
                b_only_subset = reshape(b_only_subset, [dim1, 3]);
                
                y_only_subset = y_only_subsets_r1(:, :, i);
                y_only_subset = y_only_subset(~isnan(y_only_subset));
                dim1 = length(y_only_subset) / 3;
                y_only_subset = reshape(y_only_subset, [dim1, 3]); 
                
                r_only_subset = r_only_subsets_r1(:, :, i);
                r_only_subset = r_only_subset(~isnan(r_only_subset));
                dim1 = length(r_only_subset) / 3;
                r_only_subset = reshape(r_only_subset, [dim1, 3]);
            end
            
            
                
                length_all = length(r_only_subset) + length(y_only_subset) + length(b_only_subset);
                
                num_r = round(length(r_only_subset) / length_all * cells_to_plot_3d);
                num_y = round(length(y_only_subset) / length_all * cells_to_plot_3d);
                num_b = cells_to_plot_3d - num_r - num_y;
                
               r_only_subset_3d = datasample(r_only_subset, num_r, 1);
               y_only_subset_3d = datasample(y_only_subset, num_y, 1);
               b_only_subset_3d = datasample(b_only_subset, num_b, 1);
                     
%          %  subplot R vs Y


           axes(ha_ry(i))
            hold on
            a = scatter(lin2logicle(r_only_subset(:,chR)),lin2logicle(r_only_subset(:,chY)),'Marker', 'o', 'MarkerEdgeAlpha', transparency);
            a.SizeData = dot_size;
            a.CData = r_color;
            b = scatter(lin2logicle(y_only_subset(:,chR)),lin2logicle(y_only_subset(:,chY)),'Marker', 'o',  'MarkerEdgeAlpha', transparency);
            b.SizeData = dot_size;
            b.CData = y_color;
            c = scatter(lin2logicle(b_only_subset(:,chR)),lin2logicle(b_only_subset(:,chY)), 'Marker', 'o',  'MarkerEdgeAlpha', transparency);
            c.SizeData = dot_size;
            c.CData = b_color;
            box on
            biexpaxis_nogrid(gca)
            set(ha_ry(i),['x', 'ticklabel'],{},['y', 'ticklabel'],{});
            
            % subplot B vs Y
           axes(ha_by(i))
            hold on
              a = scatter(lin2logicle(r_only_subset(:,chB)),lin2logicle(r_only_subset(:,chY)),'Marker', 'o', 'MarkerEdgeAlpha', transparency);
            a.SizeData = dot_size;
            a.CData = r_color;
            b = scatter(lin2logicle(y_only_subset(:,chB)),lin2logicle(y_only_subset(:,chY)),'Marker', 'o',  'MarkerEdgeAlpha', transparency);
            b.SizeData = dot_size;
            b.CData = y_color;
            c = scatter(lin2logicle(b_only_subset(:,chB)),lin2logicle(b_only_subset(:,chY)), 'Marker', 'o',  'MarkerEdgeAlpha', transparency);
            c.SizeData = dot_size;
            c.CData = b_color;
            box on
            biexpaxis_nogrid(gca)
            set(ha_by(i),['x', 'ticklabel'],{},['y', 'ticklabel'],{});
            
            % subplot B vs R
           axes(ha_br(i))
            hold on
              a = scatter(lin2logicle(r_only_subset(:,chB)),lin2logicle(r_only_subset(:,chR)),'Marker', 'o', 'MarkerEdgeAlpha', transparency);
            a.SizeData = dot_size;
            a.CData = r_color;
            b = scatter(lin2logicle(y_only_subset(:,chB)),lin2logicle(y_only_subset(:,chR)),'Marker', 'o',  'MarkerEdgeAlpha', transparency);
            b.SizeData = dot_size;
            b.CData = y_color;
            c = scatter(lin2logicle(b_only_subset(:,chB)),lin2logicle(b_only_subset(:,chR)), 'Marker', 'o',  'MarkerEdgeAlpha', transparency);
            c.SizeData = dot_size;
            c.CData = b_color;
            box on
            biexpaxis_nogrid(gca)
            set(ha_br(i),['x', 'ticklabel'],{},['y', 'ticklabel'],{});
            
            %   subplot 3D

            dot_size_3d = .0001;

           axes(ha_3d(i))
            hold on
              a = scatter3((r_only_subset_3d(:,chR)),(r_only_subset_3d(:,chY)),(r_only_subset_3d(:,chB)),dot_size_3d, r_color,'.');

                    hold on
                    scatter3((y_only_subset_3d(:,chR)),(y_only_subset_3d(:,chY)),(y_only_subset_3d(:,chB)), dot_size_3d, y_color,'.');
                    scatter3((b_only_subset_3d(:,chR)),(b_only_subset_3d(:,chY)), (b_only_subset_3d(:,chB)), dot_size_3d, b_color, '.');

                    box on
                    xlim([10^2 2 * 10^4])
                    ylim([10^2 10^5])
                    zlim([10^2 2 * 10^4])
                    set(gca,'xscale','log')
                    set(gca,'yscale','log')
                    set(gca,'zscale','log')

                    view(126,11)

            set(ha_3d(i),['x', 'ticklabel'],{},['y', 'ticklabel'],{}, ['z', 'ticklabel'],{});
           

           
  

 end
 
%   min_size
%  error()

 
 if refit_gmm
     save('b_only_wells_r1.mat', 'b_only_wells_r1')
     save('y_only_wells_r1.mat', 'y_only_wells_r1')
     save('r_only_wells_r1.mat', 'r_only_wells_r1')
     save('b_only_subsets_r1.mat', 'b_only_subsets_r1')
     save('y_only_subsets_r1.mat', 'y_only_subsets_r1')
     save('r_only_subsets_r1.mat', 'r_only_subsets_r1')
 end
 
%  min_size
 
  figname = 'rep1_r_vs_y.png';
saveas(fig_ry,figname,'png')

  figname = 'rep1_b_vs_y.png';
saveas(fig_by,figname,'png')

  figname = 'rep1_b_vs_r.png';
saveas(fig_br,figname,'png')

hmfontsize = 20;
 
fig=figure;
 set(fig,'color','w');
 hm = heatmap(frac_r_only .* 100, 'CellLabelColor','white');
 title('Fraction R+ Y- B- Replicate 1')
 colormap viridis
 hm.CellLabelFormat = '%0.0f';
 hm.FontSize = hmfontsize;
 colorbar
 figname = 'rep1_red_only_heatmap.png';
 hm.GridVisible = 'off';
 caxis([0, 100]);
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
 hm = heatmap(frac_y_only .* 100, 'CellLabelColor','white');
  title('Fraction Y+ R- B- Replicate 1')
  colormap viridis
   hm.CellLabelFormat = '%0.0f';
   hm.FontSize = hmfontsize;
   hm.GridVisible = 'off';
   caxis([0, 100]);
  colorbar
   figname = 'rep1_yellow_only_heatmap.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
 hm = heatmap(frac_b_only .* 100, 'CellLabelColor','white');
  title('Fraction B+ R- Y- Replicate 1')
  colormap viridis
  colorbar
   hm.CellLabelFormat = '%0.0f';
   hm.FontSize = hmfontsize;
    hm.GridVisible = 'off';
    caxis([0, 100]);
   figname = 'rep1_blue_only_heatmap.png';
saveas(fig,figname,'png')

save('rep1_r_frac.mat', 'frac_r_only')
save('rep1_b_frac.mat', 'frac_b_only')
save('rep1_y_frac.mat', 'frac_y_only')


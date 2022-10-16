function out = func_mCE40m4_12_all_GMM

usrC = strsplit(pwd,'/');

flow_analysis_code_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/Flow/Analysis/release 3 pipeline'];

data_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/Flow/mCE40m4_012/'];

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
refit_gmm = 1;

frac_r_only = zeros(8,8);
frac_b_only = zeros(8,8);
frac_y_only = zeros(8,8);

all_wells = zeros(0,3);


% flow plotting parameters

dot_size = 0.08;
transparency = 0.8;
cells_to_plot = 2820;
            
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

    figname = 'exp12_3D_GMM_dists.png';
    saveas(fig,figname,'png')
    title('\fontsize{20}Replicate 1')

    azimuth = linspace(163, -197, 100);
    ViewZ = [azimuth; ones(1, 100).*10]';
    CaptureFigVid(ViewZ, 'exp12_Rotating_3D_GMM_Dists')
    
    % create arrays for saving GMM fits
    b_only_wells = ones(50000, 3, 64) .* NaN;
    y_only_wells = ones(50000, 3, 64) .* NaN;
    r_only_wells = ones(50000, 3, 64) .* NaN;
    b_only_subsets = ones(2820, 3, 64) .* NaN;
    y_only_subsets = ones(2820, 3, 64) .* NaN;
    r_only_subsets = ones(2820, 3, 64) .* NaN;


else
    load('b_only_wells.mat')
    load('y_only_wells.mat')
    load('r_only_wells.mat')
    load('b_only_subsets.mat')
    load('y_only_subsets.mat')
    load('r_only_subsets.mat')
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

% min_size = Inf;


 for i = 1:64
    if refit_gmm
        for s = 1:length(myFiles)
            if str2num(myFiles(s).name(end-5:end-4)) == i
                            
                myFiles(s).name

               dat_raw = getflowdata([data_path myFiles(s).name],channelIDs, my_morpho_gate);
               dat_comp = compensate(dat_raw,AF,comp_matrix);
           

    %            if length(dat_comp) < min_size
    %                min_size = length(dat_comp);
    %            end



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
               
               b_only_wells(1:length(b_only), :, i) = b_only;
               y_only_wells(1:length(y_only), :, i) = y_only;
               r_only_wells(1:length(r_only), :, i) = r_only;
               
            end
        end
    else
                
                b_only = b_only_wells(:, :, i);
                b_only = b_only(~isnan(b_only));
                dim1 = length(b_only) / 3;
                b_only = reshape(b_only, [dim1, 3]);
                
                y_only = y_only_wells(:, :, i);
                y_only = y_only(~isnan(y_only));
                dim1 = length(y_only) / 3;
                y_only = reshape(y_only, [dim1, 3]);
                
                r_only = r_only_wells(:, :, i);
                r_only = r_only(~isnan(r_only));
                dim1 = length(r_only) / 3;
                r_only = reshape(r_only, [dim1, 3]);
    end
           
           
           
           % count fractions in each population
           
           total_r = length(r_only);
            total_y = length(y_only);
            total_b = length(b_only);

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
            
                      % plot example cases in 3D
          if refit_gmm & (i == 1 || i == 57 || i == 30 || i == 64)
                  
              dat_comp = dat_comp(1:5000, :);
              dot_size_3d = .0008;
              
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
               
                
                  fig = figure;

                    scatter3((r_only(:,chR)),(r_only(:,chY)),(r_only(:,chB)),dot_size_3d, r_color,'.');
                    hold on
                    scatter3((y_only(:,chR)),(y_only(:,chY)),(y_only(:,chB)), dot_size_3d, y_color,'.');
                    scatter3((b_only(:,chR)),(b_only(:,chY)), (b_only(:,chB)), dot_size_3d, b_color, '.');

                    box on
                    xlim([10^2 2 * 10^4])
                    ylim([10^2 10^5])
                    zlim([10^2 2 * 10^4])
                    set(gca,'xscale','log')
                    set(gca,'yscale','log')
                    set(gca,'zscale','log')
                    xticks([10^2 10^3 10^4])
                    xticks([10^2 10^3 10^4])
                    xticks([10^2 10^3 10^4])
%                     set(gca,'XMinorTick','off','YMinorTick','off', 'ZMinorTick','off')
%                     biexpaxis_self_scaling(gca)
%                     view(163,10)
%                     view(124,22)
                    view(126,11)
%                     view(122,20)
                    xlabel('mKate (a.u.)')
                    ylabel('EYFP (a.u.)')
                    zlabel('EBFP (a.u.)')
                    title(['3D scatter well ', num2str(i)])
                    set(gcf, 'Position', [320 307 325 289])
                       figname = ['3D scatter well ', num2str(i)];
                    saveas(fig,figname,'png')
          end

           
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
               
               b_only_subsets(1:length(b_only_subset), :, i) = b_only_subset;
               y_only_subsets(1:length(y_only_subset), :, i) = y_only_subset;
               r_only_subsets(1:length(r_only_subset), :, i) = r_only_subset;
            else
                b_only_subset = b_only_subsets(:, :, i);
                b_only_subset = b_only_subset(~isnan(b_only_subset));
                dim1 = length(b_only_subset) / 3;
                b_only_subset = reshape(b_only_subset, [dim1, 3]);
                
                y_only_subset = y_only_subsets(:, :, i);
                y_only_subset = y_only_subset(~isnan(y_only_subset));
                dim1 = length(y_only_subset) / 3;
                y_only_subset = reshape(y_only_subset, [dim1, 3]); 
                
                r_only_subset = r_only_subsets(:, :, i);
                r_only_subset = r_only_subset(~isnan(r_only_subset));
                dim1 = length(r_only_subset) / 3;
                r_only_subset = reshape(r_only_subset, [dim1, 3]);
            end
            
                     
%          %  subplot R vs Y

%           length(r_only_subset) + length(b_only_subset) + length(y_only_subset)

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
           

           
  

 end
 
 if refit_gmm
     save('b_only_wells.mat', 'b_only_wells')
     save('y_only_wells.mat', 'y_only_wells')
     save('r_only_wells.mat', 'r_only_wells')
     save('b_only_subsets.mat', 'b_only_subsets')
     save('y_only_subsets.mat', 'y_only_subsets')
     save('r_only_subsets.mat', 'r_only_subsets')
 end
 
%  min_size
 
  figname = 'exp12_r_vs_y.png';
saveas(fig_ry,figname,'png')

  figname = 'exp12_b_vs_y.png';
saveas(fig_by,figname,'png')

  figname = 'exp12_b_vs_r.png';
saveas(fig_br,figname,'png')
 
fig=figure;
 set(fig,'color','w');
 hm = heatmap(frac_r_only .* 100, 'CellLabelColor','white');
 title('Fraction R+ Y- B- Exp 12')
 colormap viridis
 hm.CellLabelFormat = '%0.0f';
 colorbar
 figname = 'exp12_red_only_heatmap.png';
 hm.GridVisible = 'off';
 caxis([0, 100]);
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
 hm = heatmap(frac_y_only .* 100, 'CellLabelColor','white');
  title('Fraction Y+ R- B- Exp 12')
  colormap viridis
   hm.CellLabelFormat = '%0.0f';
   hm.GridVisible = 'off';
   caxis([0, 100]);
  colorbar
   figname = 'exp12_yellow_only_heatmap.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
 hm = heatmap(frac_b_only .* 100, 'CellLabelColor','white');
  title('Fraction B+ R- Y- Exp 12')
  colormap viridis
  colorbar
   hm.CellLabelFormat = '%0.0f';
    hm.GridVisible = 'off';
    caxis([0, 100]);
   figname = 'exp12_blue_only_heatmap.png';
saveas(fig,figname,'png')

save('exp12_r_frac.mat', 'frac_r_only')
save('exp12_b_frac.mat', 'frac_b_only')
save('exp12_y_frac.mat', 'frac_y_only')


function out = func_fig1d_rep3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %                              
%                           By Noreen Wauford                         %
%                   using pipeline by Breanna DiAndreth               %               
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usrC = strsplit(pwd,'/');
currpath =strjoin(usrC,'/');

flow_analysis_code_path = ['/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/Flow/Analysis/release 3 pipeline'];

if strcmp(currpath(end-4:end), 'rep 3')
    data_path = [currpath '/'];
else
    data_path = [currpath '/Fig 1D, SI Fig 2-3 rep 3/'];
end

s_B = [data_path 's088_B_008.fcs'];

% Define working colors used in the experiment:
% Single-color control files:
SC_files={[data_path 's088_B_008.fcs'], [data_path 's088_Y_009.fcs'],  [data_path 's088_R_010.fcs'], [data_path 's088_IR_011.fcs']};

% Which channel to measure them in (give unique identifiers as all or part of channel name in the same order:
channel_names = {'Pacific Blue-A','FITC-A','PE-A', 'APC-Alexa 700-A', 'SSC-A'};
channel_names_fluor = {'Pacific Blue-A','FITC-A','PE-A', 'APC-Alexa 700-A'};

% Give the channels unique variable names in the same order to assign them
% sub-indexes of subdata
[chB, chY, chR, chiR, chSSC] = subsref(num2cell([1:numel(channel_names)]), substruct('{}', {1:numel(channel_names)}));


%% set up gating, control and compensation and save in metadata
addpath(genpath(flow_analysis_code_path))
format shortg

% create a morphology gate to identify live cells using non-transfected
% cells control file
my_morpho_gate = createMorphoGate(s_B);

chIDs = getChannelNum(s_B,channel_names);

% get channel numbers for those that will be used in this experiment
channelIDs_fluor = getChannelNum(s_B,channel_names_fluor);

% calculate the compensation parameters that will be used to matrix
% compensate data
[AF, comp_matrix]= calcCompCoeffs(SC_files,channelIDs_fluor,my_morpho_gate);




%% analysis

myFiles = dir(fullfile(data_path,'*.fcs'));

y_thresh=100;
r_thresh=150;
ir_thresh = 1000;
b_lo_thresh = 50;
b_hi_thresh = 300;

fracs_rep3 = zeros(7, 4); % bin; [f_none f_r f_y f_both]
    
for s = 1:length(myFiles)
    if str2num(myFiles(s).name(end-5:end-4))<8
         t = myFiles(s).name
                     
           t_raw = getflowdata([data_path t],channelIDs_fluor, my_morpho_gate);

           t_comp = compensate(t_raw,AF,comp_matrix);
           
           t_ssc = getflowdata([data_path t],chIDs, my_morpho_gate);
           

            i_ir = t_comp(:, chiR) > ir_thresh;
            ir = t_comp(i_ir, :);
            
             i_lo_b = t_comp(:, chB) < b_hi_thresh;
             i_hi_b = t_comp(:, chB) > b_lo_thresh;
            lo_b = t_comp(i_lo_b & i_hi_b, :);
            

                % calculate overall fractions of states
                total_r = 0;
                total_y = 0;
                total_none = 0;
                total_both = 0;


                   i_r = and(lo_b(:, chR) > r_thresh, lo_b(:, chY) < y_thresh);
                    r =lo_b(i_r, :);
                    total_r = total_r + sum(i_r);

                    i_y = and(lo_b(:, chR) < r_thresh, lo_b(:, chY) > y_thresh);
                    y = lo_b(i_y, :);
                    total_y = total_y + sum(i_y);

                    i_none = and(lo_b(:, chR) < r_thresh, lo_b(:, chY) < y_thresh);
                    none = lo_b(i_none, :);
                    total_none = total_none + sum(i_none);

                    i_both = and(lo_b(:, chR) > r_thresh, lo_b(:, chY) > y_thresh);
                    both = lo_b(i_both, :);
                    total_both = total_both + sum(i_both);
                       
                    fig=figure;
                    set(fig,'color','w');
                    plot(lin2logicle(y(:,chY)),lin2logicle(y(:,chR)),'.','color',[1, 0.84314, 0])
                    hold on
                    plot(lin2logicle(r(:,chY)),lin2logicle(r(:,chR)),'.','color',[.86, 0.08, 0.23])
                    plot(lin2logicle(none(:,chY)),lin2logicle(none(:,chR)),'.','color',[.7 .7 .7])
                    plot(lin2logicle(both(:,chY)),lin2logicle(both(:,chR)),'.','color',[.3 .3 .3])
                    box on
                    biexpaxis(gca)
                    xlabel({'','EYFP [a.u.]'},'FontSize',15)
                    ylabel({'mKate [a.u.]',''},'FontSize',15)
                    title(['Replicate 3 R vs Y in EBFP- cells condition ' t(9)])
                    filename = ['Replicate 3 R vs Y in EBFP- cells condition ' t(9)];
                     saveas(fig, filename, 'png');
                    
                     total_all = double(length(lo_b));
                     f_r = sum(i_r) / total_all;
                     f_y = sum(i_y) / total_all;
                     f_none =  sum(i_none) / total_all;
                     f_both = sum(i_both) / total_all;
                     
                     fracs_rep3(str2num(t(9)), :) = [f_none f_r f_y f_both];
                     
                     t_comp_subset = t_comp(1:2000,:);
                     
                     i_lo_b_s = t_comp_subset(:, chB) < b_hi_thresh;
                        lo_b_s = t_comp_subset(i_lo_b_s , :);
                        
                        i_hi_b_s = t_comp_subset(:, chB) > b_hi_thresh;
                        hi_b_s = t_comp_subset(i_hi_b_s , :);
                        
                        t_ssc_subset = t_ssc(1:2000,:);
                     
                        lo_b_ssc = t_ssc_subset(i_lo_b_s , :);
                        
                        hi_b_ssc = t_ssc_subset(i_hi_b_s , :);
                        
                        [n, c] = hist3([t_ssc_subset(:,chSSC), t_comp_subset(:,chB)]);
                     
                     fig=figure;
                    set(fig,'color','w');
                    plot(lin2logicle(lo_b_ssc(:,chSSC)),lin2logicle(lo_b_s(:,chB)),'.', 'color', [.7 .7 .7])
                    hold on
                    plot(lin2logicle(hi_b_ssc(:,chSSC)),lin2logicle(hi_b_s(:,chB)),'.', 'color', 'blue')
                    contour(c{1}', c{2}', n)
                    box on
                    biexpaxis(gca)
                    xlabel({'','SSC [a.u.]'},'FontSize',15)
                    ylabel({'EBFP [a.u.]',''},'FontSize',15)
                    title(['Replicate 3 B vs SSC condition ' t(9)])
                    filename = ['Replicate 3 B vs SSC condition ' t(9)];
                     saveas(fig, filename, 'png');
                    
                    
                    
                    
                    end
    
end

save('fracs_rep3.mat', 'fracs_rep3')



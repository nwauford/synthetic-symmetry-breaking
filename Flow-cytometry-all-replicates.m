function out = exp12_13_14_analysis

usrC = strsplit(pwd,'/');

flow_analysis_code_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/Flow/Analysis/release 3 pipeline'];

data_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/Flow/mCE40m4 12-14/'];


%% analysis

exp12b = load('exp12_b_frac.mat');
exp12y =     load('exp12_y_frac.mat');
exp12r =     load('exp12_r_frac.mat');
exp13b =     load('exp13_b_frac.mat');
exp13y =     load('exp13_y_frac.mat');
exp13r =     load('exp13_r_frac.mat');
exp14b =     load('exp14_b_frac.mat');
exp14y =     load('exp14_y_frac.mat');
exp14r =     load('exp14_r_frac.mat');
    
% cat(3, exp12b.frac_b_only, exp13b.frac_b_only, exp14b.frac_b_only)
b_avg = mean(cat(3, exp12b.frac_b_only, exp13b.frac_b_only, exp14b.frac_b_only), 3);
y_avg = mean(cat(3, exp12y.frac_y_only, exp13y.frac_y_only, exp14y.frac_y_only), 3);
r_avg = mean(cat(3, exp12r.frac_r_only, exp13r.frac_r_only, exp14r.frac_r_only), 3);

b_reshape = reshape(b_avg, 1, []);
y_reshape = reshape(y_avg, 1, []);
r_reshape = reshape(r_avg, 1, []);

% avgs = [b_reshape; y_reshape; r_reshape];
% writematrix(avgs, 'average_fractions.xlsx')


b_std = std(cat(3, exp12b.frac_b_only, exp13b.frac_b_only, exp14b.frac_b_only), 0, 3);
y_std = std(cat(3, exp12y.frac_y_only, exp13y.frac_y_only, exp14y.frac_y_only), 0, 3);
r_std = std(cat(3, exp12r.frac_r_only, exp13r.frac_r_only, exp14r.frac_r_only), 0, 3);

'max blue std'
max(b_std, [], 'all')
'max yellow std'
max(y_std, [], 'all')
'max red std'
max(r_std, [], 'all')

   fig=figure;
 set(fig,'color','w');
 scatter(y_avg, r_avg)
  title('Average Y vs R Fractions')
  xlabel('Y fraction')
  ylabel('R fraction')
  
'mean std'
mean(vertcat(b_std, y_std, r_std), 'all')
 
fig=figure;
 set(fig,'color','w');
 image(b_avg .* 255)
 title('Average Fraction R- Y- B+ Exp 12, 13, 14')
 colormap viridis
 colorbar
 figname = 'avg_blue_heatmap.png';
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
 image(y_avg .* 255)
  title('Average Fraction Y+ R- B- Exp 12, 13, 14')
  colormap viridis
  colorbar
   figname = 'avg_yellow_heatmap.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
 image(r_avg .* 255)
  title('Average Fraction B- R+ Y- Exp 12, 13, 14')
  colormap viridis
  colorbar
   figname = 'avg_red_heatmap.png';
saveas(fig,figname,'png')

fig=figure;
 set(fig,'color','w');
 hm = heatmap(b_avg .* 100, 'CellLabelColor','white');
 title('Average Fraction R- Y- B+ Exp 12, 13, 14')
 colormap viridis
 colorbar
       hm.CellLabelFormat = '%0.1f';
   caxis([0, 100]);
    hm.GridVisible = 'off';
 figname = 'avg_blue_heatmap_labels.png';
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
 hm = heatmap(y_avg .* 100, 'CellLabelColor','white');
 title('Average Fraction Y+ R- B- Exp 12, 13, 14')
  colormap viridis
  colorbar
        hm.CellLabelFormat = '%0.1f';
   caxis([0, 100]);
    hm.GridVisible = 'off';
   figname = 'avg_yellow_heatmap_labels.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
 hm = heatmap(r_avg .* 100, 'CellLabelColor','white');
  title('Average Fraction B- R+ Y- Exp 12, 13, 14')
  colormap viridis
  colorbar
      hm.CellLabelFormat = '%0.1f';
   caxis([0, 100]);
    hm.GridVisible = 'off';
   figname = 'avg_red_heatmap_labels.png';
saveas(fig,figname,'png')


fig=figure;
 set(fig,'color','w');
 hm = heatmap(b_std .* 100, 'CellLabelColor','white');
%  title('Std Dev of Fraction R- Y- B+ Exp 12, 13, 14 (color max 0.2)')
 colormap viridis
 colorbar
    hm.CellLabelFormat = '%0.1f';
   caxis([0, 10]);
    hm.GridVisible = 'off';
 figname = 'std_blue_heatmap.png';
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
hm = heatmap(y_std .* 100, 'CellLabelColor','white');
%   title('Std Dev of Fraction Y+ R- B- Exp 12, 13, 14 (color max 0.2)')
  colormap viridis
  colorbar
     hm.CellLabelFormat = '%0.1f';
   caxis([0, 10]);
    hm.GridVisible = 'off';
   figname = 'std_yellow_heatmap.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
hm = heatmap(r_std .* 100, 'CellLabelColor','white');
%   title('Std Dev of Fraction B- R+ Y- Exp 12, 13, 14 (color max 0.2)')
  colormap viridis
  colorbar
     hm.CellLabelFormat = '%0.1f';
   caxis([0, 10]);
    hm.GridVisible = 'off';
   figname = 'std_red_heatmap.png';
saveas(fig,figname,'png')

end
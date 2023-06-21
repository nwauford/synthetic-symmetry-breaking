function out = func_fig2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %                              
%                           By Noreen Wauford                         %
%                   using pipeline by Breanna DiAndreth               %               
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usrC = strsplit(pwd,'/');
currpath =strjoin(usrC,'/');

flow_analysis_code_path = ['/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/Flow/Analysis/release 3 pipeline'];

data_path = [currpath '/'];

addpath(genpath(flow_analysis_code_path))
format shortg

addpath([data_path 'Fig 2 rep 1'])
addpath([data_path 'Fig 2 rep 2'])
addpath([data_path 'Fig 2 rep 3'])

%% analysis

func_fig2_rep1()
func_fig2_rep2()
func_fig2_rep3()

r1b =     load('rep1_b_frac.mat');
r1y =     load('rep1_y_frac.mat');
r1r =     load('rep1_r_frac.mat');
r2b =     load('rep2_b_frac.mat');
r2y =     load('rep2_y_frac.mat');
r2r =     load('rep2_r_frac.mat');
r3b =     load('rep3_b_frac.mat');
r3y =     load('rep3_y_frac.mat');
r3r =     load('rep3_r_frac.mat');
    
b_avg = mean(cat(3, r1b.frac_b_only, r2b.frac_b_only, r3b.frac_b_only), 3);
y_avg = mean(cat(3, r1y.frac_y_only, r2y.frac_y_only, r3y.frac_y_only), 3);
r_avg = mean(cat(3, r1r.frac_r_only, r2r.frac_r_only, r3r.frac_r_only), 3);

b_reshape = reshape(b_avg, 1, []);
y_reshape = reshape(y_avg, 1, []);
r_reshape = reshape(r_avg, 1, []);

b_std = std(cat(3, r1b.frac_b_only, r2b.frac_b_only, r3b.frac_b_only), 0, 3);
y_std = std(cat(3, r1y.frac_y_only, r2y.frac_y_only, r3y.frac_y_only), 0, 3);
r_std = std(cat(3, r1r.frac_r_only, r2r.frac_r_only, r3r.frac_r_only), 0, 3);

   fig=figure;
 set(fig,'color','w');
 scatter(y_avg, r_avg)
  title('Average Y vs R Fractions')
  xlabel('Y fraction')
  ylabel('R fraction')

hmfontsize = 20;
 
fig=figure;
 set(fig,'color','w');
 image(b_avg .* 255)
 title('Average Fraction R- Y- B+ ')
 colormap viridis
 colorbar
 figname = 'avg_blue_heatmap.png';
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
 image(y_avg .* 255)
  title('Average Fraction Y+ R- B- ')
  colormap viridis
  colorbar
   figname = 'avg_yellow_heatmap.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
 image(r_avg .* 255)
  title('Average Fraction B- R+ Y- ')
  colormap viridis
  colorbar
   figname = 'avg_red_heatmap.png';
saveas(fig,figname,'png')

fig=figure;
 set(fig,'color','w');
 hm = heatmap(b_avg .* 100, 'CellLabelColor','white');
 title('Average Fraction R- Y- B+ ')
 colormap viridis
 colorbar
       hm.CellLabelFormat = '%0.1f';
       hm.FontSize = hmfontsize;
   caxis([0, 100]);
    hm.GridVisible = 'off';
 figname = 'avg_blue_heatmap_labels.png';
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
 hm = heatmap(y_avg .* 100, 'CellLabelColor','white');
 title('Average Fraction Y+ R- B- ')
  colormap viridis
  colorbar
        hm.CellLabelFormat = '%0.1f';
        hm.FontSize = hmfontsize;
   caxis([0, 100]);
    hm.GridVisible = 'off';
   figname = 'avg_yellow_heatmap_labels.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
 hm = heatmap(r_avg .* 100, 'CellLabelColor','white');
  title('Average Fraction B- R+ Y- ')
  colormap viridis
  colorbar
      hm.CellLabelFormat = '%0.1f';
      hm.FontSize = hmfontsize;
   caxis([0, 100]);
    hm.GridVisible = 'off';
   figname = 'avg_red_heatmap_labels.png';
saveas(fig,figname,'png')


fig=figure;
 set(fig,'color','w');
 hm = heatmap(b_std .* 100, 'CellLabelColor','white');
 title('Std Dev of Fraction R- Y- B+  ')
 colormap viridis
 colorbar
    hm.CellLabelFormat = '%0.1f';
    hm.FontSize = hmfontsize;
   caxis([0, 10]);
    hm.GridVisible = 'off';
 figname = 'std_blue_heatmap.png';
saveas(fig,figname,'png')
 
 fig=figure;
 set(fig,'color','w');
hm = heatmap(y_std .* 100, 'CellLabelColor','white');
  title('Std Dev of Fraction Y+ R- B- ')
  colormap viridis
  colorbar
     hm.CellLabelFormat = '%0.1f';
     hm.FontSize = hmfontsize;
   caxis([0, 10]);
    hm.GridVisible = 'off';
   figname = 'std_yellow_heatmap.png';
saveas(fig,figname,'png')
  
   fig=figure;
 set(fig,'color','w');
hm = heatmap(r_std .* 100, 'CellLabelColor','white');
  title('Std Dev of Fraction B- R+ Y-  ')
  colormap viridis
  colorbar
     hm.CellLabelFormat = '%0.1f';
     hm.FontSize = hmfontsize;
   caxis([0, 10]);
    hm.GridVisible = 'off';
   figname = 'std_red_heatmap.png';
saveas(fig,figname,'png')

end
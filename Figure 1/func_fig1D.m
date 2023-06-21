function out = func_fig1D

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

addpath([data_path 'Fig 1D, SI Fig 2-3 rep 1'])
addpath([data_path 'Fig 1D, SI Fig 2-3 rep 2'])
addpath([data_path 'Fig 1D, SI Fig 2-3 rep 3'])


%% analysis

myColors = [[.75 .75 .75]; [.86, 0.08, 0.23];[1, 0.84314, 0];[.25, 0.25, 0.25]; [0, 0.4470, 0.7410]];

fracs = zeros(7, 3, 4); % bin; replicate; [f_none f_r f_y f_both]

func_fig1d_rep1()
func_fig1d_rep2()
func_fig1d_rep3()

f_rep1 = load('fracs_rep1.mat');
f_rep2 = load('fracs_rep2.mat');
f_rep3 = load('fracs_rep3.mat');

fracs(:, 1, :) = f_rep1.fracs_rep1;
fracs(:, 2, :) = f_rep2.fracs_rep2;
fracs(:, 3, :) = f_rep3.fracs_rep3;

mean_fracs = mean(fracs, 2);
std_fracs = std(fracs, 0, 2);

for k = 1:7
    
     bars = [mean_fracs(k, :); nan(1,4)];

     fig=figure;
    set(fig,'color','w');

   H = bar(bars,'stacked', 'EdgeColor', 'none');
   hold on 

    errorbar(sum((mean_fracs(k, 1))')',std_fracs(k, 1),'.k');
    errorbar(sum((mean_fracs(k, 1:2))')',std_fracs(k, 2),'.k');
    errorbar(sum((mean_fracs(k, 1:3))')',std_fracs(k, 3),'.k');
    errorbar(sum((mean_fracs(k, 1:4))')',std_fracs(k, 4),'.k');

   set(gca,'xtick',1)
   set(gca,'xticklabel',[])
   set(gcf, 'Position', [925 304 113 401]);
   ylabel({'Fraction',''},'FontSize',15)
   xlim([0.5 1.5]);
   title(['Sample ' num2str(k)])
    for i = 1:4
        H(i).FaceColor = 'flat';
        H(i).CData = myColors(i, :);
    end

    filename = ['Sample ' num2str(k), ' bar'];

     saveas(fig, filename, 'png');                
end


function out = func_si_fig_22

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %                              
%                           By Noreen Wauford                         %
%                   using pipeline by Breanna DiAndreth               %               
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = readmatrix('dox_aba_cell_ratios.xlsx');

T(1, :)

props = zeros(64, 3, 3);
% concs, BYR, rep

for i = 1:64
    for j = 2:3
        for k = 1:3
                n = (j - 1) + 2 * (k - 1) ;
                props(i, j, k) = T(i, n);
        end
    end
end

for i = 1:64
    for j = 1
        for k = 1:3
                props(i, j, k) = 1 - props(i, 2, k) - props(i, 3, k);
                if props(i, 2, k) + props(i, 3, k) > 1
                    i, k
                    props(i, 2, k)
                    props(i, 3, k)
                    error()
                end
        end
    end
end

props(1, :, :)

props_avg = sum(props, 3) ./ 3;

props_avg(1, :, :)


fig = figure;
patch([1 0 0], [0 1 0], [0 0 1], [0.5 0.5 0.5], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
hold on
grid on
    scatter3(props_avg(:, 2),props_avg(:, 3),props_avg(:, 1), 200, "black", '.');


    view(163,10)
    xlabel('Proportion mKate+')
    ylabel('Proportion EYFP+')
    zlabel('Proportion EBFP+')
    yticks([0 0.2 0.4 0.6 0.8 1])
    
    title('\fontsize{20}Cell State Proportions in Multicellular Structures')

    figname = 'proportions_cNW1m4.png';
    saveas(fig,figname,'png')

    fig = figure;
    patch([0 0 1], [0 1 0], [0.5 0.5 0.5], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
hold on
grid on
    scatter(props_avg(:, 2),props_avg(:, 3), 100, "black", '.');

    xlabel('Proportion mKate+')
    ylabel('Proportion EYFP+')
    
    title('\fontsize{15}mKate vs EYFP Cell State Proportions in Multicellular Structures')

    figname = 'proportions_cNW1m4_2D.png';
    saveas(fig,figname,'png')
end

        

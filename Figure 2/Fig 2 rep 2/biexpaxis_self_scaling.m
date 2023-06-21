function biexpaxis_self_scaling(ax,axis_flags)
%BIEXPAXIS(AX,AXIS_FLAGS) converts the linear scaled axis ax to a
%logicle-scaled one
%optional: axis_flags are axes to convert, e.g. 'x','yz' (default is all
%axes)
%Note: data plotted should be logicle transformed
%Note: only upper limit self scales-- lower is kept at -100
% Modified from Bre DiAndreth's biexpaxis function by Noreen Wauford

    
    [T,M,r] = getLogicleParams;

    hha(1) = ax;
    
    % check if 2D or 3D plot
    viewprops = get(ax,'view');
    az = viewprops(1);
    if az == 0
        view3D = 0;
    else
        view3D = 1;
    end
    
    lims = zeros(3, 2);
    
    if ~exist('axis_flags','var')
        if ~view3D
            axis_flags = 'xy';
            lims(1, :) = xlim;
            lims(2, :) = ylim;
        else
            axis_flags = 'xyz';
            lims(1, :) = xlim;
            lims(2, :) = ylim;
            lims(3, :) = zlim;
        end
    else
        if ~view3D && contains(axis_flags,'z')
            axis_flags(regexp(axis_flags,'[z]'))=[];
        end
    end

    
    
    axis_num = 1;
    for axis_i = 1:numel(axis_flags)
        T = logicle2lin(max(lims(axis_num, :)));
        exponents = floor(log10(abs(r))):floor(log10(T));
        LargeTickVals=lin2logicle([-10^floor(log10(abs(r))), 0, 10.^exponents]);
        TickLabels = {'-10^{2}','','10^{2}','10^{3}','10^{4}','10^{5}'};
        num_ticks = length(LargeTickVals);
        TickLabels = TickLabels(1:num_ticks);
        set(hha(1),...
            [axis_flags(axis_i) 'tick'], LargeTickVals,...
            [axis_flags(axis_i) 'ticklabel'],TickLabels,... 
            [axis_flags(axis_i) 'lim'],[lin2logicle(-10.^floor(log10(abs(r)))) logicle2lin(T)],...
            [axis_flags(axis_i) 'grid'],'on')
            axis_num = axis_num + 1;
    end
    set(hha(1),'xgrid','on','ygrid','on','zgrid','on',...
        'xminorgrid','off','yminorgrid','off','zminorgrid','off')
    



        link = linkprop(hha, {'CameraUpVector', 'CameraPosition', 'CameraTarget', 'XLim', 'YLim', 'ZLim'});   
        setappdata(gcf, 'StoreTheLink', link);
        
end
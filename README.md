# synthetic-symmetry-breaking
This code, flow cytometry data, and images accompany "Synthetic symmetry breaking and programmable multicellular structure formation",
a manuscript published in Cell Systems.

Analysis was performed in MATLAB and ImageJ. 

MATLAB flow cytometry analysis pipeline was written by Breanna DiAndreth and made available to Noreen Wauford, who wrote the code
and performed analysis. MATLAB flow cytometry analysis functions require downloading the MATLAB pipeline from https://github.com/brediandreth/Flow-Analysis-Repository-for-Matlab and modifying the variable "flow_analysis_code_path" to the local copy of the pipeline.

MATLAB flow cytometry and image analysis require several file exchange function packages:
- ColorBrewer, available from https://www.mathworks.com/matlabcentral/fileexchange/45208-colorbrewer-attractive-and-distinctive-colormaps.
- CaptureFigVid, available from https://www.mathworks.com/matlabcentral/fileexchange/41093-create-video-of-rotating-3d-plot?tab=discussions
- Export_fig, available from https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig
- Fca_readfcs, available from https://www.mathworks.com/matlabcentral/fileexchange/9608-fca_readfcs
- Logicle transformation, available from https://www.mathworks.com/matlabcentral/fileexchange/45022-logicle-transformation
- Tight_subplot, available from https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w****
Modify the variable "fex_code_path" in .m files to the path of the local folder containing these packages.

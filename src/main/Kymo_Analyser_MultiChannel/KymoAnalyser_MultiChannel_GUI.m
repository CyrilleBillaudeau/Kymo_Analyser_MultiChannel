function KymoAnalyser_MultiChannel_GUI()

%--------------------------------------------------------------------------
%% function KymoAnalyser_MultiChannel_GUI()
%% General description:
% The KymoAnalyser_MultiChannel_GUI is designed to quantify the velocity of 
% mobile particles through kymograph analysis. Initially, a kymogram is 
% constructed for each pixel row spanning the cell midline. These kymograms 
% are then aligned in a side-by-side configuration to generate a single 
% two-dimensional image, wherein each column encompasses a kymograph of 
% the successive pixel rows within the cell. The current version has been 
% adapted from the '20201127 CB ProCeD/Micalis/INRAE' version with the 
% objective of facilitating a comparison of kymograms generated using two 
% fluorescent markers (in Channels #1 and #2) and quantifying the speeds 
% observed in each kymogram. 
%
% Upon launching the program, a window with three buttons will appear, 
% allowing the user to navigate through the various stages of the analytical 
% process. These include: 
% 1- identifying the median axes of the cells; 
% 2- generating kymographs and quantifying the speed of moving particles; 
% 3- compiling the results from different replicates.
% 
%% Requirements: uipickfiles
%% Date: 20230404
%% Author: Cyrille Billaudeau (ProCeD lab, Micalis intitute - INRAE)
%--------------------------------------------------------------------------

%% ================================================= %%
%% ================================================= %%
%% ================================================= %%
disp('================= KymoAnalyser_MultiChannel_GUI =================');
%% ================================================= %%
%% ================================================= %%
%% ================================================= %%

%% ================================================= %%
%% ================================================= %%
%% ================================================= %%


% User interface default colors
%colorFgd=[0 0 0];
colorBgd=[204 204 204]/255; %% "Natural" color background
%colorBgd=[1 1 1]; %% White color background
%text_size = 0.70;
%text_size_column = 0.10;
%edit_text_size = 0.1;
width_column_menu=0.9;%0.20;

% Create and hide the GUI as it is being constructed.
frontpanel = figure('Visible','on','Position',[0,0,250,250],...
    'Color',colorBgd,'Resize','on',...
    'Name', 'Kymograph Analyser 1.0 - ProCeD (Micalis/INRAE)',...  % Title figure
    'NumberTitle', 'off',... % Do not show figure number
    'IntegerHandle','off',...
    'MenuBar', 'none');
movegui(frontpanel, 'center');

global NUM_FIG_GUI
NUM_FIG_GUI = frontpanel;

%% ================================================= %%
K1_drawTrack_pushbutton=uicontrol('Parent',frontpanel,'Style','pushbutton',...
    'String','1-Draw line for kymo','HorizontalAlignment','left', ...
    'Units','normalized','Position',[0.05,0.8,width_column_menu,0.15],...
    'TooltipString', 'Draw lines on the midline of the bacteria',...
    'Callback',{@K1_drawTrack_pushbutton_Callback});

%% ================================================= %%
K2_drawTrace_pushbutton=uicontrol('Parent',frontpanel,'Style','pushbutton',...
    'String','2-Analyse kymo','HorizontalAlignment','left', ...
    'Units','normalized','Position',[0.05,0.6,width_column_menu,0.15],...
    'TooltipString', 'Drawing lines to obtain slopes on kymo',...
    'Callback',{@K2_drawTrace_pushbutton_Callback});

%% ================================================= %%
K3_statAnalysis_pushbutton=uicontrol('Parent',frontpanel,'Style','pushbutton',...
    'String','3-Data compilation','HorizontalAlignment','left', ...
    'Units','normalized','Position',[0.05,0.4,width_column_menu,0.15],...
    'TooltipString', 'Extracting velocities for statistics and save results in excel file',...
    'Callback',{@K3_statAnalysis_pushbutton_Callback});
end

%--------------------------------------------------------------------------
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% functions KymoAnalyser_GUI()
%%
%%


%% function K1_drawTrack_pushbutton_Callback(hObject, eventdata, handles)
% 
function K1_drawTrack_pushbutton_Callback(hObject, eventdata, handles)
KymoAnalyser_1_draw_track();
handle = findobj(allchild(groot), 'flat', 'type', 'figure', 'number', 11); % just in case if fig were reopend
if (~isempty(handle))
    close(11);
end%if
end

%% function K2_drawTrace_pushbutton_Callback(hObject, eventdata, handles)
% 
function K2_drawTrace_pushbutton_Callback(hObject, eventdata, handles)
KymoAnalyser_2_draw_trace();
end

%% function K3_statAnalysis_pushbutton_Callback(hObject, eventdata, handles)
% 
function K3_statAnalysis_pushbutton_Callback(hObject, eventdata, handles)
KymoAnalyser_3_statistic_analysis();
end
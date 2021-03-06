% Author: Matthew Frehlich, Ye Mei, Luis Garcia Dominguez,Faranak Farzan
%         2016
%         Ben Schwartzmann 
%         2017

% tmseeg_main: Main GUI for the TMSEEG app, a GUI-based signal
% processing software for TMS-EEG Data. This program creates the parent
% structure/figure. Steps in the processing workflow are denoted by
% buttons, which call specific functions encapsulating the processing
% workflow for each step.
% 
% Input Data: TMS-EEG dataset using EEGLABs .set file format 
% 
% Output Data: .set format datasets at each 

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.


function [] = tmseeg_main()

close all
clc

global basepath basefile backcolor
backcolor   = [0.8 0.9 1];
basefile    = 'None Selected';

% Main object, GUI Parent figure
S      = []; 
S.hfig = figure('Menubar','none',...
            'Toolbar','none',...
            'Units','normalized',...
            'Name','tmseeg',...
            'Numbertitle','off',...
            'Resize','on',...
            'Color',backcolor,...
            'Position',[0.1 0.1 0.6 0.4],...
            'DockControls','off');

% Main GUI Buttons        
global existcolor notexistcolor
existcolor    = [0.7 1 0.7];
notexistcolor = [1 0.7 0.7];

% GUI Button Positioning
v=1/7;
col_1 = 0;
col_2 = 0.4;
col_3 = 0.5;
col_4 = 0.9;
st = 5/7;
stepb_w = 0.4;
sw = 0.1;

% ------------------Main Buttons for processing steps----------------------
S.button1 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_1 st stepb_w v],...
                   'String','1.INITIAL PROCESSING',...
                   'BackgroundColor',notexistcolor,... 
                   'Callback',{@button_callback1,S});
S.button2 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_1 st-v stepb_w v],...
                   'String','2.REMOVE TMS ARTIFACT',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback2,S});
S.button3 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_1 st-2*v stepb_w v],...
                   'String','3.REMOVE BAD TRLs AND CHNs 1',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback3,S});
S.button4 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_1 st-3*v stepb_w v],...
                   'String','4.ICA (ROUND 1)',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback4,S}); 
S.button5 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_1 st-4*v stepb_w v],...
                   'String','5.REMOVE TMS DECAY ARTIFACT',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback5,S});
S.button6 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_3 st stepb_w v],...
                   'String','6.FILTERING',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback6,S});
S.button7 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_3 st-v stepb_w v],...
                   'String','7.ICA (ROUND 2)',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback7,S});
S.button8 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_3 st-2*v stepb_w v],...
                   'String','8.REMOVE ICA2 COMPONENTS',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback8,S});
S.button9 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_3 st-3*v stepb_w v],...
                   'String','9.REMOVE BAD TRLs AND CHNs 2',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback9,S});
S.button10 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_3 st-4*v stepb_w v],...
                   'String','10.FINAL PROCESSING',...
                   'BackgroundColor',notexistcolor,...
                   'Callback',{@button_callback10,S}); 
S.button11 = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_1 st-5*v 0.5 v],...
                   'String','EEGLAB',...
                   'Callback',{@button_callback11,S}); 
               
% --------------------- Small Buttons for Data Display --------------------
S.button1s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_2 st sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 1',...
                   'Callback',{@button_callback1s,S});
S.button2s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_2 st-v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 2',...
                   'Callback',{@button_callback2s,S});
S.button3s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_2 st-2*v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 3',...
                   'Callback',{@button_callback3s,S});
S.button4s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_2 st-3*v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 4',...
                   'Callback',{@button_callback4s,S}); 
S.button5s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_2 st-4*v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 5',...
                   'Callback',{@button_callback5s,S});
S.button6s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_4 st sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 6',...
                   'Callback',{@button_callback6s,S});
S.button7s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_4 st-v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 7',...
                   'Callback',{@button_callback7s,S});
S.button8s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_4 st-2*v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 8',...
                   'Callback',{@button_callback8s,S});
S.button9s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_4 st-3*v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 9',...
                   'Callback',{@button_callback9s,S});
S.button10s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_4 st-4*v sw v],...
                   'BackgroundColor',notexistcolor,...
                   'String','View 10',...
                   'Callback',{@button_callback10s,S}); 
S.button11s = uicontrol('Parent', S.hfig,'Style','pushbutton',...
                   'Units','normalized',...
                   'Position',[col_3 st-5*v 0.5 v],...
                   'String','Settings',...
                   'Callback',{@button_callback11s,S});
S.hbutton1  = uicontrol('Style','pushbutton',...
                    'Units','normalized',...
                    'HorizontalAlignment','left',...
                    'Position',[0.0 1-v/2 0.2 v/2],...
                    'Fontsize',14,...
                    'Tag','main_text_b',...
                    'String','Working Folder:',...
                    'Callback',{@wkdirbutton_callback,S});
S.hbutton2  = uicontrol('Style','pushbutton',...
                    'Units','normalized',...
                    'HorizontalAlignment','left',...
                    'Position',[0.0 1-v 0.2 v/2],...
                    'Fontsize',14,...
                    'Tag','file_text_b',...
                    'String','Dataset:',...
                    'Callback',{@datasetbutton_callback,S});

% ----------------------------- Headers -----------------------------------
S.htext1 = uicontrol('Style','text',...
                    'Units','normalized',...
                    'HorizontalAlignment','left',...
                    'Position',[0.2 1-v/2 0.8 v/2],...
                    'Fontsize',14,...
                    'BackgroundColor',[0.7 0.8 1],...
                    'Tag','main_text',...
                    'string','  Please select data path,first!');
S.htext2 = uicontrol('Style','text',...
                    'Units','normalized',...
                    'Position',[0.2 1-v 0.8 v/2],...
                    'HorizontalAlignment','left',...
                    'Fontsize',14,...
                    'BackgroundColor',[0.7 0.8 1],...
                    'Tag','file_text',...
                    'string',['  ' basefile]);

% -------------------------------Initial Loading---------------------------
global VARS
VARS = tmseeg_init();

%Must specify number of steps in processing workflow
S.num_steps = 10; 


%% Callback Functions

%Call to working directory
function wkdirbutton_callback(varargin)
    %Call user input for working folder
    basepath = uigetdir(pwd,'Select Data Folder');
    h = findobj('Tag','main_text');
    set(h,'String',['  ' basepath ])
    
    %Close all open TMSEEG windows
    set(S.hfig,'HandleVisibility','off')
    close all;
    set(S.hfig,'HandleVisibility','on')
    
    %Re-initialize GUI, variables
    VARS = tmseeg_init();
    basefile    = 'None Selected';
    h = findobj('Tag','file_text');
    set(h,'String',['  ' basefile ])
    guidata(S.hfig,S);
    tmseeg_upd_stp_disp(S, '.set', S.num_steps)  
end

%Call to dataset
function datasetbutton_callback(varargin)
    %Load selected dataset, update display
    [filename] = ...
    uigetfile(fullfile(basepath,'*.set'),'Select Original File');
    [~,basefile,ext] = fileparts(filename);
    tmseeg_upd_stp_disp(S, ext, S.num_steps)
    
    %Update Parent GUI
    h = findobj('Tag','file_text');
    set(h,'String',['  ' basefile ])
    guidata(S.hfig,S);   
end

%Step 1 - Data Loading and Preprocessing
function button_callback1(varargin)
    tmseeg_init_proc(S, 1);
end

%Step 2 - Remove TMS Pulse
function button_callback2(varargin)
    tmseeg_rm_TMS_art(S, 2);
end

%Step 3 - Remove Bad Channels and Trials
function button_callback3(varargin)
    tmseeg_rm_ch_tr_1(S, 3);
end

%Step 4 - Run ICA1
function button_callback4(varargin)
    tmseeg_ica1(S, 4)
end

%Step 5 - Remove ICA1 components for delay artifact
function button_callback5(varargin)
    tmseeg_rm_TMS_decay(S, 5);
end

%Step 6 - Remove Power line noise, highpass/lowpass filter
function button_callback6(varargin)
    tmseeg_filt(S, 6);
end

%Step 7 - Run ICA2
function button_callback7(varargin)
    tmseeg_ica2(S, 7)
end

%Step 8 - Remove ICA2 Components
function button_callback8(varargin)
     tmseeg_ica2_remove(S, 8);
end

%Step 9 - Remove Bad Channels and Trials
function button_callback9(varargin)
    tmseeg_rm_ch_tr_2(S, 9);
end

%Step 10 - Interpolation and Final Processing
function button_callback10(varargin)
     tmseeg_interpolation(S, 10);
end

%Call to EEGLAB
function button_callback11(varargin)
    eeglab;
end

%Call to data display
function button_callback1s(varargin)
    tmseeg_show(1);
end

function button_callback2s(varargin)
    tmseeg_show(2);
end

function button_callback3s(varargin)
    tmseeg_show(3);
end

function button_callback4s(varargin)
    tmseeg_show(4);
end

function button_callback5s(varargin)
    tmseeg_show(5);
end

function button_callback6s(varargin)
    tmseeg_show(6);
end

function button_callback7s(varargin)
    tmseeg_show(7);
end

function button_callback8s(varargin)
    tmseeg_show(8);
end

function button_callback9s(varargin)
    tmseeg_show(9);
end

function button_callback10s(varargin)
    tmseeg_show(10);
end

%Call to settings window
function button_callback11s(varargin)
    tmseeg_settings(S);
end

end










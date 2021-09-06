function varargout = Part_4_gui(varargin)
% PART_4_GUI MATLAB code for Part_4_gui.fig
%      PART_4_GUI, by itself, creates a new PART_4_GUI or raises the existing
%      singleton*.
%
%      H = PART_4_GUI returns the handle to a new PART_4_GUI or the handle to
%      the existing singleton*.
%
%      PART_4_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART_4_GUI.M with the given input arguments.
%
%      PART_4_GUI('Property','Value',...) creates a new PART_4_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Part_4_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Part_4_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Part_4_gui

% Last Modified by GUIDE v2.5 22-Sep-2020 23:33:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Part_4_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Part_4_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT




% --- Executes just before Part_4_gui is made visible.
function Part_4_gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

clc;
global count_img1 count_img2 pts_img1 pts_img2 flag_img1 flag_img2 path1 path2;
count_img1 = 0;
count_img2 = 0;
pts_img1 = zeros(3,4);
pts_img2 = zeros(3,4);
flag_img1 = false;
flag_img2 = false;

% Update handles structure
guidata(hObject, handles);

axes(handles.axe1);
path1 = '../assg1/im01.jpg';
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_select;

axes(handles.axe2);
path2 = '../assg1/im02.jpg';
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_select;




% --- Outputs from this function are returned to the command line.
function varargout = Part_4_gui_OutputFcn(hObject, eventdata, handles)

uiwait(gcf);

global pts_img1 pts_img2 path1 path2;

img1 = imread(path1);
img2 = imread(path2);

varargout{1} = pts_img1;
varargout{2} = pts_img2;
varargout{3} = img1;
varargout{4} = img2;

close()




function img1_select(hObject, eventdata, handles)

handles = guidata(hObject);

currentpt = get(gca, 'CurrentPoint');
row  = currentpt(1,2);
col  = currentpt(1,1);

colors = ['r', 'g', 'c', 'm'];

global count_img1 pts_img1 flag_img1;

count_img1 = count_img1 + 1;

if count_img1 <= 4
    hold on ;
    plot(col, row, 'o','MarkerSize', 6, 'MarkerFaceColor', colors(count_img1), 'MarkerEdgeColor', colors(count_img1));
    drawnow;
    hold off;
    pts_img1(:, count_img1) = [col; row; 1];
end


if count_img1 == 4
    flag_img1 = true;
end
    

    
    
function img2_select(hObject, eventdata, handles)

handles = guidata(hObject);

currentpt = get(gca, 'CurrentPoint');
row  = currentpt(1,2);
col  = currentpt(1,1);

colors = ['r', 'g', 'c', 'm'];

global count_img2 pts_img2 flag_img2;

count_img2 = count_img2 + 1;

if count_img2 <= 4
    hold on ;
    plot(col, row, 'o','MarkerSize', 6, 'MarkerFaceColor', colors(count_img2), 'MarkerEdgeColor', colors(count_img2));
    drawnow;
    hold off;
    pts_img2(:, count_img2) = [col; row; 1];
end


if count_img2 == 4
    flag_img2 = true;
end

    
    
    
% --- Executes on button press in reset_1.
function reset_1_Callback(hObject, eventdata, handles)

hold off;
handles = guidata(hObject);

global count_img1 pts_img1 flag_img1 path1;
count_img1 = 0;
pts_img1 = zeros(3,4);
flag_img1 = false;

guidata(hObject, handles);

axes(handles.axe1)
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_select;

    


% --- Executes on button press in reset_2.
function reset_2_Callback(hObject, eventdata, handles)

hold off;
handles = guidata(hObject);

global count_img2 pts_img2 flag_img2 path2;
count_img2 = 0;
pts_img2 = zeros(3,4);
flag_img2 = false;

guidata(hObject, handles);

axes(handles.axe2)
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_select;
    
    
    
    
% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
        
handles = guidata(hObject);

global flag_img1 flag_img2;

if flag_img1 && flag_img2
    uiresume(gcbf);
else
    warndlg('Please ensure that you choose 4 points on each image', 'Error');
end




% --- Executes on button press in swap.
function swap_Callback(hObject, eventdata, handles)

global count_img1 count_img2 pts_img1 pts_img2 flag_img1 flag_img2 path1 path2;

temp = path1;
path1 = path2;
path2 = temp;

count_img1 = 0;
count_img2 = 0;
pts_img1 = zeros(3,4);
pts_img2 = zeros(3,4);
flag_img1 = false;
flag_img2 = false;

guidata(hObject, handles);

axes(handles.axe1)
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_select;

axes(handles.axe2)
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_select;

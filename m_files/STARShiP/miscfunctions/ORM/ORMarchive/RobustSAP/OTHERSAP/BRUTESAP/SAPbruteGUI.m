function varargout = SAPbruteGUI(varargin)
% SAPbruteGUI MATLAB code for SAPbruteGUI.fig
%      SAPGUI, by itself, creates a new SAPGUI or raises the existing
%      singleton*.
%

% Last Modified by GUIDE v2.5 13-Feb-2014 18:46:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAPGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SAPGUI_OutputFcn, ...
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

% --- Executes just before SAPGUI is made visible.
function SAPGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAPGUI (see VARARGIN)

% Choose default command line output for SAPGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using SAPGUI.
if strcmp(get(hObject,'Visible'),'off')
    % plot(rand(5));
end

% UIWAIT makes SAPGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAPGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%=========================================================%
%=========================================================%
%=========================================================%
% --- Executes on button press in RunSAP.
function RunSAP_Callback(hObject, eventdata, handles)



Qon = str2double(get(handles.Qon,'String'));
Ron = str2double(get(handles.Ron,'String'));
Qoff = str2double(get(handles.Qoff,'String'));
Roff = str2double(get(handles.Roff,'String'));
Lon = str2double(get(handles.Lon,'String'));
Loff = str2double(get(handles.Loff,'String'));

QRvals = [Qon Ron Qoff Roff Lon Loff];


Nsteps = str2double(get(handles.Nsteps,'String'));
dT = str2double(get(handles.dT,'String'));

params = [Nsteps dT];




handles.output = SAPbrute(QRvals,params);





%=========================================================%
%=========================================================%
%=========================================================%
%{
function RunSAP_Callback(hObject, eventdata, handles)


sap1 = str2double(get(handles.Qon,'String'));
sap2 = str2double(get(handles.Ron,'String'));
sap3 = str2double(get(handles.Qoff,'String'));
sap4 = str2double(get(handles.Roff,'String'));


RobustSAP(sap1, sap2, sap3, sap4);

% sap20 = get(handles.LOGICAL,'Value');






handles.output = RobustSAP(sap1, sap2, sap3, sap4);



axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end
%}

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%{
% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end
%}


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)




%=========================================================%
%=========================================================%



%----------Numeric Value Callbacks--------------%
function Qon(hObject, eventdata, handles)
Qon = str2double(get(hObject, 'String'));
if isnan(Qon)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Qon = Qon;
guidata(hObject,handles)
%---
function Ron(hObject, eventdata, handles)
Ron = str2double(get(hObject, 'String'));
if isnan(Ron)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Ron = Ron;
guidata(hObject,handles)
%---
function Qoff(hObject, eventdata, handles)
Qoff = str2double(get(hObject, 'String'));
if isnan(Qoff)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Qoff = Qoff;
guidata(hObject,handles)
%---
function Roff(hObject, eventdata, handles)
Roff = str2double(get(hObject, 'String'));
if isnan(Roff)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Roff = Roff;
guidata(hObject,handles)
%---
function Lon(hObject, eventdata, handles)
Lon = str2double(get(hObject, 'String'));
if isnan(Qon)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Lon = Lon;
guidata(hObject,handles)
%---
function Loff(hObject, eventdata, handles)
Loff = str2double(get(hObject, 'String'));
if isnan(Ron)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Loff = Loff;
guidata(hObject,handles)
%---
function Nsteps(hObject, eventdata, handles)
Nsteps = str2double(get(hObject, 'String'));
if isnan(Nsteps)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.Nsteps = Nsteps;
guidata(hObject,handles)
%---
function dT(hObject, eventdata, handles)
dT = str2double(get(hObject, 'String'));
if isnan(dT)
    set(hObject, 'String', 1);
    errordlg('Input must be a number','Error');
end

handles.guidata.dT = dT;
guidata(hObject,handles)
%---




 
%----------Logical Callbacks--------------%
%{
function doSpike(hObject, eventdata, handles)
doSpike = get(hObject, 'Value');
 
handles.guidata.doSpike = doSpike;
guidata(hObject,handles)
%}
 
 
 
 
 
 
 
%=========================================================%
%=========================================================%
 
 
 
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
 
 
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
 
set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});
 
 
 






function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 









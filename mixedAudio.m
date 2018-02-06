function varargout = mixedAudio(varargin)
% MIXEDAUDIO MATLAB code for mixedAudio.fig
%      MIXEDAUDIO, by itself, creates a new MIXEDAUDIO or raises the existing
%      singleton*.
%
%      H = MIXEDAUDIO returns the handle to a new MIXEDAUDIO or the handle to
%      the existing singleton*.
%
%      MIXEDAUDIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIXEDAUDIO.M with the given input arguments.
%
%      MIXEDAUDIO('Property','Value',...) creates a new MIXEDAUDIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mixedAudio_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mixedAudio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mixedAudio

% Last Modified by GUIDE v2.5 10-Jan-2018 12:39:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mixedAudio_OpeningFcn, ...
                   'gui_OutputFcn',  @mixedAudio_OutputFcn, ...
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


% --- Executes just before mixedAudio is made visible.
function mixedAudio_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mixedAudio (see VARARGIN)

% Choose default command line output for mixedAudio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mixedAudio wait for user response (see UIRESUME)
% uiwait(handles.mixedAudio);


% --- Outputs from this function are returned to the command line.
function varargout = mixedAudio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play
g = guidata(handles.mixedAudio); 


% Set timer for real time playback demonstration     
% Check if timers are running
if(isempty(timerfind('Name', 't')))
    disp('Creating timer object'); 
    % Set timer workspace     
    g.t = timer;  
    set(g.t, 'Name', 't'); 
    guidata(handles.mixedAudio, g); 
    set(g.t,'ExecutionMode', 'fixedDelay', ...
        'Period', 1, ...
        'TimerFcn', {@timerCallback, handles.mixedAudio, handles});
end


% Get the music playback status
g.state = getappdata(0, 'state'); 
%Get sound and play
if(strcmp(g.state, 'stop'))    
    play(getappdata(0, 'player'));    
    set(handles.track1Status, 'String', 'Playing'); 
    setappdata(0, 'state', 'play'); 
%     g.state = 'play';
    start(g.t);
else
    if(strcmp(g.state, 'play'))        
        pause(getappdata(0, 'player'));  
        setappdata(0, 'state', 'pause'); 
        set(handles.track1Status, 'String', 'Paused');         
         stop(g.t); 
    else
        if(strcmp(g.state, 'pause'))            
            resume(getappdata(0, 'player'));  
            setappdata(0, 'state', 'play'); 
            set(handles.track1Status, 'String', 'Playing');             
             start(g.t); 
        end
    end
end     
guidata(handles.mixedAudio, g); 


% Callback for timer function @timerCallback
function timerCallback(obj, event, hObject, handles)   
g=guidata(hObject);
         g.i = getappdata(0, 'i');
         disp(g.i); 
         disp(getappdata(0, 'duration')); 
         if (g.i < getappdata(0, 'duration'))
             set(handles.slider, 'value',g.i); 
             setappdata(0, 'i', g.i + 1);              
             set(handles.trackTime, 'String', num2str(g.i));             
         else
             delete(g.t); 
             set(handles.slider, 'value', 0); 
             set(handles.trackTime, 'string', '0'); 
             setappdata(0, 'state', 'stop'); 
             setappdata(0, 'i', 0); 
             set(handles.track1Status, 'String', 'Stopped');

         end
guidata(hObject, g); 


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g=guidata(handles.mixedAudio); 
stop(getappdata(0, 'player'));  
setappdata(0, 'state', 'stop'); 
setappdata(0, 'i', 0); 
set(handles.track1Status, 'String', 'Stopped');
guidata(handles.mixedAudio, g); 


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in optionAudio1.
function optionAudio1_Callback(hObject, eventdata, handles)
% hObject    handle to optionAudio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns optionAudio1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from optionAudio1
g = guidata(handles.mixedAudio);
g.optionSelected = get(handles.optionAudio1, 'value'); 
setappdata(0, 'state', 'stop'); 
if(g.optionSelected == 2)   
 setappdata(0, 'player', audioplayer(getappdata(0, 'mix'), 2 * getappdata(0, 'samplingRate')));     
else
 if(g.optionSelected == 3)
    setappdata(0, 'player', audioplayer(getappdata(0, 'mix'), 4 * getappdata(0, 'samplingRate')));     
 else
     setappdata(0, 'player', audioplayer(getappdata(0, 'mix'), getappdata(0, 'samplingRate')));     
 end
end



guidata(handles.mixedAudio, g);

% --- Executes during object creation, after setting all properties.
function optionAudio1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optionAudio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function volumeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
g = guidata(handles.mixedAudio); 
g.p = getappdata(0, 'player'); 
g.sample = g.p.CurrentSample; 
pause(getappdata(0, 'player')); 
setappdata(0, 'player', audioplayer(getappdata(0, 'mix') * get(handles.volumeSlider, 'value'), getappdata(0, 'samplingRate')));
play(getappdata(0, 'player'), g.sample); 
guidata(handles.mixedAudio, g); 


% --- Executes during object creation, after setting all properties.
function volumeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function mixedAudio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mixedAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object deletion, before destroying properties.
function uipanel1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(timerfind); 
disp('GUI closed'); 
disp('All timers deleted');

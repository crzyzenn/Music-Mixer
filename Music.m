function varargout = Music(varargin)
% MUSIC MATLAB code for Music.fig
%      MUSIC, by itself, creates a new MUSIC or raises the existing
%      singleton*.
%
%      H = MUSIC returns the handle to a new MUSIC or the handle to
%      the existing singleton*.
%
%      MUSIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSIC.M with the given input arguments.
%
%      MUSIC('Property','Value',...) creates a new MUSIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Music_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Music_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Music

% Last Modified by GUIDE v2.5 14-Jan-2018 08:13:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Music_OpeningFcn, ...
                   'gui_OutputFcn',  @Music_OutputFcn, ...
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





% --- Executes just before Music is made visible.
function Music_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Music (see VARARGIN)

% Choose default command line output for Music
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Music wait for user response (see UIRESUME)
% uiwait(handles.musicGui);


% --- Outputs from this function are returned to the command line.
function varargout = Music_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------

% Callback for the 1st track that is imported.  
function track1_Callback(hObject, eventdata, handles)
% hObject    handle to track1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.musicGui);

set(handles.save, 'enable', 'on'); % Allow the functionality of the save button

% Allow import for wav format: 
[FileName, PathName] = uigetfile({'*.wav'}, 'Select an audio file');


% If the filename hasn't been specified (if the user didn't choose any file during import operation)
if(FileName == 0)
      return; 
else
    
    % Enabling GUI controls
    
        % Make the main track panel visible     
        set(handles.trackPanel, 'visible', 'on'); 
        % Make the track 1 layer visible     
        set(handles.audio1Panel, 'visible', 'on');         
        set(handles.trackText, 'visible', 'on'); % The texts that appear on top
        set(handles.mediaText, 'visible', 'on'); % The texts that appear on top
        set(handles.optionAudio1, 'enable', 'on'); % The option bar is enabled
        set(handles.play, 'enable', 'on'); % The play button is enabled
        set(handles.stop, 'enable', 'on'); % The stop button is enabled
        set(handles.l1, 'enable', 'on'); % The left channel button is enable
        set(handles.r1, 'enable', 'on'); % The right channel button is enable
                
        
    % Reading the audio file 
        % Reads the audio file and saves the sound and the sampling rate number         
        [theSound, sampleRate] = audioread([PathName FileName]); 
        
        % Storing the sound, samplerate globally
        myGui.samplingRate = sampleRate; 
        myGui.music = theSound; 
        myGui.soundSize = size(theSound); 
        
        % Setting the play state to stopped. Since, the track has just been
        % imported 
        myGui.state = 'stop'; 
        
        % An audioplayer object has been assigned to the track
        myGui.player = audioplayer(myGui.music, myGui.samplingRate); 

    % Get left and right channels of the audio
    myGui.leftChannel = myGui.music(:, 1); 
    myGui.rightChannel = myGui.music(:, 2);     

    % Plotting the left and the right channels
    % Left channel
    axes(handles.leftAxes1);
    plot(myGui.leftChannel); 

    % Right channel
    axes(handles.rightAxes1);
    plot(myGui.rightChannel); 
    
    % Set audioinfo for track 1
    myGui.info = audioinfo([PathName FileName]);
    
    % Making visible the GUI components to view information on the audio
    % Example, filename, compression method, number of channels etc.
        set(handles.audioInfoPanel1, 'visible', 'on'); 
        set(handles.filenameField1, 'String', myGui.info.Filename); 
        set(handles.compmethodField1, 'String', myGui.info.CompressionMethod); 
        set(handles.numchannelsField1, 'String', myGui.info.NumChannels); 
        set(handles.samplerateField1, 'String', myGui.info.SampleRate); 
        set(handles.totalsamplesField1, 'String', myGui.info.TotalSamples); 
        set(handles.durationField1, 'String', myGui.info.Duration); 
        set(handles.bitrateField1, 'String', num2str(myGui.info.BitsPerSample)); 

    % Get min and max for GUI slider (min = 0 while max = length of the audio)
    set(handles.audioPlaying1, 'min', 0); 
    set(handles.audioPlaying1, 'max', myGui.info.Duration); 
    
    % Timer variable for track 1 - used inside timer later     
    myGui.i = 0;    
end

guidata(handles.musicGui, myGui); % Update the GUI structure

% --- Executes on button press in audio2.
% Opening the second audio file


% --------------------------------------------------------------------
function track2_Callback(hObject, eventdata, handles)
% hObject    handle to track2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.musicGui);

% Allow import for wav format: 
[FileName, PathName] = uigetfile({'*.wav'}, 'Select an audio file');


if(FileName == 0)     
else
    
    % Enable the GUI controls 
    %     set(handles.welcomeText, 'visible', 'off'); 
    % Make the main track panel visible     
    set(handles.trackPanel, 'visible', 'on'); 
    
    % Make the track 1 layer visible     
    set(handles.audio2Panel, 'visible', 'on'); 
    
    set(handles.trackText, 'visible', 'on'); 
    set(handles.mediaText, 'visible', 'on'); 
    set(handles.optionAudio2, 'enable', 'on'); 
    set(handles.play1, 'enable', 'on'); 
    set(handles.stop1, 'enable', 'on'); 
    set(handles.l2, 'enable', 'on'); 
    set(handles.r2, 'enable', 'on'); 
    
    
    % Hide record controls
    set(handles.recordButton, 'visible', 'off'); 
    set(handles.stopRecordButton, 'visible', 'off'); 
    
    
    % Reading the audio file 
    [snd, FS] = audioread([PathName FileName]); 

    myGui.samplingRate2 = FS; 
    myGui.music2 = snd; 
    myGui.soundSize2 = size(snd); 
    myGui.state2 = 'stop'; 
    myGui.player2 = audioplayer(myGui.music2, myGui.samplingRate2); 

    % Assign left and right channels of the audio
    myGui.leftChannel2 = myGui.music2(:, 1); 
    myGui.rightChannel2 = myGui.music2(:, 2); 

    % Plotting the left and the right channels
    % Left channel
    axes(handles.leftAxes2);
    plot(myGui.leftChannel2); 

    % Right channel
    axes(handles.rightAxes2);
    plot(myGui.rightChannel2); 
    
    
    % Set audioinfo 
    myGui.info2 = audioinfo([PathName FileName]); 
    set(handles.audioInfoPanel2, 'visible', 'on'); 
    set(handles.filenameField2, 'String', myGui.info2.Filename); 
    set(handles.compmethodField2, 'String', myGui.info2.CompressionMethod); 
    set(handles.numchannelsField2, 'String', myGui.info2.NumChannels); 
    set(handles.samplerateField2, 'String', myGui.info2.SampleRate); 
    set(handles.totalsamplesField2, 'String', myGui.info2.TotalSamples); 
    set(handles.durationField2, 'String', myGui.info2.Duration); 
    set(handles.bitrateField2, 'String', myGui.info2.BitsPerSample); 
    
    % Get min and max for GUI 
    set(handles.audioPlaying2, 'min', 0); 
    set(handles.audioPlaying2, 'max', myGui.info2.Duration); 
    
    % Delete all running timers 
%     delete(timerfind); 
%     disp('All timers deleted');
    
    myGui.i2 = 0;

end

guidata(handles.musicGui, myGui); 


% --- Executes on button press in play. Plays / resumes audio. 
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.musicGui);

% Set timer for real time playback demonstration     
% Check if timers are running
if(isempty(timerfind('Name', 't')))
    disp('Creating timer object'); 
    % Set timer workspace     
    myGui.t = timer;  
    
    % Set a name to the timer as t
    set(myGui.t, 'Name', 't'); 
    guidata(handles.musicGui, myGui); 
    set(myGui.t,'ExecutionMode', 'fixedDelay', ...
        'Period', 1, ...
        'TimerFcn', {@timerCallback, handles.musicGui, handles});
end


% Get sound and play
% Gets the state of the sound first
% Routine goes as: 
% State = 'stop' then play audio
% State = 'pause' then resume playing 
% State = 'play' then pause playing
if(strcmp(myGui.state, 'stop'))    
    play(myGui.player); % Play the audio    
    set(handles.track1Status, 'String', 'Playing'); % Display in the GUI that the audio is playing         
    myGui.state = 'play'; % Setting the state to play.
    start(myGui.t); % Starting the player timer
else
    if(strcmp(myGui.state, 'play'))        
        pause(myGui.player); % Pause the audio         
        myGui.state = 'pause'; % Setting the state to paused
        set(handles.track1Status, 'String', 'Paused'); % Display in the GUI that the audio is playing           
        stop(myGui.t); % Stopping the timer (logically it's pausing)
    else
        if(strcmp(myGui.state, 'pause'))            
            resume(myGui.player); % Resume the audio playback         
            myGui.state = 'play'; % Setting the state to playing
            set(handles.track1Status, 'String', 'Playing'); % Display in the GUI that the audio is playing                      
            start(myGui.t); % Resume the audio playeback timer. 
        end
    end
end    

guidata(handles.musicGui, myGui); % Update the GUI structure


% Callback for timer function @timerCallback (For track 1)
function timerCallback(obj, event, hObject, handles)   
myGui=guidata(hObject);
    % myGui.i = 0 initially, it signifies the audio is at 0 position.
    % Now with timer, the value of i increases every seocond. 
     if (myGui.i < myGui.info.Duration)
        
         % If the value of i isn't exceeding the total duration of the audio, 
        
         set(handles.audioPlaying1, 'value',myGui.i); % Setting the time playing (value of i) to the GUI
         myGui.i = myGui.i + 1; % Incrementing the value of i
         set(handles.duration1, 'String', num2str(myGui.i)); % Setting the value to the slider (indication of audio position)
     else
         delete(myGui.t); 
         set(handles.audioPlaying1, 'value', 0); 
         set(handles.duration1, 'string', '0'); 
         myGui.i = 0; 
     end
guidata(hObject, myGui); % Update the GUI structure




% Second audio callback
% --- Executes on button press in play1.
function play1_Callback(hObject, eventdata, handles)
% hObject    handle to play1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.musicGui);

%Get sound and play
% Set timer for real time playback demonstration     
% Check if timers are running
if(isempty(timerfind('Name', 't2')))
    disp('Creating timer object'); 
    % Set timer workspace   
    myGui.t2 = timer;
    set(myGui.t2, 'Name', 't2'); 
    guidata(handles.musicGui, myGui); 
    set(myGui.t2,'ExecutionMode', 'fixedRate', ...
        'Period', 1, ...
        'TimerFcn', {@timerCallback2, handles.musicGui, handles});
end
    
if(strcmp(myGui.state2, 'stop'))    
    myGui.state2 = 'play'; 
    
    play(myGui.player2); 
    start(myGui.t2); 
    set(handles.recordStatus, 'String', 'Playing'); 
else
    if(strcmp(myGui.state2, 'play'))
        myGui.state2 = 'pause';
        
        pause(myGui.player2); 
        stop(myGui.t2); 
        set(handles.recordStatus, 'String', 'Paused'); 
    else
        if(strcmp(myGui.state2, 'pause'))
            myGui.state2 = 'play'
            
            resume(myGui.player2); 
            start(myGui.t2); 
            set(handles.recordStatus, 'String', 'Playing');
        end
    end
    
end

    
guidata(handles.musicGui, myGui); 


% Callback for timer function @timerCallback
function timerCallback2(obj, event, hObject, handles)   
myGui=guidata(hObject);
         if (myGui.i2 < myGui.info2.Duration)
             set(handles.audioPlaying2, 'value',myGui.i2); 
             myGui.i2 = myGui.i2 + 1;
             set(handles.duration2, 'String', num2str(myGui.i2));             
         else                            
             delete(myGui.t2); 
             set(handles.audioPlaying2, 'value', 0); 
             set(handles.duration2, 'string', '0'); 
             myGui.i2 = 0;
             set(handles.recordStatus, 'string', 'Stopped'); 
             
            % Set playback status to stopped
            myGui.state2 = 'stop'; 
         end
guidata(hObject, myGui); 

% --- Executes on button press in stop. Stopping the audio playback. 
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.musicGui); 

stop(myGui.player); % Stopping the audio playback
myGui.state = 'stop'; % Setting the audio playing status to stopped
set(handles.track1Status, 'String', 'Stopped'); %  Set the audio playing status in the GUI to Stopped. 


% Reset GUI variables
delete(myGui.t); % Delete the timer object
set(handles.audioPlaying1, 'value', 0); % Reset the playback slider to position 0
set(handles.duration1, 'string', '0'); % Reset the track duration 0
myGui.i = 0; % Reset the timer variable value to 0. 

guidata(handles.musicGui, myGui); % Update GUI strucutre.



% --- Executes on button press in stop1.
function stop1_Callback(hObject, eventdata, handles)
% hObject    handle to stop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.musicGui);
   
stop(myGui.player2);
myGui.state2 = 'stop';
set(handles.recordStatus, 'String', 'Stopped');

% Reset GUI variables
delete(myGui.t2); 
set(handles.audioPlaying2, 'value', 0); 
set(handles.duration2, 'string', '0'); 
myGui.i2 = 0; 

guidata(handles.musicGui, myGui); 





% --- Executes on selection change in optionAudio1.
function optionAudio1_Callback(hObject, eventdata, handles)
% hObject    handle to optionAudio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns optionAudio1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from optionAudio1
myGui = guidata(handles.musicGui);
myGui.optionSelected = get(handles.optionAudio1, 'value'); 
myGui.state = 'stop'; 
if(myGui.optionSelected == 2)   
 myGui.player = audioplayer(myGui.music, 2 * myGui.samplingRate);     
else
 if(myGui.optionSelected == 3)
    myGui.player = audioplayer(myGui.music, 4 * myGui.samplingRate);             
 else
     myGui.player = audioplayer(myGui.music, myGui.samplingRate);             
 end
end



guidata(handles.musicGui, myGui); 


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


% --- Executes on selection change in optionAudio2.
function optionAudio2_Callback(hObject, eventdata, handles)
% hObject    handle to optionAudio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns optionAudio2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from optionAudio2
myGui = guidata(handles.musicGui);

myGui.optionSelected2 = get(handles.optionAudio2, 'value'); 
myGui.state2 = 'stop'; 
if(myGui.optionSelected2 == 2)   
    myGui.player2 = audioplayer(myGui.music2, 2 * myGui.samplingRate2);     
else
    if(myGui.optionSelected2 == 3)
       myGui.player2 = audioplayer(myGui.music2, 4 * myGui.samplingRate2);             
    else
        myGui.player2 = audioplayer(myGui.music2, myGui.samplingRate2);             
    end
end

guidata(handles.musicGui, myGui); 

% --- Executes during object creation, after setting all properties.
function optionAudio2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optionAudio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui);

[fname,fpath]=uiputfile('.wav','Save sound', 'new'); % Opens up a file browser box to select the save location of the mixed audio
if isequal(fname,0) || isequal(fpath,0)
    % If the save operation was cancelled by the user
    return
else       
  filename = fullfile(fpath, fname); % Get the full location of the path as well as the file name to save the audio
  audiowrite(filename, myGui.mix, myGui.samplingRate2); % Save the audio in the path with the specific sample rate. 
  msgbox('File has been saved.', 'Success', 'Success'); 
end 


guidata(handles.musicGui, myGui); % Update the GUI structure

% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui); 
h = msgbox({'Musicify V1.1' '  ' 'All Rights Reserved'}, 'About'); 
ah = get( h, 'CurrentAxes' );
ch = get( ah, 'Children' );
set(ch, 'FontSize', 12);
guidata(handles.musicGui, myGui); 

% --- Executes on button press in setMixer.
function setMixer_Callback(hObject, eventdata, handles)
% hObject    handle to setMixer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui);  

% Store start point and end point values
myGui.a = str2double(get(handles.startPoint, 'String')); 
myGui.b = str2double(get(handles.endPoint, 'String')); 


% Check if they are integers
if isnan(myGui.a) || isnan(myGui.b)
    %  If they're not integers, shows a warning dialog.      
    warndlg('Input must be an integer'); 
    
    %  The default value of start point: 1 and end point:5 is set.
    set(handles.startPoint, 'String', '1'); 
    set(handles.endPoint, 'String', '5'); 
    
elseif myGui.a == 0 || myGui.b == 0
    %  If the start or the end point is zero. 
    warndlg('0 cannot be the start or end points.'); 
    
    %  The default value of start point: 1 and end point:5 is set.
    set(handles.startPoint, 'String', '1'); 
    set(handles.endPoint, 'String', '5');
    
elseif myGui.a == myGui.b
    %  If the start and end points are the same 
    warndlg('Start point and end points cannot be the same'); 
    
    %  The default value of start point: 1 and end point:5 is set.
    set(handles.startPoint, 'String', '1'); 
    set(handles.endPoint, 'String', '5');
    
elseif myGui.b < myGui.a
    
    %  If the start point is greater than the end point
    warndlg('Start point is greater than the end point'); 
    
    %  The default value of start point: 1 and end point:5 is set.
    set(handles.startPoint, 'String', '1'); 
    set(handles.endPoint, 'String', '5');
else
    try    
        % Storing the start point with the sample rate of the audio
        try        
            startP = myGui.a * myGui.samplingRate;
        catch
            msgbox('Insert track 1 to continue.', 'Error', 'Error'); 
        end
    
        % Storing the start point with the sample rate of the audio
        try
            endP = myGui.b * myGui.samplingRate2;
        catch
            msgbox('Insert track 2 / record voiceover to continue.', 'Error', 'Error'); 
        end
        
        % The total duration of the mixed duration is the difference between the end point and the start point.         
        myGui.mixedTrackDuration = myGui.b - myGui.a; 
        
        % Get the minimum length between the two audios
        myGui.minLength = min([length(myGui.music), length(myGui.music2)]); 
        
        try
            % Extract the portion of audio from the first track                
            myGui.x = myGui.music(startP:endP);
            
            % Extract the same portion of audio from the second track
            myGui.y = myGui.music2(startP:endP);            
            
            % Mix the two audio             
            myGui.mix = myGui.x + myGui.y; 
            
            % Store the mixed audio in an audioplayer object
            myGui.joined = audioplayer(myGui.mix, myGui.samplingRate2); 
            
            % The mixed playback status is set to stop
            myGui.mixState = 'stop';             
            
            guidata(handles.musicGui, myGui); % Update GUI structure

            % Load the mixed GUI     
            mixedAudio;
            % Set data on other GUI 
            findGui = findobj('Tag', 'mixedAudio');
            if ~isempty(findGui)
                data = guidata(findGui);         
                axes(data.axes1);
                plot(myGui.mix);             
                % Passing variables from the current GUI to the another GUI                 
                setappdata(0, 'player', myGui.joined);   
                setappdata(0, 'state', 'stop');  
                setappdata(0, 'i', 0);  
                setappdata(0, 'samplingRate', myGui.samplingRate2);  
                setappdata(0, 'duration', myGui.mixedTrackDuration);  
                setappdata(0, 'mix', myGui.mix); 
                set(data.slider, 'max', myGui.mixedTrackDuration); 
            end       
        catch
            % Catch the error if the matrix of the extracts exceeds its dimensions. 
            % i.e. mixed portion is set to more than the full duration of
            % the song.
            msgbox('Track limit exceeded. Try a lower end value', 'Error', 'Error'); 
        end
     catch        
    end
end
guidata(handles.musicGui, myGui); 


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in l1.
function l1_Callback(hObject, eventdata, handles)
% hObject    handle to l1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui);

% Play left channel only

myGui.leftMono = [myGui.leftChannel, zeros(size(myGui.leftChannel))]; 
myGui.player = audioplayer(myGui.leftMono, myGui.samplingRate); 
play(myGui.player); 

guidata(handles.musicGui, myGui); 


% --- Executes on button press in r1.
function r1_Callback(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui);

% Play left channel only

myGui.rightMono = [zeros(size(myGui.leftChannel)), myGui.rightChannel]; 
myGui.player = audioplayer(myGui.rightMono, myGui.samplingRate); 
play(myGui.player); 

guidata(handles.musicGui, myGui); 

% --- Executes on button press in l2.
function l2_Callback(hObject, eventdata, handles)
% hObject    handle to l2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myGui = guidata(handles.musicGui);

% Play left channel only

myGui.leftMono2 = [myGui.leftChannel2, zeros(size(myGui.leftChannel2))]; 
myGui.player2 = audioplayer(myGui.leftMono2, myGui.samplingRate2); 
play(myGui.player2); 

guidata(handles.musicGui, myGui); 


% --- Executes on button press in r2.
function r2_Callback(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myGui = guidata(handles.musicGui);

% Play left channel only

myGui.rightMono2 = [zeros(size(myGui.leftChannel2)), myGui.rightChannel2]; 
myGui.player2 = audioplayer(myGui.rightMono2, myGui.samplingRate2); 
play(myGui.player2); 

guidata(handles.musicGui, myGui); 


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on slider movement.
function audioPlaying1_Callback(hObject, eventdata, handles)
% hObject    handle to leftAxes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function audioPlaying1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftAxes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function audioPlaying2_Callback(hObject, eventdata, handles)
% hObject    handle to audioPlaying2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function audioPlaying2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audioPlaying2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object deletion, before destroying properties.
function duration2_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to duration2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Delete all the timers created



% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to audioPlaying2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audioPlaying2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object deletion, before destroying properties.
function uipanel8_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uipanel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(timerfind); 
disp('GUI closed'); 
disp('All timers deleted'); 


% --- Executes on slider movement.
function volume1_Callback(hObject, eventdata, handles)
% hObject    handle to volume1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
myGui = guidata(handles.musicGui); 
myGui.sample = myGui.player.CurrentSample; 
pause(myGui.player); 
myGui.player = audioplayer(myGui.music * get(handles.volume1, 'value'), myGui.samplingRate);
play(myGui.player, myGui.sample); 
guidata(handles.musicGui, myGui); 

% --- Executes during object creation, after setting all properties.
function volume1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function volume2_Callback(hObject, eventdata, handles)
% hObject    handle to volume2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
myGui = guidata(handles.musicGui); 

pause(myGui.player2); 
if(get(handles.importOption, 'value') == 2)
    myGui.sample2 = myGui.player2.CurrentSample; 
    myGui.player2 = audioplayer(myGui.music2 * get(handles.volume2, 'value'), myGui.samplingRate2);      
else
    myGui.sample2 = myGui.player2.CurrentSample; 
    myGui.player2 = audioplayer(myGui.music2 * get(handles.volume2, 'value'), myGui.samplingRate2);    
end

% Play the audio with the set volume
if(~strcmp(myGui.state2, 'stop'))
    play(myGui.player2, myGui.sample2); 
end

    

guidata(handles.musicGui, myGui); 

% --- Executes during object creation, after setting all properties.
function volume2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in importOption.
function importOption_Callback(hObject, eventdata, handles)
% hObject    handle to importOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns importOption contents as cell array
%        contents{get(hObject,'Value')} returns selected item from importOption
myGui = guidata(handles.musicGui); 

% If the user selects to record audio option
if(get(handles.importOption, 'value') == 3)
    % Allow the user to access the 'Record' and 'Stop Record' button     
    set(handles.recordButton, 'visible', 'on');    
    set(handles.stopRecordButton, 'visible', 'on');    
    
else
    % Allow the user to proceed with import audio file
    
    set(handles.recordButton, 'visible', 'off');
    
    
    % Allow import for wav format: 
    [FileName, PathName] = uigetfile({'*.wav'}, 'Select an audio file');


    if(FileName == 0)

    else

        % Enable the GUI controls 
        %     set(handles.welcomeText, 'visible', 'off'); 
        % Make the main track panel visible     
        set(handles.trackPanel, 'visible', 'on'); 

        % Make the track 1 layer visible     
        set(handles.audio2Panel, 'visible', 'on'); 

        set(handles.trackText, 'visible', 'on'); 
        set(handles.mediaText, 'visible', 'on'); 
        set(handles.optionAudio2, 'enable', 'on'); 
        set(handles.play1, 'enable', 'on'); 
        set(handles.stop1, 'enable', 'on'); 
        set(handles.l2, 'enable', 'on'); 
        set(handles.r2, 'enable', 'on'); 


        % Reading the audio file 
        [snd, FS] = audioread([PathName FileName]); 

        myGui.samplingRate2 = FS; 
        myGui.music2 = snd; 
        myGui.soundSize2 = size(snd); 
        myGui.state2 = 'stop'; 
        myGui.player2 = audioplayer(myGui.music2, myGui.samplingRate2); 

        % Assign left and right channels of the audio
        myGui.leftChannel2 = myGui.music2(:, 1); 
        myGui.rightChannel2 = myGui.music2(:, 2); 

        % Plotting the left and the right channels
        % Left channel
        axes(handles.leftAxes2);
        plot(myGui.leftChannel2); 

        % Right channel
        axes(handles.rightAxes2);
        plot(myGui.rightChannel2); 


        % Set audioinfo 
        myGui.info2 = audioinfo([PathName FileName]); 
        set(handles.audioInfoPanel2, 'visible', 'on'); 
        set(handles.filenameField2, 'String', myGui.info2.Filename); 
        set(handles.compmethodField2, 'String', myGui.info2.CompressionMethod); 
        set(handles.numchannelsField2, 'String', myGui.info2.NumChannels); 
        set(handles.samplerateField2, 'String', myGui.info2.SampleRate); 
        set(handles.totalsamplesField2, 'String', myGui.info2.TotalSamples); 
        set(handles.durationField2, 'String', myGui.info2.Duration); 
        set(handles.bitrateField2, 'String', myGui.info2.BitsPerSample); 

        % Get min and max for GUI 
        set(handles.audioPlaying2, 'min', 0); 
        set(handles.audioPlaying2, 'max', myGui.info2.Duration); 

        % Delete all running timers 
    %     delete(timerfind); 
    %     disp('All timers deleted');

        myGui.i2 = 0;

    end 
end

guidata(handles.musicGui, myGui); 


% --- Executes during object creation, after setting all properties.
function importOption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in recordButton.
function recordButton_Callback(hObject, eventdata, handles)
% hObject    handle to recordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui);

% Setting the recording sampling rate to 40k.
myGui.samplingRate2 = 40000; 

% Setting up the audiorecorder object to record on 8 bits with 2 channel
% ids
myGui.recorder = audiorecorder(myGui.samplingRate2, 8, 2); 

% Disable playback buttons
set(myGui.play1, 'enable', 'off');
set(myGui.stop1, 'enable', 'off');

% Enable stop recording button
set(handles.stopRecordButton, 'enable', 'on'); 

% Set status to recording
set(handles.recordStatus, 'String', 'Recording...'); 

% Start recording
record(myGui.recorder);

% Set up recording timer
myGui.recordTimer = timer; 
set(myGui.recordTimer, 'Name', 'recordTimer');
myGui.tick = 0; 
guidata(handles.musicGui, myGui); 
set(myGui.recordTimer,'ExecutionMode', 'fixedDelay', ...
    'Period', 1, ...
    'TimerFcn', {@recordTimerCallback, handles.musicGui, handles});

% Start the timer
start(myGui.recordTimer); 

guidata(handles.musicGui, myGui); % Update the GUI structure



function recordTimerCallback(obj, event, hObject, handles)   
    myGui=guidata(hObject);    
    set(handles.recordDuration, 'String', num2str(myGui.tick)); 
    myGui.tick = myGui.tick + 1; 
    
guidata(hObject, myGui); 


% --- Executes on key press with focus on recordButton and none of its controls.
function recordButton_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to recordButton (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stopRecordButton.
function stopRecordButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopRecordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui = guidata(handles.musicGui);

% Stop the audiorecorder
stop(myGui.recorder); 

% Stop the recording timer
stop(myGui.recordTimer);

% Set GUI components
set(handles.recordStatus, 'String', 'Stopped'); % Set the record Status to Stopped. 
set(handles.trackPanel, 'visible', 'on'); % Sets the panel to display the record audio graph to visible
set(handles.audio2Panel, 'visible', 'on'); % Sets the main panel section for audio display to visible.

% Enable recording playback buttons
set(myGui.play1, 'enable', 'on');
set(myGui.stop1, 'enable', 'on');

% Disable the media information panel
set(myGui.audioInfoPanel2, 'visible', 'off'); 

% Disable stop playback button
set(myGui.stopRecordButton, 'enable', 'off');


% Get recorded audio
myGui.music2 = getaudiodata(myGui.recorder); 

% Add the recorded file to audio player
myGui.player2 = audioplayer(myGui.music2, myGui.samplingRate2); 

% Set the state of the record audio playback to stopeed.
myGui.state2 = 'stop'; 
 
% Set music playback timer elements
myGui.info2.Duration = str2double(get(handles.recordDuration, 'String')); 
myGui.i2 = 0;

% Set min max for playback slider
set(myGui.audioPlaying2, 'max', myGui.info2.Duration); 

% Plot recorded audio in graph
myGui.left = myGui.music2(:, 1); 
myGui.right = myGui.music2(:, 2); 

axes(handles.leftAxes2); 
plot(myGui.left); 
axes(handles.rightAxes2); 
plot(myGui.right); 

% Set audio info 
guidata(handles.musicGui, myGui); 



function mixedFS_Callback(hObject, eventdata, handles)
% hObject    handle to mixedFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mixedFS as text
%        str2double(get(hObject,'String')) returns contents of mixedFS as a double


% --- Executes during object creation, after setting all properties.
function mixedFS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mixedFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startPoint_Callback(hObject, eventdata, handles)
% hObject    handle to startPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startPoint as text
%        str2double(get(hObject,'String')) returns contents of startPoint as a double


% --- Executes during object creation, after setting all properties.
function startPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endPoint_Callback(hObject, eventdata, handles)
% hObject    handle to endPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endPoint as text
%        str2double(get(hObject,'String')) returns contents of endPoint as a double


% --- Executes during object creation, after setting all properties.
function endPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

classdef objOsc < matlab.System
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        % Defaults
        note                        = objNote;
        oscConfig                   = confOsc;
        constants                   = confConstants;
    end

    % Pre-computed constants
    properties(Access = private)
        % Private members
        currentTime;
        EnvGen                = objEnv;
    end
    
    methods
        function obj = objOsc(varargin)
            %Constructor
            if nargin > 0
                setProperties(obj,nargin,varargin{:},'note','oscConfig','constants');
                
                tmpEnv=confEnv(obj.note.startTime,obj.note.endTime,...
                    obj.oscConfig.oscAmpEnv.AttackTime,...
                    obj.oscConfig.oscAmpEnv.DecayTime,...
                    obj.oscConfig.oscAmpEnv.SustainLevel,...
                    obj.oscConfig.oscAmpEnv.ReleaseTime);
                obj.EnvGen=objEnv(tmpEnv,obj.constants);
            end
        end
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            
            % Reset the time function
            obj.currentTime=0;
        end

        function audio = stepImpl(obj)
%             obj.EnvGen.StartPoint=obj.note.startTime;   % set the end point again in case it has changed
%             obj.EnvGen.ReleasePoint=obj.note.endTime;   % set the end point again in case it has changed
            
            timeVec=(obj.currentTime+(0:(1/obj.constants.SamplingRate):((obj.constants.BufferSize-1)/obj.constants.SamplingRate))).';
            noteTime=timeVec-obj.note.startTime;
            
            %mask = obj.EnvGen.advance;
            mask = step(obj.EnvGen);
            if isempty(mask)
                audio=[];
            else
                if all (mask == 0)
                    audio = zeros(1,obj.constants.BufferSize).';
                else
                    audio=obj.note.amplitude.*mask(:).*sin(2*pi*obj.note.frequency*timeVec);
                end
            end
            obj.currentTime=obj.currentTime+(obj.constants.BufferSize/obj.constants.SamplingRate);      % Advance the internal time

        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            % Reset the time function
            obj.currentTime=0;
        end
    end
end

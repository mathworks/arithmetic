classdef addLiveTask < matlab.task.LiveTask
    properties(Access = private,Transient)
        
    end    
    properties(Dependent)
        State
        Summary
    end    
    methods(Access = protected)      
        function setup(task) %#ok<*MANU>
            
        end
    end    
    methods
        function [code,outputs] = generateCode(task)
            code = "";
            outputs = {};
        end

        function summary = get.Summary(task)
            summary = "Task summary";
        end
        
        function state = get.State(task)
            state = struct;
        end
        
        function set.State(task,state) %#ok<*INUSD>
            
        end
	
        function reset(task)
            
        end
    end
end
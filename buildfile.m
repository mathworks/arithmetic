function plan = buildfile
    % Create a plan from the task functions
    plan = buildplan(localfunctions);
    
    % Make the "test" task the default task in the plan
    plan.DefaultTasks = "test";

    % Make the "release" task dependent on the "check" and "test" tasks
    plan("release").Dependencies = ["check" "test"];
end
    
    function checkTask(~)
        % Identify code issues
        issues = codeIssues;
        assert(isempty(issues.Issues),formattedDisplayText( ...
            issues.Issues(:,["Location" "Severity" "Description"])))
    end
    
    function testTask(~)
        % Run unit tests
        results = runtests(IncludeSubfolders=true,OutputDetail="terse");
        assertSuccess(results);
    end
    
    function releaseTask(~)
        % Create a release and put it in the release directory
        opts = matlab.addons.toolbox.ToolboxOptions("toolboxPackaging.prj");
        % By default, the packaging GUI restricts the name of the getting started guide, so we fix that here.
        opts.ToolboxGettingStartedGuide = fullfile("toolbox", "gettingStarted.mlx");
        matlab.addons.toolbox.packageToolbox(opts);
        movefile(opts.ToolboxName + ".mltbx","release")
    end
    
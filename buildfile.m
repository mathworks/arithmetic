function plan = buildfile
% Create a plan from the task functions
plan = buildplan(localfunctions);

% Define the "clean" Task
plan("clean") = matlab.buildtool.tasks.CleanTask;

% Output folder for MEX functions
mexOutputFolder = fullfile("toolbox","derived");

% Compile Cpp source code within cpp/*Mex into MEX functions
foldersToMex = plan.files(fullfile("cpp", "*Mex")).select(@isfolder);
for folder = foldersToMex.paths
    [~, folderName] = fileparts(folder);
    plan("build:mex:"+folderName) = matlab.buildtool.tasks.MexTask(fullfile(folder, "**/*.cpp"), ...
        mexOutputFolder, ...
        Filename=folderName);
end
plan("build:mex").Description = "Build MEX functions";
plan("build").Description = "Build the toolbox";

% Define the "check" task
sourceFolder = files(plan, "toolbox");
plan("validate:check") = matlab.buildtool.tasks.CodeIssuesTask(sourceFolder,...
    IncludeSubfolders = true);

% Define the "test" task
testsFolder = files(plan, "tests");
plan("validate:test") = matlab.buildtool.tasks.TestTask(testsFolder,...
    IncludeSubfolders = true, OutputDetail = "terse");


plan("validate:dependency") = matlab.buildtool.Task();
plan("validate:dependency").Actions = @dependencyAnalysis;

plan("validate").Description = "Validate the toolbox";

% Make the "test" task the default task in the plan
plan.DefaultTasks = "build";

% Make the "release" task dependent on the "check" and "test" tasks
plan("package").Dependencies = ["build" "validate"];
plan("package").Outputs = "release\Arithmetic_Toolbox.mltbx";
end

function packageTask(~)
% Create an MLTBX package
releaseFolderName = "release";
if isMATLABReleaseOlderThan("R2025a")
    % Toolbox packaging metadata migrated from packaging prj to project prj
    % in 25a.
    opts = matlab.addons.toolbox.ToolboxOptions("toolboxPackaging.prj");
else
    % Create a release and put it in the release directory
    opts = matlab.addons.toolbox.ToolboxOptions("arithmetic.prj");
end

% By default, the packaging GUI restricts the name of the getting started guide, so we fix that here.
opts.ToolboxGettingStartedGuide = fullfile("toolbox", "gettingStarted.mlx");

% GitHub releases don't allow spaces, so replace spaces with underscores
mltbxFileName = strrep(opts.ToolboxName," ","_") + ".mltbx";
opts.OutputFile = fullfile(releaseFolderName,mltbxFileName);

% Create the release directory, if needed
if ~exist(releaseFolderName,"dir")
    mkdir(releaseFolderName)
end
matlab.addons.toolbox.packageToolbox(opts);
end
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
    % Create a task group for 
    plan("build:mex:"+folderName) = matlab.buildtool.tasks.MexTask(fullfile(folder, "**/*.cpp"), ...
        mexOutputFolder, ...
        Filename=folderName);
end
plan("build:mex").Description = "Build MEX functions";
plan("build").Description = "Build the toolbox";

% Define the "check" task as a sub task of "validate"
sourceFolder = files(plan, "toolbox");

plan("validate:dependency")=matlab.buildtool.Task;
plan("validate:dependency").Description = "Run dependency analysis";
plan("validate:dependency").Actions = @dependencyAnalysis;
plan("validate:dependency").Outputs = "dependencycache.graphml";

plan("validate:check") = matlab.buildtool.tasks.CodeIssuesTask(sourceFolder,...
    IncludeSubfolders = true);

% Define the "test" task as a sub task of "validate" 
testsFolder = files(plan, "tests");
plan("validate:test") = matlab.buildtool.tasks.TestTask(testsFolder,...
    IncludeSubfolders = true, OutputDetail = "terse");


plan("validate").Description = "Validate the toolbox";

% Make "build" task group the default task
plan.DefaultTasks = "build";

% Make the "validate" task dependent on "build" task group
plan("validate").Dependencies = "build";

% Make the "package" task dependent on "validate" task group
plan("package").Dependencies = "validate";
plan("package").Outputs = fullfile("release","Arithmetic_Toolbox.mltbx");
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


function dependencyAnalysis(~)
prj = currentProject();
updateDependencies(prj);

% Read the dependency cache and list missing files
doc = xmlread("dependencycache.graphml");
keys = doc.getElementsByTagName("key");
nodes = doc.getElementsByTagName("node");

% Build dictionaries mapping key id to attr.name, grouped by element type
nodeKeys = dictionary;
edgeKeys = dictionary;
graphKeys = dictionary;
for i = 0:keys.getLength()-1
    elem = keys.item(i);
    keyId = string(elem.getAttribute("id"));
    attrName = string(elem.getAttribute("attr.name"));
    keyFor = string(elem.getAttribute("for"));
    switch keyFor
        case "node"
            nodeKeys(keyId) = attrName;
        case "edge"
            edgeKeys(keyId) = attrName;
        case "graph"
            graphKeys(keyId) = attrName;
    end
end

missingFiles = {};
requiredProducts = {};
for i = 0:nodes.getLength()-1
    eachNode = nodes.item(i).getElementsByTagName("data");

    nodePath = "";
    nodeType = "";
    for j = 0:eachNode.getLength()-1
        data = eachNode.item(j);
        key = string(data.getAttribute("key"));
        value = string(data.getTextContent());
        if nodeKeys(key) == "node.path"
            nodePath = value;
        end
        if nodeKeys(key) == "node.type"
            nodeType = value;
        end
    end

    if nodeType == "Product"
        requiredProducts{end+1} = nodePath;
        continue
    end

    if startsWith(nodePath, "$/")
        % Project file - check if it exists on disk
        relPath = extractAfter(nodePath, "$/");
        if ~isfile(relPath)
            missingFiles{end+1} = relPath; 
        end
    else
        % External unresolved dependency
        missingFiles{end+1} = nodePath;
    end
end

fprintf("  Required products (%d):\n", numel(requiredProducts));
for i = 1:numel(requiredProducts)
    fprintf("    %s\n", requiredProducts{i});
end

if isempty(missingFiles)
    fprintf("  Package is complete no missing files.\n");
else
    fprintf("  Missing Files (%d):\n", numel(missingFiles));
    for i = 1:numel(missingFiles)
        fprintf("    %s\n", missingFiles{i});
    end
end
end
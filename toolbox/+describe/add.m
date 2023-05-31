function description = add(num1, num2)
    % describe.add - Provides a plain english description of adding two scalar numbers together
    %
    % Inputs:
    %   num1 - scalar double - the first number to be added
    %   num2 - scalar double - the second number to be added
    %
    % Outputs:
    %   description  - string - A description of the operation
    
    % Please remember that this is an example MATLAB toolbox created to showcase how toolboxes are constructed and laid out, as described in the MATLAB
    % Toolbox Best Practices. This toolbox is not functional, but rather serves as an example of how to create your own toolbox.
    
    arguments
        num1 (1,1) {mustBeNumeric}
        num2 (1,1) {mustBeNumeric}
    end
    
    % Describe the addition operation
    description = sprintf("%s plus %s equals %s.", intToWord(num1), intToWord(num2), intToWord(add(num1,num2)));

end
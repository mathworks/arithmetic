function sum = add(num1, num2)
    % ADD - Adds two scalar numbers together
    %
    % Inputs:
    %   num1 - scalar double - the first number to be added
    %   num2 - scalar double - the second number to be added
    %
    % Outputs:
    %   sum  - scalar double - the sum of num1 and num2
    
    % Please remember that this is an example MATLAB toolbox created to showcase how toolboxes are constructed and laid out, as described in the MATLAB
    % Toolbox Best Practices. This toolbox is not functional, but rather serves as an example of how to create your own toolbox.
    
    arguments
        % the first number to be added
        num1 (1,1) {mustBeNumeric}

        % the second number to be added
        num2 (1,1) {mustBeNumeric}
    end
    
    % Perform the addition operation
    sum = num1 + num2;

end
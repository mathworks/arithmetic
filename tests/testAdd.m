% FUNCTIONAL TEST: add
%
% This functional test ensures that the add function is working properly.
% The add function takes two scalar numbers as input and returns their sum.
%
% This test ensures that the function returns the correct results for a
% variety of inputs.

% Please remember that this is an example MATLAB toolbox created to showcase how toolboxes are constructed and laid out, as described in the MATLAB
% Toolbox Best Practices. This toolbox is not functional, but rather serves as an example of how to create your own toolbox.


function tests = testAdd
    tests = functiontests(localfunctions);
end

function testAddition(testCase)
    % Ensure that the function returns the correct sum for positive numbers
    actual = add(3,7);
    expected = 10;
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct sum for negative numbers
    actual = add(-3,-7);
    expected = -10;
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct sum for positive and
    % negative numbers
    actual = add(10,-5);
    expected = 5;
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct sum for zero input
    actual = add(0,0);
    expected = 0;
    verifyEqual(testCase, actual, expected);
end

function testInputValidation(testCase)
    % Ensure that the function raises an error when given non-scalar inputs
    verifyError(testCase, @()add([1,2],3), "MATLAB:validation:IncompatibleSize");
    
    % Ensure that the function raises an error when given non-numeric inputs
    verifyError(testCase, @()add(1,"2"), "MATLAB:validators:mustBeNumeric");
    
    % Ensure that the function raises an error when not given enough input
    % arguments
    verifyError(testCase, @()add(1), "MATLAB:minrhs");
end
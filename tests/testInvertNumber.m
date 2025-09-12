% FUNCTIONAL TEST: invertNumber
%
% This functional test ensures that the invertNumber function is working properly.
% The invertNumber function takes a scalar/ vercor of numbers as input and returns their inverse.
%
% This test ensures that the function returns the correct results for a
% variety of inputs.

% Please remember that this is an example MATLAB toolbox created to showcase how toolboxes are constructed and laid out, as described in the MATLAB
% Toolbox Best Practices. This toolbox is not functional, but rather serves as an example of how to create your own toolbox.


function tests = testInvertNumber
    tests = functiontests(localfunctions);
end

function testInverse(testCase)
    % Ensure that the function returns the correct inverse for positive numbers
    actual = invertNumber(5);
    expected = 0.2;
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct inverse for negative numbers
    actual = invertNumber(-5);
    expected = -0.2;
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct inverse for zero input
    actual = invertNumber(0);
    expected = Inf;
    verifyEqual(testCase, actual, expected);

    % Ensure that the function returns the correct inverse for NaN
    actual = invertNumber(NaN);
    expected = NaN;
    verifyEqual(testCase, actual, expected);
end

function testInputValidation(testCase)
    % % Ensure that the function raises an error when given non-scalar inputs
    % verifyError(testCase, @()add([1,2],3), "MATLAB:validation:IncompatibleSize");

    % Ensure that the function raises an error when given non-numeric inputs
    verifyError(testCase, @()invertNumber("2"), "MATLAB:validators:mustBeNumeric");

    % Ensure that the function raises an error when not given enough input
    % arguments
    verifyError(testCase, @()invertNumber(), "MATLAB:minrhs");
end
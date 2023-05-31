% FUNCTIONAL TEST: intToWord
%
% This functional test ensures that the intToWord function is working
% properly. The intToWord function takes an integer as input and returns its
% English word representation as a string.
% 
% This test ensures that the function returns the correct results for a
% variety of inputs.

function tests = testIntToWord
    tests = functiontests(localfunctions);
end

function testOnesPlace(testCase)
    % Ensure that the function returns the correct English word for ones
    % place numbers
    actual = intToWord(3);
    expected = "three";
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct English word for zero
    actual = intToWord(0);
    expected = "zero";
    verifyEqual(testCase, actual, expected);
end

function testTensPlace(testCase)
    % Ensure that the function returns the correct English word for tens
    % place numbers
    actual = intToWord(20);
    expected = "twenty";
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct English word for "teen"
    % numbers
    actual = intToWord(13);
    expected = "thirteen";
    verifyEqual(testCase, actual, expected);
end

function testHundredsPlace(testCase)
    % Ensure that the function returns the correct English word for
    % hundreds place numbers
    actual = intToWord(345);
    expected = "three hundred forty-five";
    verifyEqual(testCase, actual, expected);
    
    % Ensure that the function returns the correct English word for a
    % number with a zero in the tens place
    actual = intToWord(107);
    expected = "one hundred seven";
    verifyEqual(testCase, actual, expected);
end

function testNegative(testCase)
    % Ensure that the function returns the correct English word for
    % negative numbers
    actual = intToWord(-345);
    expected = "negative three hundred forty-five";
    verifyEqual(testCase, actual, expected);
    
    actual = intToWord(-13);
    expected = "negative thirteen";
    verifyEqual(testCase, actual, expected);

    actual = intToWord(-20);
    expected = "negative twenty";
    verifyEqual(testCase, actual, expected);
end

function testOutOfRange(testCase)
    % Ensure that the function returns a string with the numbers with
    % more than three digits
    actual = intToWord(1000);
    expected = "1000";
    verifyEqual(testCase, actual, expected);
end
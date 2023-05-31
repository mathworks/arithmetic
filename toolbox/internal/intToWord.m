function word = intToWord(num)
    % INTTOWORD - Converts an integer to its English word representation
    % 
    % This function takes an integer as input and returns its written English word representation as a string. It can handle numbers between -999 and
    % 999. The function first defines arrays `onesWords`, `tensWords`, and `teenWords` that contain the English words for the numbers 0-9, 10-90 in
    % increments of 10, and 10-19 respectively. It then handles special cases for the numbers 0 and negative numbers. The function then breaks the
    % input number into its digits and uses the numbers' positions to determine its appropriate translation. It concatenates the words for each digit
    % to form the final output string. Any number with more than three digits is not supported and will return the number as a string.
    %
    % Inputs:
    %   num - integer - the number to convert to English word
    %
    % Outputs:
    %   word - string - the English word representation of num
    
    % Define lookup tables for words
    onesWords = {'', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'};
    tensWords = {'', 'ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};
    teenWords = {'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'};
    
    % Handle special cases
    if num == 0
        word = "zero";
        return
    elseif num < 0
        word = "negative " + intToWord(abs(num));
        return
    end

    if num ~= round(num)
        % value isn't an integer
        word = string(num);
        return
    end
    
    % Convert number to string and determine its length
    strNum = num2str(num);
    n = length(strNum);
    
    % Use different methods depending on the length of the number
    switch n
        case 1 % Ones place
            word = onesWords{num+1};
        case 2 % Tens and ones places
            if strNum(1) == '1'
                word = teenWords{str2double(strNum(2))+1};
            else
                if strNum(2) == '0'
                    word = tensWords{str2double(strNum(1))+1};
                else
                    word = [tensWords{str2double(strNum(1))+1} '-' onesWords{str2double(strNum(2))+1}];
                end
            end
        case 3 % Hundreds, tens, and ones places
            if strNum(2) == '1'
                word = [onesWords{str2double(strNum(1))+1} ' hundred ' teenWords{str2double(strNum(3))+1}];
            else
                word = [onesWords{str2double(strNum(1))+1} ' hundred ' tensWords{str2double(strNum(2))+1}];
                if strNum(3) ~= '0'
                    if strNum(2) ~= '0'
                        word = [word '-' onesWords{str2double(strNum(3))+1}];
                    else
                        word = [word onesWords{str2double(strNum(3))+1}];
                    end
                end
            end
        otherwise % Numbers with more than three digits are not supported
            word = string(num);
            return
    end
    word = string(word);
end
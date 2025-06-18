function invertedNumber = invertNumber(numberToInvert)
arguments
    numberToInvert(1,:) double;
end
mh = mexhost();
invertedNumber = mh.feval("invertMex", numberToInvert);
end
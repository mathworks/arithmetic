function invertedNumber = invertNumber(numberToInvert)
arguments
    numberToInvert(1,:) {mustBeNumeric};
end
mh = mexhost();
invertedNumber = mh.feval("invertMex", numberToInvert);
end
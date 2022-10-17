function [map_t, map_s] = segmentator(sci)
%segmentor segments an SCI to textual and pictorial regions.
%   'map_t' and 'map_s', the outputs of the function, are two binary maps
%   which are eachothers' complement. Where 'map_t' is one, there is text
%   in the input SCI. Where 'map_t' is zero, there is natural scene in the
%   input SCI. ('map_s' is the complement of 'map_t'. It isn't anything
%   significant: >> map_s = ~map_t;)
ocrResults = ocr(sci);
[rows, cols, ~] = size(sci);
map_t = logical(zeros(rows, cols));
pointers = find(~(isnan(ocrResults.CharacterConfidences)));
for ii = 1:length(pointers)
    info = ocrResults.CharacterBoundingBoxes(ii,:);
    y = info(1);
    x = info(2);
    w = info(3);
    h = info(4);
    map_t(x:(x+h-2), y:(y+w-2)) = true;
end
map_t = map_t(2:end-1, 2:end-1);
map_s = ~map_t;
end


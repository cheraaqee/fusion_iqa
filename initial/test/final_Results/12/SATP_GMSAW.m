function feactor = SATP_GMSAW(ref_in,dst_in)
%SATP extracts a feature vector for the distorted SCI.
%   The reference and distorted SCI are the inputs, a vector is the output.
%   The 'txt_evaluator' and 'pic_evaluator' are two FR methods espacilized
%   for document images and natural images, respectively. They must return
%   a similarity map, or a similarity map and a weight map. The dimenstions
%   of these maps must be equal to dimenstions of the original image minus
%   one. 'SATP_GMSA' differs with 'SATP' in the pooling of GMS values. 'SATP'
%   follows the GMSD approach, std, here we are averaging them. (Because we
%   thought the two score are better to monotonic.
%   'SATP_GMSAW' is 'SATP_GMSA', but it averages GMS values with the
%   maximum gradient magnitude.

txt_evaluator = 'LBPSI_m';
pic_evaluator = 'GMSD_m';
%% indexes of pixels belonging to text and picture
[map_t, map_p] = segmentator(ref_in);
indexes_txt = find(map_t);
indexes_pic = find(map_p);
%% computing the similarity score for each textual and pictorial pixel
[~, similarity_map_textual, weight_map_textual ] = feval(txt_evaluator, ...
    ref_in, dst_in);
[~, similarity_map_pictorial] = feval(pic_evaluator, ref_in, dst_in);
%% pooling the score of pictorial region
if ~isempty(indexes_pic)
    scores_pic = similarity_map_pictorial(indexes_pic);
    score_pic = mean(scores_pic);
else
    score_pic = mean(similarity_map_pictorial(:));
end
%% pooling the score of textual region
if ~isempty(indexes_txt)% in case no text is found in the image!
    scores_txt = similarity_map_textual(indexes_txt).*...
        weight_map_textual(indexes_txt);
    score_txt = sum(scores_txt)/sum(weight_map_textual(indexes_txt));
else
    scores_txt = similarity_map_textual.*weight_map_textual;
    score_txt = sum(sum(scores_txt))/sum(sum(weight_map_textual));
end
%% the feature vector
feactor = [score_pic, score_txt];
% feactor = (score_pic+score_txt)/2;
end


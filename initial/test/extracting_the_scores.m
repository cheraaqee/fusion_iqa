clear
clc
for ii = 1:14
    load(['./coma_dst/round2/dst_comma_SCID/',num2str(ii),'/coma_dst_wise.mat']);
    dst_3_values_14_SCID(:,:,ii) = coma_dst_wise(:,:,ii);
end
save('dst_3_values_14_SCID.mat', 'dst_3_values_14_SCID');
for ii = 1:14
    load(['./coma_dst/round2/dst_comma_SIQAD/',num2str(ii),'/coma_dst_wise.mat']);
    dst_3_values_14_SIQAD(:,:,ii) = coma_dst_wise(:,:,ii);
end
save('dst_3_values_14_SIQAD.mat', 'dst_3_values_14_SIQAD');
for ii = 1:14
    load(['./coma_dst/round2/dst_comma_SCID/',num2str(ii),'/coma_dst_wise.mat']);
    tabular_SCID_cg(:,ii) = coma_dst_wise(:,3,ii);
end

for ii = 1:14
    load(['./coma_dst/round2/dst_comma_SIQAD/',num2str(ii),'/coma_dst_wise.mat']);
    tabular_SIQAD_cg(:,ii) = coma_dst_wise(:,3,ii);
end
load('tabular_whole_SCID.mat');
load('tabular_whole_SIQAD.mat');
tabular_SCID_cg(10,:) = tabular_whole_SCID(10,2:end);
tabular_SIQAD_cg(8,:) = tabular_whole_SIQAD(8,2:end);
save('tabular_SCID_cg.mat', 'tabular_SCID_cg');
save('tabular_SIQAD_cg.mat', 'tabular_SIQAD_cg');
tabular_whole_SCID_cg = zeros(10,15);
tabular_whole_SCID_cg(:,1) = tabular_whole_SCID(:,1);
tabular_whole_SCID_cg(:,2:end) = tabular_SCID_cg(:,:);
tabular_whole_SIQAD_cg = zeros(8,15);
tabular_whole_SIQAD_cg(:,1) = tabular_whole_SIQAD(:,1);
tabular_whole_SIQAD_cg(:,2:end) = tabular_SIQAD_cg(:,:);
save('tabular_whole_SCID_cg.mat','tabular_whole_SCID_cg');
save('tabular_whole_SIQAD_cg.mat', 'tabular_whole_SIQAD_cg');
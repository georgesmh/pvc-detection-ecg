clear all;
clc;

recs = [100, 101, 103, 105:109, 111:113, 115:119, 121:124, 200:203, 205, 207:210, 212:215, 217, 219:223, 228, 230, 231, 234];% 111:119, 121:124, 200, 201, 202, 203];
% recs = 205;
for ind = 1:length(recs)
    rec = recs(ind);
    [qrs_pos,filt_dat,int_data,testdata, ANNOTD, TIME, ATRTIMED] = Process(num2str(rec));

%     
%  for i=1:length(qrs_pos)
%      sample_nb = qrs_pos(i);
%      if(sample_nb-99>0 && sample_nb+100<numel(int_data))
%      vec(:,i,ind) = int_data(sample_nb-99:sample_nb+100);
%      
%      end
%  end
%  
% end
pvc_indices = find((ANNOTD==5));
normal_indices = find((ANNOTD==1));
toExtract = 100;
if(length(normal_indices)>toExtract)
    normal_indices = normal_indices(1:toExtract);
end

for j=1:length(ATRTIMED)
    x(j) = find(TIME==ATRTIMED(j));
end


for i=1:length(pvc_indices)
    pvc_index = pvc_indices(i);

if(pvc_index<0 || pvc_index>numel(qrs_pos))
        continue;
    end
    sample_nb = qrs_pos(pvc_index);
     if(sample_nb-99>0 && sample_nb+100<numel(int_data))

             vec(:,i,ind) = int_data(sample_nb-99:sample_nb+100);
    end
end


for i=1:length(normal_indices)
    normal_index = normal_indices(i);

if( normal_index<0 ||  normal_index>numel(qrs_pos))
        continue;
end
    sample_nb_normal = qrs_pos(normal_index);
    if(sample_nb_normal-99>0 && sample_nb_normal+100<numel(int_data))
    vecN(:,i, ind) = int_data(sample_nb_normal-99:sample_nb_normal+100);
    end
end

end


C = reshape(vec,[],size(vec,1),1);
CN = reshape(vecN,[],size(vecN,1),1);
if(size(C,1)<size(CN,1))
    CN = C(1:size(C,1)*0.2, :);
else
    C = CN(1:size(CN,1)*0.2, :);
end
E = [zeros(1, size(C,1)), ones(1, size(CN,1))];
D = [C; CN];
D = D';
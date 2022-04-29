%{
encode discrete (categorical) data entries
%}


clear;clc;close all

addpath('original data')


T = readtable('incomeDB.csv','PreserveVariableNames',true);
T_original = T;

[row_num,col_num] = size(T);

atts = T.Properties.VariableNames;

for c = 1:col_num
    if strcmp(  class(T{:,c}),'cell'   )
        att_list = unique(T{:,c});
        code_length = length(att_list);
        for i = 1:code_length
            idx =  find(  strcmp(T{:,c}, cellstr(att_list{i})) ==1    );
            T{idx ,  c}={i-1};
        end
    end
end

for i = 1:width(T), if iscell(T.(i)), T.(i) = cell2mat(T.(i)); end, end

id = [1:row_num]';
T_id = table(id);
T = [T_id T];

%% quanitze age attributes
[GC,GR] = groupcounts(T.age) ;count_value = [GC,GR];

T.age(  find( T.age<=20  )  ) = 0;
T.age(  intersect(  find( T.age>20  ) , find( T.age<=30 )  )   ) =1;
T.age(  intersect(  find( T.age>30  ) , find( T.age<=40 )  )   ) =2;
T.age(  intersect(  find( T.age>40  ) , find( T.age<=50 )  )   ) =3;
T.age(  intersect(  find( T.age>50  ) , find( T.age<=60 )  )   ) =4;
T.age(  intersect(  find( T.age>60  ) , find( T.age<=70 )  )   ) =5;
T.age(  find( T.age>70  )   ) =6;

%% workclass is categorical variable, which has been coded
[GC,GR] = groupcounts(T.workclass) ;count_value = [GC,GR];

%% quantize (remove) fnlwgt attributes
%{
fnlwgt: final weight. In other words, this is the number of people the census believes
the entry represents.
%}
[GC,GR] = groupcounts(T.fnlwgt) ;count_value = [GC,GR];
T = removevars(T,{'fnlwgt'});

%% education is categorical variable, which has been coded
[GC,GR] = groupcounts(T.education) ;count_value = [GC,GR];

%% quanitze age attributes
[GC,GR] = groupcounts(T.('education_num')) ;count_value = [GC,GR];

T.('education_num')(  find( T.('education_num')<=4  )  ) = 0;
T.('education_num')(  intersect(  find( T.('education_num')>4  ) , find( T.('education_num')<=8 )  )   ) =1;
T.('education_num')(  intersect(  find( T.('education_num')>8  ) , find( T.('education_num')<=12 )  )   ) =2;
T.('education_num')(   find( T.('education_num')>12  )    ) =3;


%% marital_status is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('marital_status')) ;count_value = [GC,GR];


%% occupation is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('occupation')) ;count_value = [GC,GR];


%% relationship is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('relationship')) ;count_value = [GC,GR];

%% race is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('race')) ;count_value = [GC,GR];

%% sex is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('sex')) ;count_value = [GC,GR];

%% binarize capital_gain as 29849 out of 32561 are '0'
[GC,GR] = groupcounts(T.('capital_gain')) ;count_value = [GC,GR];
T.('capital_gain')( find(T.('capital_gain')>0)  )=1;


%% binarize capital_loss as 31042 out of 32561 are '0'
[GC,GR] = groupcounts(T.('capital_loss')) ;count_value = [GC,GR];
T.('capital_loss')( find(T.('capital_loss')>0)  )=1;

%% encode hours_per_week into 0-9
[GC,GR] = groupcounts(T.('hours_per_week')) ;count_value = [GC,GR];

T.('hours_per_week')(  find( T.('hours_per_week')<=10  )  ) = 0;
T.('hours_per_week')(  find( T.('hours_per_week')>90  )  ) = 9;
for i = 1:8
    T.('hours_per_week')(  intersect(  find( T.('hours_per_week')>i*10  ) , find( T.('hours_per_week')<=(i+1)*10 )  )   ) =i;
end

%% native_country is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('native_country')) ;count_value = [GC,GR];

%% 50K is categorical variable, which has been coded
[GC,GR] = groupcounts(T.('50K')) ;count_value = [GC,GR];

incomeDB = T;


%% get the publically available distributions
addpath('functions')
atts = T.Properties.VariableNames;
[row_num,col_num] = size(T);

s_atts_ins = struct();
for i = 2:col_num-1
    s_atts_ins.(atts{i}) = unique(T.(atts{i}));
end
[marginals_public,joints_public] = empirical_distributions(T,s_atts_ins);
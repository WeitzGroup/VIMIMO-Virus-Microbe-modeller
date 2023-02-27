function [indicator_i,indicator_j] = name_matrix_function(name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
name_matrix_var = cell(5,5);

name_matrix_var{1,2} = "CBA18-3_4";
name_matrix_var{2,1} = "CBA18-2_18";
name_matrix_var{2,2} = "CBA18-3_18";
name_matrix_var{2,3} = "CBA38-1_38";
name_matrix_var{4,4} = "HP1_H100";
name_matrix_var{4,5} = "HS6_H100";
name_matrix_var{5,4} = "HP1_13-15";
name_matrix_var{5,5} = "HS6_13-15";

name_matrix_var{1,1} = "NaN";
name_matrix_var{1,3} = "NaN";
name_matrix_var{1,4} = "NaN";
name_matrix_var{1,5} = "NaN";
name_matrix_var{2,4} = "NaN";
name_matrix_var{2,5} = "NaN";
name_matrix_var{3,1} = "NaN";
name_matrix_var{3,2} = "NaN";
name_matrix_var{3,4} = "NaN";
name_matrix_var{3,5} = "NaN";
name_matrix_var{4,1} = "NaN";
name_matrix_var{4,2} = "NaN";
name_matrix_var{4,3} = "NaN";
name_matrix_var{5,1} = "NaN";
name_matrix_var{5,2} = "NaN";
name_matrix_var{5,3} = "NaN";

for i=1:5
    for j=1:5
        if strcmp(string(name_matrix_var{i,j}) ,name)
            indicator_i = i;
            indicator_j = j;
        end

    end
end

end


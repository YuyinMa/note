clear all
close all
clc
load Projectfile

% if (t==1)
% Nant                  Number of ants in a generation          400
% empnum                number of the employees                 10
% tasknum               number of the tasks                     10
solution = struct([]);
for k=1:1:Nant
    for i=1:1:empnum
        for j=1:1:tasknum
            % do we consider default value -1?
            if ((length(unique(employee(i).skill)))>=(length(unique(task(j).skill))))
                a = 0; % Leveling
                b1 = employee(i).max;
                solution(k).ant(i,j)= (b1-a).*rand + a;% Xij for the fitness function
            else
                solution(k).ant(i,j)=0;
            end
        end
    end
end
%end

% if t>1
% clear all
% close all
% clc
% load Parentsfile
% 
% for k=1:1:Nant
%     for i=1:1:empnum
%         for j=1:1:tasknum
%             if ((length(unique(employee(i).skill)))>=(length(unique(task(j).skill))))%?????????????? ???? ???????????? ???? ?????????? ?????? ??????????????????????????
%                 if (solution(k).ant(i,j)<=(employee(i).max-0.05))
%                     solution(k).ant(i,j)=solution(k).ant(i,j)+0.05;
%                 end
%             end            
%         end
%     end
% end
 

save ('Populationfile','solution');

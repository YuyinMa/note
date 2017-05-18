clear all
close all
load Projectfile
load Populationfile
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% taskdur %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:1:Nant
    solution(k).taskdur = zeros(1,tasknum);
    for j=1:1:tasknum   % 30
       sumtas = 0;
       for i=1:1:empnum % 15
           % param 1 should be i here
           sumtas = sumtas + solution(1).ant(i,j);
       end
       solution(k).taskdur(j) = task(j).effort/sumtas; 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% taskcost %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:1:Nant
    solution(k).taskcost = zeros(1,tasknum);
    for j=1:1:tasknum
       sumtas=0;
       for i=1:1:empnum
           sumtas = sumtas+(employee(i).salary)*(solution(k).ant(i,j))*solution(k).taskdur(j);       
       end
       solution(k).taskcost(j) =sumtas; 
    end
end

%%%%%%%%%%%%%%%%%%%% Project Cost %%%%%%%%%%%%%%%%%%%%%%%
Pcost = zeros(1,Nant);
for k=1:1:Nant
    for i = 1:1:empnum
        for j=1:1:tasknum
            Pcost(k) = Pcost(k)+(employee(i).salary)*(solution(k).ant(i,j))*(solution(k).taskcost(j));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Critical Paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CPM = struct([]);

for k=1:1:Nant
    CPM(k).longpath=[];
    for i=1:(size(G1,1))
        for j=1:(size(G1,1))
            G1(i,j)=G1(i,j)*solution(k).taskdur(j);
        end
    end
    
    % CREATE Pseudo-Start & Pseudo-End NODES
    G = [zeros(tasknum,1) G1 0.0001*ones(tasknum,1)];
    G = [[0 (ones(1,tasknum)*0.0001) 0]
       G 
       0 0*ones(1,tasknum) 0];
    G(1,tasknum+2)=0.0001;
    
    % find all paths Analytic
    [Pq,tpath,plq,qstop,allpths,util] = findpaths(G,1,500,1);

    % Critical Path
    CPMpath = allpths(:,end);
    CPM(k).longpath = CPMpath;
end

% Project duration
Pdur = zeros(1,Nant);
for k=1:1:Nant
   for   len2=1:(size(CPM(k).longpath,1)-1)
       if ((CPM(k).longpath(len2)==1) ||(CPM(k).longpath(len2)==tasknum+2))
           Pdur(k)=Pdur(k);       
       else
           Pdur(k)=Pdur(k)+ solution(k).taskcost(CPM(k).longpath(len2-1));
       end
   end
end

xov  = zeros(1,empnum);
xov1 = zeros(1,empnum);
xov2 = zeros(1,empnum);

% Project Overwork
Pover = zeros(1,Nant);
for k=1:1:Nant
    for i=1:1:empnum
        xov(i)=sum(solution(k).ant(i,:));
        xov1(i)=(employee(i).max)*Pdur(k);
        if (xov(i)-xov1(i))<=0
           xov2(i)=0; 
        end
        if (xov(i)-xov1(i))>0
            xov2(i)=xov(i)-xov1(i);
        end
    end
    Pover(k) = sum(xov2(i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CPM           critical path map
% CPMpath       critical path map
% G             G1 add Pseudo-Start & Pseudo-End NODES
% Pcost         Project cost
% Pdur          Project duration
% Pover         Project overwork                error: all 0
% allpths       findpaths return value
% solution      
% tpath         findpaths return value
save('Pherofile','CPM','CPMpath','G','Pcost','Pdur','Pover','allpths','solution','tpath');



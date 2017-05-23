%%%%%%%%%%%%% initialization %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
InitialInstances;                   % prepare data
GenerateInitialPopulation;          % generate solution
Selection_EvolutionaryOperators;    % calc solution score, find path
clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Algorithm %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Projectfile    % step 1
load Pherofile      % step 3
t=1; save('tfile','t');
% Ngen                Generation number           15
while (t<=Ngen)
    load Projectfile
    load Pherofile
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% Fitness %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Evaluate_Population = zeros(1,Nant);
    Position = zeros(1,Nant);
    for k=1:1:Nant
        Pover1 = Pover(k); Pdur1 = Pdur(k); Pcost1 = Pcost(k);
        Evaluate_Population(k) = EvaluateObjectives(Pover1,Pdur1,Pcost1,wcost,wdur,wpenal,wundt,wreqsk,wover); 
        Position(k) = k;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%Sorting Population(Selection)%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    IEv=[Evaluate_Population
         Position];
    [Y,Index] = sort(IEv(1,:));
    Best = IEv(:,Index); %use the column indices from sort() to sort all columns of IEv.
    save('Parentsfile','solution','Best','Index','Nant','employee','task','empnum','tasknum');
    clear all
    close all
    clc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Mutation & Crossover %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    UpdatePopulation;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% Update Pareto Set %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Selection_EvolutionaryOperators;    % step 3
    load tfile
    t=t+1;
    save('tfile','t');
    load Projectfile
end
clear all

ReturnBestSolution;
delete ('*.mat')
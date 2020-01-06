clc;
close all;
clear all;
global nfe;
nfe=0;

%% parameters of LPO
mc0=2;
ths = 20; %stagnation threshold
thls = 40; %long stagnation threshold
k1 = 1000; %algorithm parameter (used in changespace)
k2 = 5; %algorithm parameter (used in changespace)

nmember=40; %number of members
nvar=4; %number of variables of equations
max_iter=100; %maximum iterations of algorithm

%% initial values
L0=2; %original length of search space
stagnation_times = 0;%stagnation times
long_stagnation_times = 0;%long stagnation times
num_changespace=0; %changespace times
best_cost=zeros(max_iter,1);
nfe_best_cost=zeros(max_iter,1);

member.pos=[];
member.cost=[];
pride=repmat(member,nmember,1);

%% generete initial pride
for k=1:nmember
    pride(k).pos=unifrnd(-1,1,[1 nvar]);
    pride(k).cost=fitness(pride(k).pos);
end

bestlion1 = pride(1);
bestlion2 = pride(2);
best_cost_prv=Inf;

%% main loop of LPO
for k=1:max_iter
    
    % %     select two best member of current generation using formula (1)
    [a,b]=sort([pride.cost]);
    best1 = pride(b(1));
    best2 = pride(b(2));
    
    % %     scaling of searching space
    if(best1.cost<bestlion1.cost)
        bestlion1 = best1;
        bestlion2 = best2;
    else
        bestlion2=best1;
    end
    
    % %     Replace worst member of this generation with the saved best member
    pride(b(nmember))=bestlion1;
    
    % %     For (each member in the pride), reproduce four children for each pair using (2)
    pride = crossover(bestlion1,bestlion2,pride,mc0);
    
    % %     Select the potentially best evolution directions using (6)
    % %     Search in the potentially best evolution directions for better member using (7)
    [bestlion1,bestlion2] = optimize(pride,bestlion1,bestlion2,L0,k);
    
    best_cost(k)=bestlion1.cost;
    
    % %     Select the best members to the next generation using (4)
    [a,b]=sort([pride.cost]);
    pride = pride(b(1:nmember)); %selection
    
    stagnation_times=stagnation_times+1
    
    % %     change the search space using formula (5)
    if(stagnation_times>ths)
        pride = changeSpace(pride,nvar,L0,k1,k2,stagnation_times,bestlion1);
        num_changespace=num_changespace+1
        if(best_cost_prv-best_cost(k)>0.0001)
            stagnation_times=0
        end
    end
    
    % %     Optimize the best member by one-dimension search in each dimension using(8)
    if(stagnation_times>thls)
        long_stagnation_times = long_stagnation_times+1
        k=k
        bestlion1 = StrongerBestLion(bestlion1,long_stagnation_times,nvar,L0);
    end
    
    if(long_stagnation_times>4)
        break
    end
    
    best_cost_prv = best_cost(k);
    
    nfe_best_cost(k)=nfe;
    figure(1);
    semilogy(nfe_best_cost(1:k),best_cost(1:k),'-r');
    title("number of function evaluation and correspound best cost")
    xlabel('nfe');
    ylabel('Best Cost');
    hold off;
    
    if(best_cost(k)<0.000001)
        break
    end
end

saveas(figure(1),"effect of LPO.jpg")
save("LPO for 2 equation with 6 variable")
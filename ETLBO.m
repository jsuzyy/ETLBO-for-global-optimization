function [BestCost,BestValue]=ETLBO(fhd,nPop,nVar,VarMin,VarMax,MaxIt,X)
%fhd--------objective function
%nPop-------population size
%nVar-------dimension
%VarMin-----lower limits of variables
%VarMax-----upper limits of variables
%MaxIt------the maximum number of function evaluations
%X----------initilization population
%BestCost---convergence curve
%BestValue--the optimal solution
MaxIt=floor(MaxIt/(2*nPop));
VarSize = [1 nVar];
BestSol = inf;
for i=1:nPop
    pop(i,:) = X(i,:);
    pop_Cost(i) = fhd(X(i,:));
    if  pop_Cost(i)  < BestSol
        BestSol =  pop_Cost(i) ;
        Best=pop(i,:);
    end
end
BestCost = zeros(MaxIt,1);
BestCost(1)=BestSol ;
for it=2:MaxIt
    Mean = 0;
    for i=1:nPop
        Mean = Mean + pop(i,:);
    end
    Mean = Mean/nPop;
    [~,la]=min(pop_Cost);
    [~,lb]=max(pop_Cost);
    Teacher = pop(la,:);
    for i=1:nPop
        TF = round(1+rand);
        ki=rand;
        gi=1-ki;
        j=randperm(nPop,1);
        while i==j
            j=randperm(nPop,1);
        end
        if pop_Cost(j)<pop_Cost(i)
            if rand<rand
                newsol = pop(i,:)+ rand(VarSize).*(Teacher - TF*(ki.*Mean+gi.*pop(i,:)));
            else
                newsol = pop(i,:)+ rand(VarSize).*(Teacher - TF*(ki.*pop(j,:)+gi.*pop(i,:)));
            end
        else
            if rand<rand
                newsol = pop(i,:)+ rand(VarSize).*(Teacher - TF*(ki.*Mean+gi.*pop(j,:)));
            else
                newsol = pop(i,:)+ rand(VarSize).*(Teacher - TF*(ki.*pop(j,:)+gi.*pop(i,:)));
            end
        end
        newsol = max(newsol, VarMin);
        newsol= min(newsol, VarMax);
        newsol_Cost = fhd(newsol);
        if newsol_Cost<pop_Cost(i)
            pop_Cost(i) = newsol_Cost;
            pop(i,:)=newsol;
            if pop_Cost(i) < BestSol
                BestSol = pop_Cost(i);
                Best=pop(i,:);
            end
        end
    end
    for i=1:nPop
        
        [~,la]=max(pop_Cost);
        worst=pop(la,:);
        j=randperm(nPop,1);
        while j==i
            j=randperm(nPop,1);
        end
        
        if pop_Cost(i)<pop_Cost(j)
            if rand<rand
                newsol = pop(i,:)+ rand(VarSize).*(Best -pop(j,:));
            else
                newsol = pop(i,:)-rand(VarSize).*(worst -pop(i,:));
            end
        else
            if rand<rand
                newsol = pop(i,:)+ rand(VarSize).*(Best -pop(i,:));
            else
                newsol = pop(i,:)-rand(VarSize).*(worst -pop(j,:));
            end
        end
        newsol = max(newsol, VarMin);
        newsol = min(newsol, VarMax);
        newsol_Cost = fhd(newsol);
        if newsol_Cost<pop_Cost(i)
            pop_Cost(i) = newsol_Cost;
            pop(i,:)=newsol;
            if pop_Cost(i) < BestSol
                BestSol = pop_Cost(i);
                Best=pop(i,:);
            end
        end
    end
    BestCost(it)=BestSol;
end
BestValue=BestSol;
end

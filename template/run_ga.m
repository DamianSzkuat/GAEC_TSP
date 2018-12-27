function run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, REPRESENTATION, CROSSOVER, HEURISTIC,TABU, LOCALLOOP, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
{NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT REPRESENTATION CROSSOVER HEURISTIC LOCALLOOP}
        x= 100*x;
        y=100*y;
        TABULENGTH = 4;
        GGAP = 1 - ELITIST;
        mean_fits=zeros(1,MAXGEN+1);
        worst=zeros(1,MAXGEN+1);
        Dist=zeros(NVAR,NVAR);
        for i=1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        % initialize population, tabu list of length 4, the first=  clan number parent
        % second = grand parent % third great grand parent
        % initialize clan number , the rest is empty
        if isequal(TABU,'Yes')
            Chrom=zeros(NIND,NVAR+TABULENGTH);
            for row=1:NIND
                if isequal(REPRESENTATION,'adj')
                    if( (rem(NIND,2)==1) && (row == ceil(NIND/2)) )
                        Chrom(row,:)=[path2adj(randperm(NVAR)),row,randi([1,floor(NIND/2)]),0,0];
                    else
                        Chrom(row,:)=[path2adj(randperm(NVAR)),row,NIND+1-row,0,0];
                    end    
                elseif isequal(REPRESENTATION,'path')
                    if( (rem(NIND,2)==1) && (row == ceil(NIND/2)) )
                        Chrom(row,:)=[randperm(NVAR),row,randi([1,floor(NIND/2)]),0,0];
                    else
                        Chrom(row,:)=[randperm(NVAR),row,NIND+1-row,0,0];
                    end                    
                else
                    error('Representation not implemented!'); 
                end       
            end
        else
            Chrom=zeros(NIND,NVAR);
            for row=1:NIND
                if isequal(REPRESENTATION,'adj')
                        Chrom(row,:)=path2adj(randperm(NVAR));  
                elseif isequal(REPRESENTATION,'path')
                        Chrom(row,:)=randperm(NVAR);                    
                else
                    error('Representation not implemented!'); 
                end       
            end            
        end  
        
        gen=0;
        % number of individuals of equal fitness needed to stop
        stopN=ceil(STOP_PERCENTAGE*NIND);
        % evaluate initial population
        ObjV = tspfun(Chrom(:,1:NVAR),Dist,REPRESENTATION);
        best=zeros(1,MAXGEN);
        % generational loop
        while gen<MAXGEN
            sObjV=sort(ObjV);
          	best(gen+1)=min(ObjV);
        	minimum=best(gen+1);
            mean_fits(gen+1)=mean(ObjV);
            worst(gen+1)=max(ObjV);
            for t=1:size(ObjV,1)
                if (ObjV(t)==minimum)
                    break;
                end
            end
            if isequal(REPRESENTATION,'adj')
                visualizeTSP(x,y,adj2path(Chrom(t,1:NVAR)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            elseif isequal(REPRESENTATION,'path')
                visualizeTSP(x,y,Chrom(t,1:NVAR), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            else
                error('Representation not implemented!'); 
            end 
            
            %if (sObjV(stopN)-sObjV(1) <= 1e-15)
             %     break;
            %end          
        	%assign fitness values to entire population
        	FitnV=ranking(ObjV);
        	%select individuals for breeding
        	SelCh=select('sus', Chrom, FitnV, GGAP);
            if ismember(0,SelCh(1:NVAR))
                error("0 in offspring before crossover")
            end
            
        	%recombine individuals (crossover)
            SelCh = recombinMuLambda(CROSSOVER,SelCh,Dist,PR_CROSS,TABU);
            if ismember(0,SelCh(1:NVAR))
                error("0 in offspring after crossover")
            end
        
            SelCh = mutateTSP('inversion',SelCh,PR_MUT,REPRESENTATION,TABU);
            %evaluate offspring, call objective function
            if ismember(0,SelCh(1:NVAR))
                error("0 in offspring after mutation")
            end
        	ObjVSel = tspfun(SelCh(:,1:NVAR),Dist,REPRESENTATION);
            %reinsert offspring into population
        	[Chrom ObjV]=reinsMuLambda(Chrom,SelCh,1,1,ObjV,ObjVSel,TABU);
           
            Chrom(:,1:NVAR) = tsp_ImprovePopulation(NIND, NVAR, Chrom(:,1:NVAR), LOCALLOOP, Dist, REPRESENTATION, x, y, HEURISTIC);
                %increment generation counter  
                
           gen=gen+1;
        end
end

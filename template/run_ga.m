function run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, REPRESENTATION, CROSSOVER, HEURISTIC, LOCALLOOP, ah1, ah2, ah3)
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


        GGAP = 1 - ELITIST;
        mean_fits=zeros(1,MAXGEN+1);
        worst=zeros(1,MAXGEN+1);
        Dist=zeros(NVAR,NVAR);
        for i=1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        % initialize population
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
        gen=0;
        % number of individuals of equal fitness needed to stop
        stopN=ceil(STOP_PERCENTAGE*NIND);
        % evaluate initial population
        ObjV = tspfun(Chrom,Dist,REPRESENTATION);
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
                visualizeTSP(x,y,adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            elseif isequal(REPRESENTATION,'path')
                visualizeTSP(x,y,Chrom(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            else
                error('Representation not implemented!'); 
            end 
            
            if (sObjV(stopN)-sObjV(1) <= 1e-15)
                  break;
            end
            
        	%assign fitness values to entire population
        	FitnV=ranking(ObjV);
        	%select individuals for breeding
        	SelCh=select('sus', Chrom, FitnV, GGAP);
            if ismember(0,SelCh)
                error("0 in offspring before crossover")
            end
        	%recombine individuals (crossover)
            SelCh = recombin(CROSSOVER,SelCh,Dist,PR_CROSS);
            if ismember(0,SelCh)
                error("0 in offspring after crossover")
            end
            SelCh = mutateTSP('inversion',SelCh,PR_MUT,REPRESENTATION);
            %evaluate offspring, call objective function
            if ismember(0,SelCh)
                error("0 in offspring after mutation")
            end
        	ObjVSel = tspfun(SelCh,Dist,REPRESENTATION);
            %reinsert offspring into population
        	[Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
            
            Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom, LOCALLOOP, Dist, REPRESENTATION, x, y, HEURISTIC);
        	%increment generation counter
        	gen=gen+1;
        end
end

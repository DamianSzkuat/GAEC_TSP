% REINS.M        (RE-INSertion of offspring in population replacing parents)
%
% This function reinserts offspring in the population.
%
% Syntax: [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel,TABU)
%
% Input parameters:
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    SelCh     - Matrix containing the offspring of the current
%                population. Each row corresponds to one individual.
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted or NaN, 1 subpopulation is assumed
%    InsOpt    - (optional) Vector containing the insertion method parameters
%                ExOpt(1): Select - number indicating kind of insertion
%                          0 - uniform insertion
%                          1 - fitness-based insertion
%                          if omitted or NaN, 0 is assumed
%                ExOpt(2): INSR - Rate of offspring to be inserted per
%                          subpopulation (% of subpopulation)
%                          if omitted or NaN, 1.0 (100%) is assumed
%    ObjVCh    - (optional) Column vector containing the objective values
%                of the individuals (parents - Chrom) in the current 
%                population, needed for fitness-based insertion
%                saves recalculation of objective values for population
%    ObjVSel   - (optional) Column vector containing the objective values
%                of the offspring (SelCh) in the current population, needed for
%                partial insertion of offspring,
%                saves recalculation of objective values for population
%
% Output parameters:
%    Chrom     - Matrix containing the individuals of the current
%                population after reinsertion.
%    ObjVCh    - if ObjVCh and ObjVSel are input parameter, than column 
%                vector containing the objective values of the individuals
%                of the current generation after reinsertion.
           
% Author:     Hartmut Pohlheim
% History:    10.03.94     file created
%             19.03.94     parameter checking improved

function [Chrom, ObjVCh] = reinsMuLambda(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel,TABU)


% Check parameter consistency
   if nargin < 2, error('Not enough input parameter'); end
   if (nargout == 2 & nargin < 6), error('Input parameter missing: ObjVCh and/or ObjVSel'); end

   [NindP, NvarP] = size(Chrom);
   [NindO, NvarO] = size(SelCh);

   if nargin == 2, SUBPOP = 1; end
   if nargin > 2,
      if isempty(SUBPOP), SUBPOP = 1;
      elseif isnan(SUBPOP), SUBPOP = 1;
      elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); end
   end

   if (NindP/SUBPOP) ~= fix(NindP/SUBPOP), error('Chrom and SUBPOP disagree'); end
   if (NindO/SUBPOP) ~= fix(NindO/SUBPOP), error('SelCh and SUBPOP disagree'); end
   NIND = NindP/SUBPOP;  % Compute number of individuals per subpopulation
   NSEL = NindO/SUBPOP;  % Compute number of offspring per subpopulation

   IsObjVCh = 0; IsObjVSel = 0;
   if nargin > 4, 
      [mO, nO] = size(ObjVCh);
      if nO ~= 1, error('ObjVCh must be a column vector'); end
      if NindP ~= mO, error('Chrom and ObjVCh disagree'); end
      IsObjVCh = 1;
   end
   if nargin > 5, 
      [mO, nO] = size(ObjVSel);
      if nO ~= 1, error('ObjVSel must be a column vector'); end
      if NindO ~= mO, error('SelCh and ObjVSel disagree'); end
      IsObjVSel = 1;
   end
       
   if nargin < 4, INSR = 1.0; Select = 0; end   
   if nargin >= 4,
      if isempty(InsOpt), INSR = 1.0; Select = 0;   
      elseif isnan(InsOpt), INSR = 1.0; Select = 0;   
      else
         INSR = NaN; Select = NaN;
         if (length(InsOpt) > 2), error('Parameter InsOpt too long'); end
         if (length(InsOpt) >= 1), Select = InsOpt(1); end
         if (length(InsOpt) >= 2), INSR = InsOpt(2); end
         if isnan(Select), Select = 0; end
         if isnan(INSR), INSR =1.0; end
      end
   end
   
   if (INSR < 0 | INSR > 1), error('Parameter for insertion rate must be a scalar in [0, 1]'); end
   if (INSR < 1 & IsObjVSel ~= 1), error('For selection of offspring ObjVSel is needed'); end 
   if (Select ~= 0 & Select ~= 1), error('Parameter for selection method must be 0 or 1'); end
   if (Select == 1 & IsObjVCh == 0), error('ObjVCh for fitness-based exchange needed'); end

   if INSR == 0, return; end
              
            
            % We cut down the number of offspring to the ones which are not tabu and
            % the ones which are tabu BUT have a better fitness value than the best 
            % candidate solution of the previous generation.
        
            %instantiate best of the previous generation
            ObjVSelValid = [];
            SelChValid= [];
            
            [~, ChIx] = sort(-ObjVCh((1:NIND)));
            BObjVCh=  ObjVCh(ChIx(length(ObjVCh)));
            %sort Offspring 
            [~, OffIx] = sort(ObjVSel(1:NSEL));
            SortedOffspring = SelCh(OffIx,:);
            Sortedfitness =  ObjVSel(OffIx);
             [Nvalid, ~]= size(SelChValid);
             %select Offspring 
                counter=0;
             numberpop = NindP
             for i = 1 : NindO
                 if counter < NindP
                     if  (( SortedOffspring(i,NvarO) == 0 ) || (Sortedfitness(i) <= BObjVCh))
                        SelChValid = [SelChValid;SortedOffspring(i,:)];
                        ObjVSelValid=[ObjVSelValid;ObjVSel(i)];
                        counter=counter+1;
                     end
                 else
                    break;
                 end
             end    

           [NValid, ~] = size(SelChValid)
            
           % if there are not enough valid offspring, fill the surviving
           % population with the best parents.
           if NValid < NindP
               SortedParents = zeros(NindP,NvarO);
               
               SortedParents(1:NindP,1:NvarO-1)= Chrom(ChIx,:);
             
               i =1;
               while   NValid < NindP
                    insert= SortedParents(i,:);
                    SelChValid=[SelChValid;insert];
                    ObjVSelValid=[ObjVSelValid;ObjVSel(i)];
                    NValid= NValid+1;
                    i=i+1;
               end     
           end
           
        blareinsmuL= size(SelChValid)
        Chrom = SelChValid(:,1:NvarO-1);
        ObjVCh= ObjVSelValid;
        %if (IsObjVCh == 1 && IsObjVSel == 1), ObjVCh(PopIx) = ObjVSel(SelIx); end
    
end


% End of function
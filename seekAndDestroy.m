%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function [Aupdated, Bupdated, Cupdated, rho, runningRank, newConcept, overlapConcept, overlapConceptOld, missingConcept] = seekAndDestroy(factA, factB, factC, Xs, batchRank, runningRank, mode)
    [Fnew, out] = runCPALS(Xs,batchRank);
    l1 = diag(Fnew.lambda .^ (1/mode));
    A = Fnew.U{1} * l1;
    B = Fnew.U{2} * l1;
    C = Fnew.U{3} * l1;

    [normMatA, colA] = normalization(A);
    [normMatB, colB] = normalization(B);
    [normMatC, colC] = normalization(C);

    rhoVal = colA .* colB .*colC;
    [newConcept, overlapConcept, overlapConceptOld, missingConcept] = findConceptOverlap(factA, normMatA);
    rho = updateRho(rhoVal, newConcept, overlapConcept, overlapConceptOld, runningRank);
    
   if newConcept
        runningRank = runningRank + size(newConcept,2);
        Aupdated = [factA normMatA(:, newConcept)];
        Bupdated = [factB normMatB(:, newConcept)];
        Cupdated = updateFactC(factC, normMatC, newConcept, overlapConcept, overlapConceptOld, runningRank);
   else
        Aupdated = factA;
        Bupdated = factB;
        Cupdated = updateFactC(factC, normMatC, newConcept, overlapConcept, overlapConceptOld, runningRank);
   end
  
end

function Cupdated = updateFactC(oldC, newC, newConcept, overlapConcept, overlapConceptOld, runningRank)
    if newConcept
      temp = zeros(size(newC,1), size(oldC,2));
      temp(:,overlapConceptOld) = newC(:,overlapConcept);
      numNewConcepts = size(newConcept,2);
      numOldRows = size(oldC,1); 
      x = zeros(numOldRows, numNewConcepts);
      oldC = [oldC x];
      temp = [temp newC(:,newConcept)];
      Cupdated = [oldC; temp];
    else
      temp = zeros(size(newC,1), size(oldC,2));
      temp(:,overlapConceptOld) = newC(:,overlapConcept);
      Cupdated = [oldC; temp];
    end

end


function rho = updateRho(rhoVal, newConcept, conceptOverlap, overlapConceptOld, runningRank)
newRank = size(newConcept,2) + runningRank;
rho = zeros(1,newRank);
if newConcept
    rho(:,runningRank+1:end) = rhoVal(newConcept);
end
if conceptOverlap
    rho(overlapConceptOld) = rhoVal(conceptOverlap);
end
end

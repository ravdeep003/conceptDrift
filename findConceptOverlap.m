function [newConcept, overlapConcept, overlapConceptOld, missingConcept]=findConceptOverlap(Aold, Anew)
    % Input should be normalized matrix
    threshold = 0.6;
    previousRank = size(Aold,2);
    previousCol = 1:previousRank;
    newRank = size(Anew,2);
    sumVal = 0;
    if previousRank == newRank
        allcomb = perms(1:newRank);
        
        for j = 1:size(allcomb,1)
          val = dot(Aold(1:end, :), Anew(:,allcomb(j,:)));
          sumDot = sum(val);
%           disp(j);
%           disp(allcomb(j,:));
%           disp(sumDot);
%           disp(val);
          if sumDot > sumVal
              sumVal = sumDot;
              bestPerm = allcomb(j,:);
              bestVal =  dot(Aold(1:end, :), Anew(:,allcomb(j,:)));
          elseif sumDot > min(previousRank, newRank)
              % Error Handling
              % if normalized correctly this part of the code should never execute
              fprintf('Something has gone wrong');
          end
        end
%        disp(bestVal);
%        disp(bestPerm);
       newConcept = bestPerm(bestVal < threshold);
       overlapConcept= bestPerm(bestVal >= threshold);
       overlapConceptOld = previousCol(bestVal >= threshold);
       missingConcept = setdiff(previousCol, overlapConcept);
     elseif previousRank > newRank
         newCol = 1:newRank;
        comb = combnk(previousCol, newRank);
        iter = size(comb,1);
        allcomb = [];
        for i = 1:iter
            allcomb = [allcomb; perms(comb(i,:))];
        end
        for j = 1:size(allcomb,1)
%             val = dot(Aold(end-size(Anew,1)+1:end, allcomb(j,:)), Anew);
            val = dot(Aold(:, allcomb(j,:)), Anew);
            sumDot = sum(val);
%             disp(j);
%             disp(allcomb(j,:));
%             disp(sumDot);
%             disp(val);
            if sumDot > sumVal
                sumVal = sumDot;
                bestPerm = allcomb(j,:);
%                 bestVal =  dot(Aold(end-size(Anew,1)+1:end, allcomb(j,:)), Anew);
                bestVal = dot(Aold(:, allcomb(j,:)), Anew);
           end
        end
%         disp(bestVal);
%         disp(bestPerm);
%         k = find(bestPerm);
        newConcept = newCol(bestVal < threshold);
        overlapConcept= newCol(bestVal >= threshold);
        overlapConceptOld = bestPerm(bestVal >= threshold);
        missingConcept = setdiff(previousCol, overlapConceptOld);
    elseif previousRank < newRank
        newCol = 1:newRank;
        comb = combnk(newCol, previousRank);
        iter = size(comb,1);
        allcomb = [];
        for i = 1:iter
            allcomb = [allcomb; perms(comb(i,:))];
        end
        for j = 1:size(allcomb,1)
%            val = dot(Aold, Anew(end-size(Aold,1)+1:end, allcomb(j,:)));
            val = dot(Aold, Anew(:, allcomb(j,:)));
            sumDot = sum(val);
%             disp(j);
%             disp(allcomb(j,:));
%             disp(sumDot);
%             disp(val);
            if sumDot > sumVal
                sumVal = sumDot;
                bestPerm = allcomb(j,:);
                bestVal = dot(Aold, Anew(:, allcomb(j,:)));
           end
        end 
%         disp(bestVal);
%         disp(bestPerm);
%         k = find(bestPerm);
%         newConcept = bestPerm(bestVal < threshold);
        
        overlapConcept= bestPerm(bestVal >= threshold);
        newConcept = setdiff(newCol, overlapConcept);
        overlapConceptOld = previousCol(bestVal >= threshold);
        missingConcept = setdiff(previousCol, overlapConceptOld);
    end
    
%     if isequal(sort(overlapConceptOld),sort(overlapConceptNew))
%         overlapConceptNew = [];
%     end
%     Handle the case when there is a partial overalap
end
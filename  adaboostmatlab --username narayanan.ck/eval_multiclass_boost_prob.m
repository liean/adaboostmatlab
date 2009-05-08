function [error accuracy yest posprob]=eval_multiclass_boost_prob(xtest,ytest,multiclass_model,num_iter,thresh)
% This function takes in the test data and the multi class labels of the
% test data and evaluates the test data.
wsum =zeros(size(multiclass_model,2),1);
for j = 1 : size(multiclass_model,2)    
    h_est(:,j) = eval_boost(multiclass_model{j},xtest);          
    for i_wl = 1 : num_iter
        wsum(j) = wsum(j) + multiclass_model{j}{i_wl}.alpha; % Summing the alpha values associated with each stump.
    end
end    

phi = 10;

marginals = h_est./(ones(size(h_est,1),1)*wsum'); % compute the marginals 

posprob = exp(phi.*marginals)./(exp(phi.*marginals)+1); % compute the probability 

[t yest] = max(posprob,[],2); % find the class label by finding the class with the highest probability.

yest(find(t<thresh)) = 11; % if the probability value is less than threshold then label it as 21.

error = sum(yest~=ytest)/size(ytest,1);
accuracy = 1-error;
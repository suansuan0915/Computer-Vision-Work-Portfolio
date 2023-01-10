%% Network defintion
layers = get_lenet();

%% Loading data
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);

% load the trained weights
load lenet.mat

%% Testing the network
% Modify the code to get the confusion matrix
predicted = zeros(size(ytest));
for i=1:100:size(xtest, 2)
    [output, P] = convnet_forward(params, layers, xtest(:, i:i+99));
    [val, idx] = max(P);
    %disp('#');
    %disp(size(ytest(:, i:i+99))); % 1,100
    %disp(size(P));
    %disp(size(predicted)); % 1,100
    predicted(:, i: i+99) = idx;
end

predicted_num = predicted;
m = confusionmat(ytest, predicted);
m_chart = confusionchart(ytest, predicted);
disp(m);
disp(m_chart);

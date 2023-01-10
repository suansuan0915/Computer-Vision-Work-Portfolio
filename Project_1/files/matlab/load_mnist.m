function [xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset)

	load('./mnist_all.mat');
    
	xtrain = [train0; train1; train2;train3;train4;train5;train6;train7;train8;train9];  % ; -in 1 column
	ytrain = [ones(size(train0,1),1);  % 5923-by-1 ones matrix
    	2*ones(size(train1,1),1);  % 6742-by-1 twos matrix
    	3*ones(size(train2,1),1);
    	4*ones(size(train3,1),1);
    	5*ones(size(train4,1),1);
    	6*ones(size(train5,1),1);
    	7*ones(size(train6,1),1);
    	8*ones(size(train7,1),1);
    	9*ones(size(train8,1),1);
    	10*ones(size(train9,1),1)];
	xtest = [test0; test1; test2;test3;test4;test5;test6;test7;test8;test9];
	ytest = [ones(size(test0,1),1);
    	2*ones(size(test1,1),1);
    	3*ones(size(test2,1),1);
    	4*ones(size(test3,1),1);
    	5*ones(size(test4,1),1);
    	6*ones(size(test5,1),1);
    	7*ones(size(test6,1),1);
    	8*ones(size(test7,1),1);
    	9*ones(size(test8,1),1);
    	10*ones(size(test9,1),1)];

	xtrain = double(xtrain)/255;  % convert a uint8 RGB image to double
	xtest = double(xtest)/255;
	p = randperm(size(xtrain, 1));  % random permutation of n #
	xtrain = xtrain(p, :); % randomize the images order
	ytrain = ytrain(p, :);
	p = randperm(size(xtest, 1));
	xtest = xtest(p, :);
	ytest = ytest(p, :);
	m_validate = 10000;  % 10000 data points in train_set for validation
	xvalidate = xtrain(1:m_validate, :);
	yvalidate = ytrain(1:m_validate, :);
	xtrain = xtrain(m_validate + 1:end, :);
	ytrain = ytrain(m_validate + 1:end, :);
	m_train = size(xtrain, 1);  % #of train data images
	m_test = size(xtest, 1);

	xtrain = xtrain';  % ' -transpose, to 784-by-#n matrix (each column is an image w/ all 28x28 pixels)
	ytrain = ytrain';
	xvalidate = xvalidate';
	yvalidate = yvalidate';
	xtest = xtest';
	ytest = ytest';
	if ~fullset
		m_train_small = m_train/20;  % select the first 1/20 images
		m_test_small = m_test/20;
		m_validate_small = m_validate/20;
		xtrain = xtrain(:, 1:m_train_small);
		ytrain = ytrain(:, 1:m_train_small);
		xtest = xtest(:, 1:m_test_small);
		ytest = ytest(:, 1:m_test_small);
		xvalidate = xvalidate(:, 1:m_validate_small);
		yvalidate = yvalidate(:, 1:m_validate_small);
	end
end

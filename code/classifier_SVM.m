% classifying data by SVM
load 'old_data'

%random data
R_data=random_data(data);
[test_data, train_data]=random_test_train(R_data,0.3,2);
test_data=random_data(test_data);
train_data=random_data(train_data);


input=train_data(:,1:end-1);
Target=train_data(:,end);

test=test_data(:,1:end-1);
Target_test=test_data(:,end);


svmStruct = svmtrain(input,Target);
Group = svmclassify(svmStruct,test);

E=abs(Group-Target_test);
error=length(find(E>0));

Group = svmclassify(svmStruct,R_data(:,1:end-1));
E=abs(Group-R_data(:,end));
error=length(find(E>0));
correct=(1-(error/60))*100




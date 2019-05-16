%% main test file, this file calls the subtest files
% run by executing commend:
% tests = testMain;
% run(tests);
function tests = testMain
% add path
addpath('./tensorTrain');

% testRankReduction
RRTests = functiontests(testRankReduction);

% testTensorSum
TSTests = functiontests(testTensorSum);

% local test which are in this file
localTests = functiontests(localfunctions) ;

tests = [localTests TSTests RRTests];
end

function setup(testCase)
    % no setup for now
end

function teardown(testCase)
    % no teardown for now
end

% it is possible to create a test here
% for long tests a seperate test file is wise
function testExample(testCase)

    assertTrue(testCase, true);
end






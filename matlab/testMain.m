%% main test file, this file calls the subtest files
% run by executing commend:
% tests = testMain;
function tests = testMain
import matlab.unittest.*;
import matlab.unittest.qualifications.Assertable;
tests = functiontests(localfunctions);
end

function setup(testCase)
    % no setup for now
end

function teardown(testCase)
    % no teardown for now
end

function testExample(testCase)
    assertTrue(true);
end

function testTensorTrain(testCase)
addpath('./tensorTrain');
fh = testRankReduction;
run(fh{1});

end




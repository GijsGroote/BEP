%% main test file, this file calls the subtest files
% run by executing commend:
% tests = testMain;
% run(tests);
function tests = testMain
% import matlab.unittest.*;
% import matlab.unittest.qualifications.Assertable;
tests = functiontests(testRankReduction);
% functiontests(localfunctions) ;

end

function setup(testCase)
    % no setup for now
end

function teardown(testCase)
    % no teardown for now
end

function testExample(testCase)

    assertTrue(testCase, true);
end

function testTensorTrain(testCase)

fh = testRankReduction

end




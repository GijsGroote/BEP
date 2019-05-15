% import matlab.unittest.*;
% import matlab.unittest.constraints.IsEqualTo;
% import matlab.unittest.qualifications.Assertable;
% tests the correctness of rank reduction function file
%% Test if dimensions are not giving errors
function fh = testRankReduction
fh = localfunctions;
end

function testOnesAndZeros(testCase)    
    % arrange
    p1 = [0 1 ; 1 0];
    w1 = [1 0 ; 1 1];
    p2 = [0 0 0 ; 1 1 1 ; 0 0 0];
    w2 = [1 0 1 ; 1 0 1 ; 1 0 1];

    % act
    actualSolution = rankReduction(p1, p2, w1, w2);
    expectedSolution = [ -2.3440   -1.2247 ; -3.5688   -2.3440];
    
    % assert
    assertable.assertThat(actualSolution, IsEqualTo(expectedSolution));
end


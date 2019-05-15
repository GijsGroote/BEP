%% Test if dimensions are not giving errors
function fh = testTensorSum
fh = localfunctions;
end

function setup(testCase)
    % no setup for now
   
end

function teardown(testCase)
    % no teardown for now
end

function testOnesAndZeros(testCase)    
    % arrange
    p1 = [0 1 ; 1 0];
    w1 = [1 0 ; 1 1];
    p2 = [0 0 0 ; 1 1 1 ; 0 0 0];
    w2 = [1 0 1 ; 1 0 1 ; 1 0 1];

    % act, use int64 to round matrix to integer values
    % test could fail on calculation errors smaller than 10^-5 
    actualSolution = int64(tensorSum(p1, p2, w1, w2));
    expectedSolution = int64([ -2.3440   -1.2247 ; -3.5688   -2.3440]);
        
    % assert
    assertTrue(testCase, isequal(actualSolution, expectedSolution));
end





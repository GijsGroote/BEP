classdef tensorNetworkAdditionTest < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Test)
        function testOnesWillBeTwos(testCase)
            % arrange
            thisTN = struct('thisTN1', ones(2, 2, 'double'), 'thisTN2', zeros(2, 2, 'double'));
            thatTN = struct('thatTN1', ones(2, 2, 'double'), 'thatTN2', zeros(2, 2, 'double'));
            
            % act
            actSolution = tensorNetworkAddition(thisTN, thatTN);
            RealSolution = struct('thisTN1', [2 2 ; 2 2], 'thisTN2', zeros(2, 2, 'double'));
            
            % assert
            testCase.verifyEqual(actSolution, RealSolution);
        end    
    end
    
end


classdef tensorNetworkAdditionTest < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Test)
        function testOnesWillBeTwos(testCase)
            % arrange
            thisTN = struct('thisTN1', ones(4, 4, 'double'), 'thisTN2', ones(4, 4, 'double'));
            thatTN = struct('thatTN1', ones(4, 4, 'double'), 'thatTN2', ones(4, 4, 'double'));
            
            % act
            actSolution = tensorNetworkAddition(thisTN, thatTN);
            RealSolution = struct('thatTN1', 2.* ones(length(4),1), 'thatTN2', 2.* ones(length(4),1));
            % assert
        end    
    end
    
end


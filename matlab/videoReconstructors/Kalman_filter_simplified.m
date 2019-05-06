function [s] = kalman_filter_simplified (s,faultyVideo, frameWidth, frameHeight)

% Beware that I have not yet been able to test this function on a data set
% representative of the one that will be used for the algorithm. 
% I don't really know which matrixes and values will change for every 
% colour frame. So I just assumed they all change for every loop, 
% so they all need to be three dimensional for now.

%% asumptions
% A = 1;
% B = 0;
% C = 1;
% P at time 1 is = 1
%% Deze dingen zijn misschien niet nodig maar heb ze er toch even in gelaten

% % set defaults for absent fields:
% if ~isfield(s,'x'); s.x=nan*z; end
% if ~isfield(s,'P'); s.P=nan; end
% if ~isfield(s,'z'); error('Observation vector missing'); end
% if ~isfield(s,'u'); s.u=0; end
% if ~isfield(s,'A'); s.A=eye(length(x)); end
% if ~isfield(s,'B'); s.B=0; end
% if ~isfield(s,'Q'); s.Q=zeros(length(x)); end
% if ~isfield(s,'R'); error('Observation covariance missing'); end
% if ~isfield(s,'H'); s.H=eye(length(x)); end

% if ~isfield(s,'x'); error('State matrix missing (x)'); end
% if ~isfield(s,'P'); error('Proces covariance matrix missing (P)'); end
% if ~isfield(s,'z'); error('Observation vector missing (z)'); end 
% if ~isfield(s,'u'); error('Control variable matrix (u)'); end
% if ~isfield(s,'A'); error('Adaptation matrix (A) is missing'); end
% if ~isfield(s,'B'); error('Adaptation matrix (B) is missing'); end
% if ~isfield(s,'Q'); error('Process noise covariance matrix (Q)'); end
% if ~isfield(s,'R'); error('Sensor noise covariance matrix (R)'); end
% if ~isfield(s,'H'); error('Conversion matrix (H)'); end

processed_frame = zeros(frameWidth, frameHeight, 3);

%% The Kalman filter

% The kalman equations
% 
%    % Prediction for state vector and covariance:
%    s.x = s.A*s.x + s.B*s.u;
%    s.P = s.A * s.P * s.A' + s.Q;
% 
%    % Compute Kalman gain factor:
%    K = s.P*s.H'*inv(s.H*s.P*s.H'+s.R);
% 
%    % Correction based on observation:
%    s.x = s.x + K*(s.z-s.H*s.x);
%    s.P = s.P - K*s.H*s.P;


%loop for every color (r, g and b)
for i = 1:3
    %     if isnan(s.x)
    %         % initialize state estimate from first observation
    %         if diff(size(s.H))
    %             error('Observation matrix must be square and invertible for state autointialization.');
    %         end
    %         s.x = s.H\s.z;
    %         s.P = s.H\s.R/s.H';
    %     else
    
    % This is the code which implements the discrete Kalman filter:
     
%     % Prediction for state vector and covariance:
%     s.x(:,:,i) = s.A*s.x(:,:,i) + s.B*s.u;
%     s.P(:,:,i) = s.A * s.P(:,:,i) * s.A' + s.Q;

     s.x(:,:,i) = s.x(:,:,i);
     s.P = s.P;% + s.Q;
%     
%     % Compute Kalman gain factor:
%     K = s.P(:,:,i)*s.H'/(s.H*s.P(:,:,i)*s.H'+s.R);
     K = 0.5;
%     
%     % Correction based on observation:git 
%     s.x(:,:,i) = s.x(:,:,i) + K*(s.z-s.H*s.x(:,:,i));
%     s.P(:,:,i) = s.P(:,:,i) - K*s.H*s.P(:,:,i);
     s.x(:,:,i) = s.x(:,:,i) + K*(faultyVideo(:,:,i)-s.x(:,:,i));
     s.P = s.P - K*s.P;
         
    % Prediction for state vector and covariance:
%     s.x(:,:,i) = s.A(:,:,i) * s.x(:,:,i) + s.B(:,:,i) * s.u(:,:,i);
%     s.P(:,:,i) = s.A(:,:,i) * s.P(:,:,i) * s.A(:,:,i)' + s.Q(:,:,i);
    
    % Compute Kalman gain factor:
%     K = s.P(:,:,i) * s.H(:,:,i)'/(s.H(:,:,i) * s.P(:,:,i) * s.H(:,:,i)' + s.R(:,:,i));
    
    % Correction based on observation:
%     s.x(:,:,i) = s.x(:,:,i) + K * (s.z(:,:,i) - s.H(:,:,i) * s.x(:,:,i));
%     s.P(:,:,i) = s.P(:,:,i) - K * s.H(:,:,i) * s.P(:,:,i);
    
%    processed_frame(:,:,i) = reshape(s.x(:,:,i), [frameWidth, frameHeight]);
    
end

end
function [frame] = state2Frame(X,height,width)
for k=length(X):-1:1
    X(k).state = tensor2Matrix(X(k).X1,X(k).X2);
    X(k).frame = reshape(im2uint8(X(k).state), height, width);
    frame(:,:,k) = X(k).frame;
end
  
end


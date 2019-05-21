%gemeten: y = 61, R = 180712, R1 = 232, R2 = 377
%Xrank = 10
%Krank = 1
%Xn is zonder rankreduction
XnMatrix = tensor2Matrix(Xn.X1,Xn.X2); %Xn vector naar een kolomvector
Xnind = find(XnMatrix); %zoeken naar waarden die niet 0 zijn
XnMatrix(Xnind); %waarde die niet nul is weergeven
[rn1, cn1, XnX1elements] = find(Xn.X1); %rn1 = R1 = 232, cn2 = 11
[rn2, cn2, XnX2elements] = find(Xn.X2); %cn1 = R2 = 377, cn2 = 11
%XnX1elements*XnX2elements = 61 = y

%Xm is met rankreduction = 10
XmMatrix = tensor2Matrix(Xm.X1,Xm.X2); 
Xmind = find(XmMatrix);
for i=1:length(Xmind)
    Xmval(i) = XmMatrix(Xmind(i));
end
[rm1, cm1, XmX1elements] = find(Xm.X1); %rn1 = R1 = 232, rc2 = 1
[rm2, cm2, XmX2elements] = find(Xm.X2); %rc1 = VECTOR, rc2 = VECTOR
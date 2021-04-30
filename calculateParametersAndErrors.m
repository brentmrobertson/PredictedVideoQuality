
modelFun = @(a,x)((a(1)+a(2).*x(1:3:end)+a(3).*log(x(2:3:end)))./(1+a(4).*x(3:3:end)+a(5).*x(3:3:end).*x(3:3:end)));
beta0 = ones(1,5);

BlueBeta = nlinfit(BlueX, BlueY, modelFun, beta0)
GreenBeta = nlinfit(GreenX, GreenY, modelFun, beta0)
PurpleBeta = nlinfit(PurpleX, PurpleY, modelFun, beta0)
RedBeta = nlinfit(RedX, RedY, modelFun, beta0)

BlueError = modelFun(BlueBeta, BlueX) - BlueY;
GreenError = modelFun(GreenBeta, GreenX) - GreenY;
PurpleError = modelFun(PurpleBeta, PurpleX) - PurpleY;
RedError = modelFun(RedBeta, RedX) - RedY;

errorTable = table([mean(BlueError); mean(GreenError); mean(PurpleError); mean(RedError)], ...
    [std(BlueError); std(GreenError); std(PurpleError); std(RedError)], ...
    'VariableNames', {'Mean', 'Standard_Deviation'}, ...
    'RowNames', {'Blue', 'Green', 'Purple', 'Red'})

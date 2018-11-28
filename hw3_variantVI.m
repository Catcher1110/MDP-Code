alpha = 0.95;
epsilon = 0.1;
IterationTime = 0;
J = [[0, 0]];

while(1)
    %J1next = max(5 + alpha * 0.5 * J(end, 1) + alpha * 0.5 * J(end, 2), 10 + alpha * J(end, 2));
    J1next = max(5 + alpha * 0.3 * J(end, 1) + alpha * 0.7 * J(end, 2), 10 + alpha * 0.5 * J(end, 1) + alpha * 0.5 * J(end, 2));
    J2next = max(35 + alpha * 0.8 * J(end, 1) + alpha * 0.2 * J(end, 2), 25 + alpha * 0.4 * J(end, 1) + alpha * 0.6 * J(end, 2));
    J = [J; [J1next, J2next]];
    TempJ = J(end, :) - J(end-1, :);
    IterationTime = IterationTime + 1;
    LowerBound = alpha / (1 - alpha) * min(TempJ);
    UpperBound = alpha / (1 - alpha) * max(TempJ);
    tempJ1 = J1next + (LowerBound + UpperBound)/2;
    tempJ2 = J2next + (LowerBound + UpperBound)/2;
    J(end, :) = [tempJ1, tempJ2];
    if UpperBound - LowerBound < epsilon
        fprintf('It takes %d iterations \n', IterationTime);
        fprintf('The estimate J is: %.3f and %.3f \n', J(end, 1), J(end,2));
        break;
    end
end
alpha = 0.95;
epsilon = 0.1;
P = [0.3, 0.7; 0.8, 0.2];
P(:,:,2) = [0.5, 0.5; 0.4, 0.6];
g = [5, 10; 35, 25];

JL = 0;
JH = 0;

[uL, uH] = iterationU(JL,JH,P,alpha,g);

iter = 0;
while(1)
    iter = iter + 1;
    [JL, JH] = iterationL(JL,JH,P,uL,uH,alpha,g);
    [uLnew, uHnew] = iterationU(JL,JH,P,alpha,g);
    if uLnew == uL && uHnew == uH
        fprintf('It takes %d iterations.\n', iter);
        fprintf('The optimal policy for J(L) is %d. \n', uL);
        fprintf('The optimal policy for J(H) is %d. \n', uH);
        return 
    else
        uL = uLnew;
        uH = uHnew;
    end
end

function [uL,uH] = iterationU(JL,JH,P,alpha,g)
    tempA = [g(1,1) + alpha * P(1,1,1)*JL(end) + alpha * P(1,2,1)*JH(end),...
             g(1,2) + alpha * P(1,1,2)*JL(end) + alpha * P(1,2,2)*JH(end)];
    [~,uL] = max(tempA);
    tempB = [g(2,1) + alpha * P(2,1,1)*JL(end) + alpha * P(2,2,1)*JH(end),...
             g(2,2) + alpha * P(2,1,2)*JL(end) + alpha * P(2,2,2)*JH(end)];
    [~,uH] = max(tempB);
end

function [JL, JH] = iterationL(JL,JH,P,uL,uH,alpha,g)
    Pu = [P(1,1,uL), P(1,2,uL); P(2,1,uH), P(2,2,uH)];
    Jtemp = ([1,0;0,1] - alpha * Pu)^-1 * [g(1,uL); g(2,uH)];
    JL = [JL, Jtemp(1)];
    JH = [JH, Jtemp(2)];
end
alpha = 0.95;
epsilon = 0.1;
m = 3;
P = [0.3, 0.7; 0.8, 0.2];
P(:,:,2) = [0.5, 0.5; 0.4, 0.6];
g = [5, 10; 35, 25];

JL = 0;
JH = 0;

StopC = StopCriterion(alpha, epsilon);

iter = 0;
while(1)
    iter = iter + 1;
    [uL, uH] = iterationU(JL,JH,P,alpha,g);
    for i = 1:1:m
        [JLtemp, JHtemp] = iterationL(JL,JH,P,uL,uH,alpha,g);
        if (abs(JLtemp - JL(end)) < StopC) && (abs(JHtemp - JH(end)) < StopC)
            fprintf('It takes %d iterations \n', iter);
            return
        else
            JL = [JL, JLtemp];
            JH = [JH, JHtemp];
        end
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

function [JLtemp, JHtemp] = iterationL(JL,JH,P,uL,uH,alpha,g)
    tempA = [g(1,1) + alpha * P(1,1,1)*JL(end) + alpha * P(1,2,1)*JH(end),...
             g(1,2) + alpha * P(1,1,2)*JL(end) + alpha * P(1,2,2)*JH(end)];
    JLtemp = tempA(uL);
    tempB = [g(2,1) + alpha * P(2,1,1)*JL(end) + alpha * P(2,2,1)*JH(end),...
             g(2,2) + alpha * P(2,1,2)*JL(end) + alpha * P(2,2,2)*JH(end)];
    JHtemp = tempB(uH);
end

 function res = StopCriterion(alpha, epsilon)
    res = epsilon * (1 - alpha) /(2 * alpha);
 end
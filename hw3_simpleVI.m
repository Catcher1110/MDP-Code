 alpha = 0.95;
 epsilon = 0.1;
 J1 = [0];
 J2 = [0];
 StopC = StopCriterion(alpha, epsilon);
 IterationTime = 0;
 
 while(1)
    J1next = max(5 + alpha * 0.3 * J1(end) + alpha * 0.7 * J2(end), 10 + alpha * 0.5 * J1(end) + alpha * 0.5 * J2(end));
    %J2next = -1 + alpha * J2(end);
    J2next = max(35 + alpha * 0.8 * J1(end) + alpha * 0.2 * J2(end), 25 + alpha * 0.4 * J1(end) + alpha * 0.6 * J2(end));
    IterationTime = IterationTime + 1;
    if (abs(J1next - J1(end)) < StopC) && (abs(J2next - J2(end)) < StopC)
        J1 = [J1, J1next];
        J2 = [J2, J2next];
        fprintf('It takes %d iterations \n', IterationTime);
        fprintf('J1 is %.4f \n', J1(IterationTime));
        fprintf('J2 is %.4f \n', J2(IterationTime));
        temp1 = 5 + alpha * 0.3 * J1(end) + alpha * 0.7 * J2(end);
        temp2 = 10 + alpha * 0.5 * J1(end) + alpha * 0.5 * J2(end);        
        fprintf('Calculate in state 1: J1(L) = max{%.4f, %.4f} \n', temp1, temp2);
        temp3 = 35 + alpha * 0.8 * J1(end) + alpha * 0.2 * J2(end);
        temp4 = 25 + alpha * 0.4 * J1(end) + alpha * 0.6 * J2(end);
        fprintf('Calculate in state 1: J1(H) = max{%.4f, %.4f} \n', temp3, temp4);
        break;
    else
        J1 = [J1, J1next];
        J2 = [J2, J2next];
    end
 end
 function res = StopCriterion(alpha, epsilon)
    res = epsilon * (1 - alpha) /(2 * alpha);
 end
 
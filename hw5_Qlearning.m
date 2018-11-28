alpha = 0.9;
State = [1,2];
Action = [1,2];
transition_mat_1 = [3/4, 1/4; 3/4, 1/4];
transition_mat_2 = [1/4, 3/4; 1/4, 3/4];
transition_mat(:,:,1) = transition_mat_1;
transition_mat(:,:,2) = transition_mat_2;
transition_cost = [2, 0.5; 1, 3];
Q_mat = zeros(length(State), length(Action));

Q_mat = initial_Q(Q_mat, transition_mat, transition_cost);

qnext = 1;
for k = 1:1:50
    [Q_mat, qnext] = Update_Q(alpha, Q_mat, transition_mat, transition_cost, qnext, k);
end
Q_mat

function Mat = initial_Q(mat, tran_mat, mat_cost)
   [len_state, len_action] = size(mat);
   Mat = zeros(len_state, len_action);
   for i = 1:1:len_state
       for u = 1:1:len_action
           Mat(i,u) = tran_mat(i,1,u)*mat_cost(i,u) + tran_mat(i,2,u)*mat_cost(i,u);
       end
   end
end

function [Mat, qnext] = Update_Q(alpha, mat, mat_tran, mat_cost, state, k)
    % Choose the control
    epsilon = 1/k;
    gamma = 1/(1+k);
    Mat = mat;
    Qstate = Mat(state,:);
    [~, Optimal_action] = min(Qstate);
    coin = rand(1);
    if coin <= 1 - epsilon
        action = Optimal_action;
    else
        if Optimal_action == 1
            action = 2;
        else
            action = 1;
        end
    end
    % Determine the next state
    Tran_mat = mat_tran(state,:,action);
    for i = 1:1:length(Tran_mat)
        Tran_mat(end+1-i) = sum(Tran_mat(1:end+1-i));
    end
    coin = rand(1);
    for i = 1:1:length(Tran_mat)
        if Tran_mat(i) >= coin
            qnext = i;
            break;
        end
    end
    % Choose the next action by greedy policy
    [~, actionj] = min(Mat(qnext,:));
    Mat(state, action) = Mat(state,action)+ gamma * (mat_cost(state,action)+ ...
        alpha * Mat(qnext, actionj) - Mat(state,action));
end
alpha = 0.1;
% State represent A and B, 0 means terminate
State = [1,2];
% Action_A contains Left and Right
Action_A = [1,2];
% Action_B has 10 controls
num_B_control = 10;
Action_B = 1:1:num_B_control;

% transition_cost_A = [0, 0];
% transition_cost_B = normrnd(-0.1,1,[1,num_B_control]);

episode = 300;
times = 2000;
Left = 0;
% Temp records the number of choosing left
Temp = zeros(times, episode);

for t = 1:1:times
    % Initialize Q_A, Q_B
    Q_mat_A = zeros(1, length(Action_A));
    Q_mat_B = zeros(1, length(Action_B));
    for k = 1:1:episode
        % Initialize terminate, state 
        terminate = 1;
        nextstate = 1;
        while(terminate ~= 0)
            % Repeat the update Q until it terminate
            [Q_mat_A, Q_mat_B, nextstate, terminate, leftcount] = Update_Q(alpha, Q_mat_A, Q_mat_B, nextstate);
        end
        if leftcount == 1
            Temp(t,k) = leftcount;
        end
    end
end

% t = Temp(:,1);
% one = 0;
% for i = 1:1:length(t)
%     if t(i) == 1
%         one = one + 1;
%     end
% end
% disp(one);
plot(1:1:episode, mean(Temp(:,:)));

function action = epsilon_greedy(epsilon, mat)
    [~, optimal_action] = max(mat);
    coin = rand(1);
    if coin <= 1 - epsilon
        action = optimal_action;
    else
        action = ceil(length(mat)*rand(1));
%         while(1)
%             action = ceil(length(mat)*rand(1));
%             if action ~= optimal_action
%                 break
%             end
%         end
    end
end

function [Mat_A, Mat_B, nextstate, terminate, leftcount] = Update_Q(alpha, mat_A, mat_B, state)
    if state == 0
        return
    end
    leftcount = 1;
    % Choose the control
    epsilon = 0.1;
    gamma = 1;
    Mat_A = mat_A;
    Mat_B = mat_B;
    % mat is corresponding to the current state
    if state == 1
        mat = mat_A;
    else
        mat = mat_B;
    end
    % Acutal action based on epsilon greedy policy
    action = epsilon_greedy(epsilon, mat);
    % These part is for the initial situation
    if state == 1 && Mat_A(1) == Mat_A(2)
        action = ceil(2*rand(1));
    end
    % Determine the next state
    if state == 1
        if action == 2
            % A - right
            nextstate = 0;
            terminate = 0;
            leftcount = 0;
            return
        else
            % A - left
            nextstate = 2;
            terminate = 1;
            % Choose the next action in State B by greedy policy
            [~, actionB] = max(Mat_B);
            Mat_A(action) = Mat_A(action)+ gamma * (0+ ...
            alpha * Mat_B(actionB) - Mat_A(action));
        end
    else
        % B
        nextstate = 0;
        terminate = 0;
        Mat_B(action) = Mat_B(action) + gamma * (normrnd(-0.1,1)+0- Mat_B(action));
    end
end
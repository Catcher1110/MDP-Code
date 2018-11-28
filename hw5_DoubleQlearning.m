alpha = 1;
% State represent A and B, 0 means terminate
State = [1,2];
% Action_A contains Left and Right
Action_A = [1,2];
% Action_B has 10 controls
num_B_control = 10;
Action_B = 1:1:num_B_control;

% transition_cost_A = [0, 0];
% transition_cost_B = normrnd(-0.1,1,[1,num_B_control]);

episode = 100;
times = 2000;
Left = 0;
% Temp records the number of choosing left
Temp = zeros(times, episode);

for t = 1:1:times
    % Initialize Q_A, Q_B
    Q_mat_A_1 = zeros(1, length(Action_A));
    Q_mat_B_1 = zeros(1, length(Action_B));
    Q_mat_A_2 = zeros(1, length(Action_A));
    Q_mat_B_2 = zeros(1, length(Action_B));
    for k = 1:1:episode
        % Initialize terminate, state 
        terminate = 1;
        nextstate = 1;
        while(terminate ~= 0)
            % Repeat the update Q until it terminate
            [Q_mat_A_1, Q_mat_B_1, Q_mat_A_2, Q_mat_B_2, nextstate, terminate,...
            leftcount] = Update_Q(alpha, Q_mat_A_1, Q_mat_B_1, Q_mat_A_2,...
            Q_mat_B_2, nextstate);
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

function action = epsilon_greedy(epsilon, mat1, mat2)
    mat = mat1 + mat2;
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

function [Mat_A1, Mat_B1, Mat_A2, Mat_B2, nextstate, terminate, ...
    leftcount] = Update_Q(alpha, mat_A1, mat_B1, mat_A2, mat_B2, state)
    if state == 0
        return
    end
    leftcount = 1;
    % Choose the control
    epsilon = 0.2;
    gamma = 0.1;
    Mat_A1 = mat_A1;
    Mat_B1 = mat_B1;
    Mat_A2 = mat_A2;
    Mat_B2 = mat_B2;
    % mat is corresponding to the current state
    if state == 1
        mat1 = mat_A1;
        mat2 = mat_A2;
    else
        mat1 = mat_B1;
        mat2 = mat_B2;
    end
    % Acutal action based on epsilon greedy policy
    action = epsilon_greedy(epsilon, mat1, mat2);
    % These part is for the initial situation
    if state == 1 && Mat_A1(1) == Mat_A1(2)
        action = ceil(2*rand(1));
    end
    
    % Determine which Q to be updated
    coin = rand(1);
    if coin >= 0.5
        % Update Q1
        if state == 1
            if action == 1
                % A - Left
                nextstate = 2;
                terminate = 1;
                [~, actionB] = max(Mat_B1);
                Mat_A1(action) = Mat_A1(action) + ...
                    gamma * (0 + alpha * Mat_B2(actionB)-Mat_A1(action));
            else
                % A - Right
                nextstate = 0;
                terminate = 0;
                leftcount = 0;
                Mat_A1(action) = Mat_A1(action) + gamma * (0 + 0 - Mat_A1(action));
            end
        else
            % B
            nextstate = 0;
            terminate = 0;
            Mat_B1(action) = Mat_B1(action) + ...
                gamma * (normrnd(-0.1,1) + 0 - Mat_B1(action));
        end
    else
        % Update Q2
        if state == 1
            if action == 1
                % A - Left
                nextstate = 2;
                terminate = 1;
                [~, actionB] = max(Mat_B2);
                Mat_A2(action) = Mat_A2(action) + ...
                    gamma * (0 + alpha * Mat_B1(actionB)-Mat_A2(action));
            else
                % A - Right
                nextstate = 0;
                terminate = 0;
                leftcount = 0;
                Mat_A2(action) = Mat_A2(action) + gamma * (0 + 0 - Mat_A2(action));
            end
        else
            % B
            nextstate = 0;
            terminate = 0;
            Mat_B2(action) = Mat_B2(action) + ...
                gamma * (normrnd(-0.1,1) + 0 - Mat_B2(action));
        end
    end
    % Determine the next state
%     if state == 1
%         if action == 2
%             % A - right
%             nextstate = 0;
%             terminate = 0;
%             leftcount = 0;
%             return
%         else
%             % A - left
%             nextstate = 2;
%             terminate = 1;
%             % Choose the next action in State B by greedy policy
%             [~, actionB] = max(Mat_B);
%             Mat_A(action) = Mat_A(action)+ gamma * (0+ ...
%             alpha * Mat_B(actionB) - Mat_A(action));
%         end
%     else
%         % B
%         nextstate = 0;
%         terminate = 0;
%         Mat_B(action) = Mat_B(action) + gamma * (normrnd(-0.1,1)+0- Mat_B(action));
%     end
end
alpha = 1;
% State represent A and B, 0 means terminate
State = [1,2];
% Action_A contains Left and Right
Action_A = [1,2];
% Action_B has 10 controls
num_B_control = 10;
Action_B = 1:1:num_B_control;

episode = 100;
times = 200;
Left = 0;
% Temp records the number of choosing left
TempDQ = zeros(times, episode);

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
            TempDQ(t,k) = leftcount;
        end
    end
end

TempDS = zeros(times, episode);
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
            leftcount] = Update_SARSA(alpha, Q_mat_A_1, Q_mat_B_1, Q_mat_A_2,...
            Q_mat_B_2, nextstate);
        end
        if leftcount == 1
            TempDS(t,k) = leftcount;
        end
    end
end

plot(1:1:episode, mean(TempDQ(:,:)),'b');
hold on;
plot(1:1:episode, mean(TempDS(:,:)),'r');
axis([0,100,0,0.6])

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
    mat = mat1 + mat2;
    action = epsilon_greedy(epsilon, mat);
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
end

function [Mat_A1, Mat_B1, Mat_A2, Mat_B2, nextstate, terminate, ...
    leftcount] = Update_SARSA(alpha, mat_A1, mat_B1, mat_A2, mat_B2, state)
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
    mat = mat1 + mat2;
    action = epsilon_greedy(epsilon, mat);
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
                actionB = epsilon_greedy(epsilon, Mat_B1);
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
                actionB = epsilon_greedy(epsilon, Mat_B2);
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
end
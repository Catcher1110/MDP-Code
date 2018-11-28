x = 20;
mu = [];
for i = 1:1:5
    m = calcu_mu(x(i));
    mu = [mu, m];
    x = [x, gamble(x(i), m)];
end
x
mu

function mu = calcu_mu(xn)
    temp1 = floor(xn * 0.4);
    temp2 = temp1 + 1;
    if calcu_E(xn, temp1) >= calcu_E(xn, temp2)
        mu = temp1;
    else
        mu = temp2;
    end
    if xn - mu < 1
        mu = xn - 1;
    end
end

function a = calcu_E(xn, mu)
    a = 0.7 * log(xn + mu) + 0.3 * log(xn - mu); 
end

function y = gamble(xn, mu)
    if rand(1) > 0.3
        y = xn + mu;
    else
        y = xn - mu;
    end
end




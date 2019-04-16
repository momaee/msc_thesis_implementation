addpath(genpath('Distributed'))
addpath(genpath('Decentralized'))
addpath(genpath('Graph'))
clear 
clc

l_c = 4;
l_f = 4;
l_e = 4;
l_s = 4;
l_t = 10;

Cap_c = (6*rand(l_c, 1));
Cap_f = (4*rand(l_f, 1));
Cap_e = (2*rand(l_e, 1));

delta_t = 3*rand(l_t,1);
w_t = 2*rand(l_t,1);

Pri_c = 3*rand(l_c, 1);
Pri_f = 2*rand(l_f, 1);
Pri_e = rand(l_e,1);

TauTr_c = 3*rand(l_c, 1);
TauTr_f = 2*rand(l_f, 1);
TauTr_e = rand(l_e,1);

R_c = rand(l_c, 1);
R_f = rand(l_f, 1);
R_e = rand(l_e,1);

numofIterations = 30;
lambda = zeros(l_t,numofIterations) + 0.1;
nu = zeros(l_t,numofIterations) + 0.1;
alpha = 0.1;

x_c = zeros(l_c, l_t, numofIterations);
x_f = zeros(l_f, l_t, numofIterations);
x_e = zeros(l_e, l_t, numofIterations);

tau_c = repmat(w_t', [l_c, 1])./repmat(R_c, [1,l_t]) + TauTr_c;
tau_f = repmat(w_t', [l_f, 1])./repmat(R_f, [1,l_t]) + TauTr_f;
tau_e = repmat(w_t', [l_e, 1])./repmat(R_e, [1,l_t]) + TauTr_e;

for t=1:numofIterations-1
    for h=1:l_c
       x_c(h,:,t+1) = newUpdateLocalVariablesFminconDecentralized( Pri_c(h)*w_t, lambda(:, t), nu(:, t), tau_c(h,:)', delta_t, l_c, l_t, w_t, Cap_c(h));
    end
    for j=1:l_f
       x_f(j,:,t+1) = newUpdateLocalVariablesFminconDecentralized( Pri_f(j)*w_t, lambda(:, t), nu(:, t), tau_f(j,:)', delta_t, l_f, l_t, w_t, Cap_f(j));
    end
    for i=1:l_e
       x_e(i,:,t+1) = newUpdateLocalVariablesFminconDecentralized( Pri_e(i)*w_t, lambda(:, t), nu(:, t), tau_e(i,:)', delta_t, l_e, l_t, w_t, Cap_e(i));
    end

    lambda(:, t+1) = updateGlobalVariables(alpha, lambda(:,t), x_e(:,:,t+1), x_f(:,:,t+1), x_c(:,:,t+1), delta_t, tau_e, tau_f, tau_c);
    nu(:, t+1) = updateGlobalVariables2(alpha, nu(:,t), x_e(:,:,t+1), x_f(:,:,t+1), x_c(:,:,t+1));

end

tRec_eMax = zeros(l_t, numofIterations);
for t=1:numofIterations
    for k=1:l_t
        tRec_eMax(k,t) = max(x_e(:,k,t));
    end
end

figure;
plot(lambda(1,:));
figure;
plot(lambda(5,:));
figure;
plot(nu(1,:));
figure;
plot(nu(5,:));
figure;
plot(tRec_eMax(5,:));
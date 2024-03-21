%% Run Control for Candidate_Circuit_C_BG_T_C_Model

clear all

%% Parameters

% Striatum (D2)
H_d2 = 20;
tau_d2 = 0.0022;
r_d2 = 0.3;
gamma_d2 = 300;

% GPe
H_g = 20;       
tau_g = 0.014;
r_g = 0.1;
gamma_g = 400;

% STN
H_s = 20;       
tau_s = 0.01;
r_s = 0.1;
gamma_s = 500;

% GPi
H_gi = 20;       
tau_gi = 0.014;
r_gi = 0.1;
gamma_gi = 400;

% Thalamus
H_t = 10;       
tau_t = 0.002;
r_t = 5;
gamma_t = 20;

% Cortex
% Cortex: Excitatory Interneurons
H_EI = 20;       
tau_EI = 0.01;
r_EI = 5;
gamma_EI = 5;

% Cortex: Pyramidal Cells
H_PY = 20;       
tau_PY = 0.001;
r_PY = 0.15;
gamma_PY = 5;

% Cortex: Inhibitory Interneurons
H_II = 60;       
tau_II = 2;
r_II = 5;
gamma_II = 5;

%% Connection Strengths

C_bg_th = 60; % 3 = normal, 60 = pathological
C_bg_th_cor = 5; % 9.75 = normal, 5 = pathological
C_cor  = 60; % 3 = normal, 60 = pathological
C_cor_bg_th = 5; % 9.75 = normal, 5 = pathological

D2_D2 = 0.5*C_bg_th;
D2_GPe = 0.5*C_bg_th;
GPe_GPe = 0.5*C_bg_th;
GPe_STN = 0.5*C_bg_th;
GPe_GPi = 0.5*C_bg_th;
STN_GPe = C_bg_th;
STN_GPi = C_bg_th;
GPi_Th = 0.5*C_bg_th;
Th_EI = C_bg_th_cor;
EI_PY = 4.8*C_cor;
PY_EI = 6*C_cor;
PY_II = 1.5*C_cor;
PY_STN = C_cor_bg_th;
PY_D2 = C_cor_bg_th;
II_PY = 1.5*C_cor;
II_II = 3.3*C_cor;


%% Run Model

Simulation_Time = 10;
sim('Candidate_Circuit_C_BG_T_C_Model',Simulation_Time)

%% Plot Outputs

out = ans; 

figure(1)
hold on

subplot(2,1,1)
hold on
plot(out.LFP_PY, 'color',[ 0.9100 0.4100 0.1700],'LineWidth', 1.1)
hold on
plot(out.LFP_D2, 'k', 'LineWidth', 1.1)
xlim([0 Simulation_Time])
title('Time Series Plot: Cortex, Striatum')
ylabel('Noisy Inputs to STN-GPe Loop')
xlabel('Time (seconds)')
legend('Cortex', 'Striatum')

subplot(2,1,2)
hold on
plot(out.LFP_GPe, 'b','LineWidth', 1.1)
hold on
plot(out.LFP_STN, 'r','LineWidth', 1.1)
xlim([0 Simulation_Time])
title('Time Series Plot: GPe-STN Loop')
ylabel('LFP (arb. voltage units)')
xlabel('Time (seconds)')
legend('GPe', 'STN')

set(gcf, 'color','w')

%% Data Saving
D2 = out.LFP_D2;
GPe = out.LFP_GPe;
STN = out.LFP_STN;
PY = out.LFP_PY;
save('Normal_Case.mat','D2','GPe','STN', 'PY')

%% Data Analysis

% PSD
Fs = 256;
t = 0:1/Fs:Simulation_Time;
h = spectrum.welch;

Hpsd_PY = psd(h, PY.Data, 'Fs',Fs);
Hpsd_STN = psd(h, STN.Data, 'Fs',Fs);
Hpsd_GPe = psd(h, GPe.Data, 'Fs',Fs);

figure(3)
hold on
plot(Hpsd_PY.Data, 'color',[ 0.9100 0.4100 0.1700], 'LineWidth',1.5)
hold on
plot(Hpsd_STN.Data,'r','LineWidth',1.5)
hold on
plot(Hpsd_GPe.Data,'b','LineWidth',1.5)
xlim([0 60])
title('PSD')
legend('PY','STN', 'GPe')
set(gcf, 'color','w')

%% MECA 482 Group ID9

%% Team Members
"Patrick OKeefe";
"Alize Hall";
"Thomas Cunningham";
"Emily Williams";





%% Ball Balancing Beam Constants
clc; clear;
L = 1; %length of the beam (m)
d = 0.03; %servo arm length (m)
m = 0.065; %mass of the ball (kg)
r = 0.0127; %radius of the ball (m)
g = -9.8; %gravitational acceleration (m/s^2)
J = 2/5*m*(r^2); %balls moment of inertia (kg*m^2)
OS=0.05; %Percent overshoot as a percent of 1
Ts=1; %Settling time goal
S = tf('s'); %Transfer function in S-Domain
Pos_ball = -m*g*d/L/(J/r^2+m)/S^2 %Plant of the system P(s)

%% Root Locus for the system
rlocus(Pos_ball)
sgrid(0.7, 1.9)
axis([-5 5 -2 2])
Zo=0.01;
Po=5;
C=tf([1 Zo],[1,Po]);
rlocus(C*Pos_ball)
sgrid(0.7,1.9)
[k,poles]=rlocfind(C*Pos_ball)

%% Plotting Root Locus
sys_cl=feedback(k*C*Pos_ball,1);
t=0:0.01:5;
figure(2)
step(1*sys_cl,t)

%% Step Response for a PD controller

input_step=1; %step for the step response
Kp = 13; %Proportional gain
Kd = 57; %Derivative gain
Ki = 0; %Integral gain (zero because its not needed for this system)
C = pid(Kp,Ki,Kd); %function for PID controller

system=feedback(C*Pos_ball,1);
figure(1);
system_step=input_step*system;
[y]=[(1+OS)*input_step;0.98*input_step;1.02*input_step]; %setting up the horizontal lines for percent OS and settling time
t=0:0.01:10;
step(system_step) %plots the step response for the system
line([0,t(end)],[y(1),y(1)],'Color','red'); %Percent Overshoot line, DO NOT CROSS
line([0,t(end)],[y(2),y(2)],'Color','green'); %98 Percent line for settling time
line([0,t(end)],[y(3),y(3)],'Color','green'); %102 Percent line for settling time
line([Ts,Ts],[0,10],'color','black','LineStyle',':') %Settling time goal
axis([0 1.25 0 (1.25*input_step)]); %sets up the axis limits for the plot
S=stepinfo(system_step) %system resultant parameters

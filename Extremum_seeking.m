clear all;
close all;
clc;
n=-5:0.1:15;
j=@(u,l)(25-(5-(u)).^2);
plot(n, j(n))
%%
y0=j(0,0);
u=0;
%extremum seeking control parameters
freq=10*2*pi;
dt=1/freq;
T=10; %total time period
A=0.2;%amplitdude
omega=10*2*pi;
phase=0;
K=5;
%highpass filter
buttorder=1;
buttfreq=2;
[b,a]=butter(buttorder,buttfreq*dt*2,'high');
ys=zeros(1,buttorder+1)+y0;
HPF=zeros(1,buttorder+1);
uhat=u;
for i=1:T/dt
    t=(i-1)*dt;
    yvals(i)=j(u,t);
    
    for k=1:buttorder
        ys(k)=ys(k+1);
        HPF(k)=HPF(k+1);
    end
    ys(buttorder+1)=yvals(i);
    HPFnew=0;
    for k=1:buttorder+1
        HPFnew= HPFnew+ b(k)*ys(buttorder+2-k);
    end
    for k=2:buttorder+1
    HPFnew= HPFnew -a(k)*HPF(buttorder+2-k);
    end
    HPF(buttorder+1)=HPFnew;
    
    xi=HPFnew*sin(omega*t+phase);
    uhat=uhat+xi*K*dt;
    u=uhat+A*sin(omega*t+phase);
    uhats(i)=uhat;
    uvals(i)=u;
end
t=dt:dt:T;

figure
subplot(2,1,1)
plot(t',uvals','g',t,uhats,'-b');
hold
subplot(2,1,2)
plot(t,yvals);


    

    
        
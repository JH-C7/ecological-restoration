%%          Node Recovery Robustness
clear
clc
%%          Read the adjacency matrix from Excel
Aplot=xlsread('result.xlsx');   
N=size(Aplot,1);
Nr=0;
xNr=0:1:N-1;
yDM=zeros(N,1);
yDR=zeros(N,1);
yNdm=zeros(N,1);
yNdr=zeros(N,1);
Nd=0;
%%          Find the degree of each node.                  
Countdgree=zeros(N,1);
for i=1:N
    Connect=find(Aplot(i,:)==1);
    Countdgree(i)=size(Connect,2);
end
[B,index]=sort(Countdgree,'descend');  
%Arrange in descending order of degree.
%%        D (initial)
yDM(1)=1;
yDR(1)=1;
%%          1. MaliciousAttack
for Nr=1:N-1
    Nd=0;
    for i=1:Nr
        Connect=find(Aplot(index(i),:)==1);
        Intersect=intersect(index(1:Nr),Connect);
        if size(Intersect,1)<size(Connect,2)
            Nd=Nd+1;
        end
    end
    % ±£´æNd
    yNdm(Nr+1)=Nd;
end
%%          R
for i=1:N-1
    yDM(i+1)=1-(xNr(i+1)-yNdm(i+1))/N;
end
%%          2. RandomAttack
iRandom(:,1) = randperm(N);
for Nr=1:N-1
    Nd=0;
    for i=1:Nr
        Connect=find(Aplot(iRandom(i),:)==1);
        Intersect=intersect(iRandom(1:Nr),Connect);
        if size(Intersect,1)<size(Connect,2)
            Nd=Nd+1;
        end
    end
    % Save Nd
    yNdr(Nr+1)=Nd;
end
%%        
for i=1:N-1
    yDR(i+1)=1-(xNr(i+1)-yNdr(i+1))/N;
end
%%        Drawing (Node Recovery Robustness)
figure(1)
plot(xNr(1:N),yDM(1:N),'r','LineWidth',3);
hold on;
plot(xNr(1:N),yDR(1:N),'b','LineWidth',3);
% title("Node Robustness Restoration");;
set(gca,'FontName','Times New Roman','FontSize',12);
legend('Malicious attack','Random attack');
% xlabel('Nr');
xlabel('Number of removed nodes');
ylabel('Node recovery robustness');
% ylabel('D');
% grid on;



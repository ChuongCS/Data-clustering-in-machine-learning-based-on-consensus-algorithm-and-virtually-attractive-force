function[X]=consensus(D)

lamda=0.001;
d=pdist2(D(:,1:end),D(:,1:end),'seuclidean');
L=d-d;
s=zeros(size(d,1),1);
delta=0.01;

 X= D;
% for t=1:50
%     for m=1:size(d,1)
%         for n=1:size(d,1)
%             L(m,n)=1/(1+(d(m,n)^2)/lamda);
%             L(m,n)=exp(-(d(m,n)^2));
%         end
%     end
% 
%     for m=1:size(d,1)
%         L(m,m)=0;
%     end
% 
%     for m=1:size(d,1)
%         s(m)=sum(L(m,:));
%     end
% 
%     for m=1:size(d,1)
%         L(m,m)=-s(m);
%     end
%     
%     X=X+delta*L*X;
% end

return;




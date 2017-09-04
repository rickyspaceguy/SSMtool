function [lambda_out,T,A] = compute_subspace(M,C,K,scaling,conservative)

A = [sym(zeros(size(M))),sym(eye(size(M)));-(M\K),-(M\C)];

[Xmode,lambda] = eig(A);
lambda  = diag(lambda);

if rank(Xmode) < size(A,1)
   error('Linear matrix A is not semisimple')
end

if conservative 
    [~,k] = sort(double(abs(imag(lambda))),'ascend');
else
    col  = [real(lambda),imag(lambda)];
    [~,k]= sortrows(double(col),[-1,-2]);
end

T = Xmode(:,k);
lambda_out.sym = lambda(k);
lambda_out.num = double(lambda(k));
A = double(A);

for i = 1:size(T,2)
       T(:,i) = T(:,i)/norm(T(:,i));
end
    
T = scaling*T;  
T = double(T);
    
if ~conservative 
    if ~isempty(lambda(real(lambda)>=0))
        error('Real part for each eigenvalue of Spec(A) must be strictly negative')
    end
end




end


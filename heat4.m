function U = heat4(a, f, u0, g1, g2, L, T, nx, nt)
  
% parameters
% ghost point adds 1 more point so we have N+2 equations
nx2 = nx+2;
hx = L/nx;
nt1 = nt+1;
ht = T/nt;
 
r = (a*ht)/(hx^2);
r1 = 1- 2*r; 
 
xvec = hx*(0:nx+1);
 
tvec = ht*(0:nt);
 
% initial condition
U = zeros(nt1, nx2);
%U(1,:) = feval(u0, xvec(:)');
 
% the one cell on the end is the ghost cell
for i = 1:nx+2
   U(1, i) = cos(pi*xvec(i)/2); 
end
 
% Boundary Condition at first and last column
%U(2:nt1, 1) = feval(g1, (1:nt)*ht);
U(1:nt1, nx2) = 0;%feval(g2, (1:nt)*ht);
 
 
for k = 1:nt
    % from the column adjacent to the rightmost boundary all the way to the
    % second column
    for j = nx+1:-1:2
        U(k+1,j) = U(k, j) + r*(U(k, j+1) -2*U(k, j) + U(k, j-1));
    end
    
    % when we get to the second column set U(k, 1) = U(k, 2)
    U(k+1, 1) = U(k+1, 3);
end
 
 
figure
[X, Y] = meshgrid(hx*(0:nx+1), ht*(0:nt));
surf(X, Y, U,'FaceColor','interp',...
   'EdgeColor','blue',...
   'FaceLighting','phong')
axis tight
view(-50,50)
camlight left
 
xlabel('space');
ylabel('time');
zlabel('Temperature');
 
% exacat solution
 
%exac
exSol = zeros(nt1, nx2);
for i = 1:nt1
    for j = 1:nx2 
        exSol(i, j) = cos((pi*(j-1)*hx)/2)*exp(-a*((pi^2)*(i-1)*ht)/4);
    end
end
 
figure
title('Exact')
surf(X, Y, exSol,'FaceColor','interp',...
   'EdgeColor','blue',...
   'FaceLighting','phong')
axis tight
view(-50,50)
camlight left
 
xlabel('space');
ylabel('time');
zlabel('Temperature');
 
 
% find solution at t=1 for numerical solution U and compare with analytical
% solution
gt1 = find(tvec > 1);
start = gt1(1);
figure;
 plot(xvec, U(start, :), '-b', 'LineWidth', 4)
 exSol1 = cos(pi*xvec./2)*exp(-(pi^2)/4);
 hold on;
plot(xvec, exSol1, '-r', 'LineWidth', 4);
legend('Numerical Solution', 'Exact Solution');
xlabel('Space')
ylabel('Temperature')
 
end


close all
clear all       % clears all variables

load room.mat;  % loads the room model
load css.mat;   % loads the CSS data

CC = 20; %20 CSS blocs

loudspeaker=[];
for i=1:CC  %  CSS blocks
    loudspeaker = [loudspeaker css];
end
echo = filter(room,1,loudspeaker);

N = length(loudspeaker);


muv = [0.1 0.25 0.5 0.75 1 1.25 1.5 1.75 1.9]; % step-sizes

epsilon = 1e-6;
M = 1024; %taps

w = zeros(M,1);   % Initial weight estimate
u = zeros(1,M);


KK = length(muv);
display('Please wait for 9 iterations....this takes some time')
for k = 1:KK
  k
  w = zeros(M,1);   % Initial weight estimate
  mu = muv(k);
  u = zeros(1,M);
  e = zeros(1,N);
  d = echo;
  for i=1:N 
    u = [loudspeaker(i) u(1:M-1)];
    e(i) = d(i) - u*w;
    factor = epsilon + norm(u)^2;
    w = w + (mu/factor)*u'*e(i);  % NLMS recursion
  end
  mis(k) = (norm(w-room)^2)/(norm(room)^2); % relative mismatch
  
  if mu == 0.5
    error = e;  % save error signal for mu=0.5
  end
  
  if mu == 0.1
    error2 = e;  % save error signal for mu=0.1
  end

end



 figure
 subplot(411);
 plot(loudspeaker); 
 grid;
 title('Loudspeaker');
 axis([0 CC*5600 -5 5]); 
 subplot(412);
 plot(echo); grid;
 title('Echo');
 axis([0 CC*5600 -5 5]); 
 subplot(413);
 plot(error); grid;
 title('Error for \mu=0.5');
 axis([0 CC*5600 -5 5]); 
 subplot(414);
 plot(error2); grid;
 title('Error for \mu=0.1');
 xlabel('i');
 axis([0 CC*5600 -5 5]); 

 
 figure
 plot(muv,10*log10(mis),'b-o');
 xlabel('\mu');
 ylabel('mismatch (dB)');
 axis tight;
 grid;

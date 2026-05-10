

close all
clear all       % clears all variables

load room.mat;  % loads the room model
load speech;   % loads the CSS data

epsilon = 1e-6;
M = 1024; % length of filter in fullband
B = 32;    % block size of data
K = 2*B; % number of subband filters (2M should be divisible by K)
MM = M/B;  % length of each subband filter 
beta = 0.9;
mu = 0.03; 

N = max(size(speech));
len1 = (fix(N/B))*B; %length adjusted to multiple of B

CC = 20;
loudspeaker = []; % repeat speech signal for longer simulation
for i=1:CC
  loudspeaker = [loudspeaker speech(1:len1)'];
end

len = len1*CC;

input = loudspeaker(1:len)';
echo = filter(room,1,input);
reference = echo;
e   = zeros(size(input)); % error sequence for NLMS with power normalization
hat_d = zeros(size(reference));  % for NLMS with power normalization
 
reg = zeros(1,M);       % regression vector of fullband filter 
wideband = zeros(M,1);  % wideband filter coefficients for NLMS with power normalization
 
regressor = zeros(K,MM);  % regression vectors of subband filters 
w = zeros(MM,K);          % coefficients of subband filters for NLMS with power normalization
block_u = zeros(K,1); 
D = epsilon*eye(2*B);
  
%% The data is processed in blocks of size B each. 
%% Two adaptation algorithms are run in parallel for comparison purposes:
%% one is NLMS with power normalization and the other is standard NLMS

for i=1:len/B  
   %i
   for j=1:B % compute a block of error signals
      reg = [input((i-1)*B+j) reg(1:M-1)];    
      hat_d((i-1)*B+j) = reg*wideband; 
      e((i-1)*B+j) = reference((i-1)*B+j) - hat_d((i-1)*B+j); 
   end 
      
   block_u = [flipud(input((i-1)*B+1:i*B)); block_u(1:B)]; % top block is shifted down
   block_e = [flipud(e((i-1)*B+1:i*B)); zeros(B,1)]; % bottom block is always zero 
   block_u_fft = (1/sqrt(K))*fft(block_u);   
   block_e_fft = (1/sqrt(K))*fft(block_e);   

   for j=1:K
    D(j) = beta*D(j) + (1-beta)*abs(block_u_fft(j))^2;
   end
   
   
   for j=1:K 
     regressor(j,:) = [block_u_fft(j) regressor(j,1:MM-1)]; 
     w(:,j) = w(:,j) + (mu/MM)*(regressor(j,:)'*block_e_fft(j))/D(j);   % power normalization with step-size scaled by MM
   end 
    
   g = (1/sqrt(K))*fft(w.');  % The columns of w are transposed without complex conjugation. 
   G = real(g(1:B,:));  % Enforcing the constraint.
   for j = 1:MM 
      wideband((j-1)*B+1:j*B) = G(:,j); 
   end 
end

 error = e;

 figure
 subplot(311);
 plot(loudspeaker); 
 grid;
 title('Loudspeaker');
 axis([0 len-1 -1 1]); 
 subplot(312);
 plot(echo); grid;
 title('Echo');
 axis([0 len-1 -1 1]); 
 subplot(313);
 plot(error); grid;
 title('Error');

 axis([0 len-1 -1 1]); 
 xlabel('i');
 
 display('Let us now hear the signals')
 display('Press a key to hear the loudspeaker signal');
 pause
 sound(loudspeaker(len1*(CC-1):len));
 display('Press a key to hear the echo');
 pause
 sound(echo(len1*(CC-1):len));
 display('Press a key to hear the error');
 pause
 sound(error(len1*(CC-1):len));

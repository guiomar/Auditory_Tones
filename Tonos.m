clc; clear; close all;
%Volumen 74
% mydir = 'C:\Users\elenav92\Downloads\';
mydir = 'C:\Users\Usuario\Downloads\';

SUBJECT = 's02';


Adb   = 10:10:50; % Amplitudes (dB)
Ampli = 10.^(Adb/20)*0.00002; % Amplitudes (Pascales)

Freqs = 500:2000:10000; %Frecuencias (Hz)
SR    =  22050; %30000; %Frecuencia de muestreo (Hz)
T     = 1; % Duración del tono (s)

t = 0:1/SR:T; %Duración 

NtrialsF = length(Freqs); %Número de frecuencias
NtrialsA = length (Ampli); %Número de amplitudes

NtrialsTotal = NtrialsA*NtrialsF;

Signal_AF = zeros (NtrialsA, NtrialsF, length(t));
Result_dcha = []; 
Result_izq = [];
Results = zeros (NtrialsTotal*2, 5);

AF=[];

%Bucle de frecuencias
for iF = 1:NtrialsF
    
F = Freqs(iF);

%Bucle de amplitudes
for iA = 1:NtrialsA 
    
    A = Ampli(iA);
    
    Signal_AF(iA, iF,:) = A*sin(2*pi*F*t);
    
    %Recuperar la amplitud y la frecuencia
       
    AF(end+1,:) = [F Adb(iA)];

end
end

Signal_all = reshape(Signal_AF,NtrialsTotal,length(t));
%Señal dividida en oido izq y derecho
% Concatena las dos señales a lo largo de la tercera dimension
Signal_LR = cat(3,[Signal_all; zeros(size(Signal_all))],[ zeros(size(Signal_all)); Signal_all]);
% Guardamos: amplitud, frecuencia y lado
AFL = [[AF zeros(NtrialsTotal,1)];[ AF ones(NtrialsTotal,1)]];

RandIndices = randperm(NtrialsTotal*2);
ITI = 1+rand(1,NtrialsTotal*2); 

disp('PULSE "d" o "i" según escuche el tono por la derecha o por la izquierda. Pulse "n" si no escucha sonido');

for iM = 1:length(RandIndices)

%Señal aleatoria
Signal_i = squeeze(Signal_LR(RandIndices(iM),:,:))';

% REPRODUCE LA SEÑAL
sound(Signal_i,SR)
tic

% RESPUESTA (BOTON)
button = input('','s');
    %Opciones de entrada de texto
    switch button 
        case 'd',    M = 0;
        case 'i',    M = 1;
        case 'n',    M = 2; % no lo escucha
        otherwise,   M = 2;
    end

Results(iM,:) = [M,AFL(RandIndices(iM),:),toc];

% Lado por el que se escucha 
if AFL(RandIndices(iM),3) == 0
    Result_dcha(end+1,:) = [M,AFL(RandIndices(iM),:),toc];
elseif AFL(RandIndices(iM),3) == 1
    Result_izq(end+1,:)  = [M,AFL(RandIndices(iM),:),toc];
end


% DESPUES DE PULSAR 
% * DEBERIA SER TRAS EL SONIDO (DEJANDO EL SUFICIENTE TIEMPO PARA PULSAR??
% De momento lo dejamos así
pause(ITI(iM))

end

% Matrices ordenadas
Dcha_aux = sortrows(Result_dcha(:,[1 2 3]),[2 3]); % Ordena de forma creciente frecuencia (dim 2), y amplitud (dim 3)
Izq_aux  = sortrows(Result_izq(:,[1 2 3]),[2 3]);

Matriz_dcha = reshape (Dcha_aux(:,[1]),[NtrialsA,NtrialsF]);
Matriz_izq  = reshape (Izq_aux(:,[1]),[NtrialsA,NtrialsF]);

DchaT_aux = sortrows(Result_dcha(:,[2 3 5]),[1 2]); % Ordena de forma creciente frecuencia (dim 1), y amplitud (dim 2)
IzqT_aux  = sortrows(Result_izq(:,[2 3 5]),[1 2]); % Ordena de forma creciente frecuencia (dim 1), y amplitud (dim 2)
MatrizT_dcha = reshape (DchaT_aux(:,[3]),[NtrialsA,NtrialsF]);
MatrizT_izq  = reshape (IzqT_aux(:,[3]),[NtrialsA,NtrialsF]);


%%
figure (1);

subplot (1,2,1);
hFig1a = gca; %Get current axis

imagesc(Matriz_izq);
title ('Oído izquierdo');

% Barra de color

colorbar('Ticks',[0, 1, 2], 'TickLabels',{'Lado derecho','Lado izquierdo','No escuchado'})
grid 
set(hFig1a, 'XLim', [0.5 (NtrialsF + 0.5)])
set(hFig1a, 'YTick',1:NtrialsA )
set(hFig1a, 'XTick',1:NtrialsF )
set(hFig1a, 'XTickLabel',Freqs(1:NtrialsF))
set(hFig1a, 'YTickLabel', Adb(1:NtrialsA))


subplot (1,2,2);
hFig2a = gca; %Get current axis

imagesc(Matriz_dcha);
title ('Oído derecho');
grid 
set(hFig2a, 'XLim', [0.5 (NtrialsF + 0.5)])
set(hFig2a, 'YTick',1:NtrialsA )
set(hFig2a, 'XTick',1:NtrialsF )
set(hFig2a, 'XTickLabel',Freqs(1:NtrialsF))
set(hFig2a, 'YTickLabel', Adb(1:NtrialsA))

colorbar('Ticks',[0, 1, 2], 'TickLabels',{'Lado derecho','Lado izquierdo','No escuchado'})



%%
figure (2);

subplot (1,2,1);
hFig1a = gca; %Get current axis

imagesc(MatrizT_izq);
title ('Oído izquierdo');

% Barra de color

% colorbar('Ticks',[0, 1, 2], 'TickLabels',{'Lado derecho','Lado izquierdo','No escuchado'})
grid 
set(hFig1a, 'XLim', [0.5 (NtrialsF + 0.5)])
set(hFig1a, 'YTick',1:NtrialsA )
set(hFig1a, 'XTick',1:NtrialsF )
set(hFig1a, 'XTickLabel',Freqs(1:NtrialsF))
set(hFig1a, 'YTickLabel', Adb(1:NtrialsA))


subplot (1,2,2);
hFig2a = gca; %Get current axis

imagesc(MatrizT_dcha);
title ('Oído derecho');
grid 
set(hFig2a, 'XLim', [0.5 (NtrialsF + 0.5)])
set(hFig2a, 'YTick',1:NtrialsA )
set(hFig2a, 'XTick',1:NtrialsF )
set(hFig2a, 'XTickLabel',Freqs(1:NtrialsF))
set(hFig2a, 'YTickLabel', Adb(1:NtrialsA))

% colorbar('Ticks',[0, 1, 2], 'TickLabels',{'Lado derecho','Lado izquierdo','No escuchado'})

%Guardar resultados
save([mydir,'Resultados_',SUBJECT,'.mat'],'Results');


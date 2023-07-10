% Leandro Martins Tosta
% Eiti Parruca Adama
% Guilherme Moreira Lima Furlaneto

% Funcionamento do Programa
% Faça importação do audio e execute a sessão Equalizador.

clc 
clear all
close all

%% Gravação do audio
% Criar objeto mobiledev
m = mobiledev;

%% Gravando audio 
m.Logging = 1; % Iniciar gravação
duracao_gravacao = 10;

% Tempo de gravação
tic;
while toc < duracao_gravacao 
    
end
m.Logging = 0; % Encerrar gravação

audio = readAudio(m,'OutputFormat','timetable');
audio_data = audio.Variables;

% Tempo do audio e frequencia
fs_audio = audio.Properties.SampleRate;
N_audio = length(audio_data);
t_audio = 0:1/fs_audio:(N_audio-1)/fs_audio;

%% Salvar o audio
audiowrite('Musica.wav', audio_data, fs_audio);

%% Importar audio
[audio_data, fs_audio] = audioread('MI.wav');
N_audio = length(audio_data);
t_audio = 0:1/fs_audio:(N_audio-1)/fs_audio;


%% Reprodução dos audios
sound(audio_data, fs_audio);

%% Equalizador
controlador = true;
controlaEco = false;
controlaGuitar = false;

[audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_data, fs_audio);

while controlador
    fprintf('\n\n----- EQUALIZADOR -----');
    fprintf('\n1 - POP\n2 - ROCK\n3 - JAZZ\n4 - HIP HOP\n5 - ELETRONICA\n6 - PERSONALIZADO\n7 - ECO\n8 - Remover ECO\n9 - DISTORCAO\n');
    fprintf('10 - Remove Distorcao\n11 - SAIR\n');
    opcao_switch = input('Opcao: ');
    
    switch opcao_switch
        case 1
            [POP] = audio_POP(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8);
            sound(POP, fs_audio);
            fprintf('Reproduzindo...\nAguarde a reproducao terminar!');
        case 2
            [ROCK] = audio_ROCK(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8);
            sound(ROCK, fs_audio);
            fprintf('Reproduzindo...\nAguarde a reproducao terminar!');
        case 3
            [JAZZ] = audio_JAZZ(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8);
            sound(JAZZ, fs_audio);
            fprintf('Reproduzindo...\nAguarde a reproducao terminar!');
        case 4
            [HIPHOP] = audio_HIPHOP(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8);
            sound(HIPHOP, fs_audio);
        case 5
            [ELETRONICA] = audio_ELETRONICA(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8);
            sound(ELETRONICA, fs_audio);
            fprintf('Reproduzindo...\nAguarde a reproducao terminar!');
        case 6
            distribuicao_bandas = [20 200; 200 400; 400 800; 800 1500; 1500 3000; 3000 5000; 5000 7000; 7000 10000; 10000 15000];
            ganho = [];
            for i = 1:9
                fprintf('Frequencia de %d Hz a %d Hz', distribuicao_bandas(i,1), distribuicao_bandas(i,2));
                entrada = input('\nGanho : ');
                ganho(i) = entrada;
            
            end
            [PERSONALIZADO] = audio_PERSONALIZADO(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8, ganho);
            sound(PERSONALIZADO, fs_audio); 
            fprintf('Reproduzindo...\nAguarde a reproducao terminar!');
        case 7 
            controlaEco = true;
            ganho_eco = input('Ganho Inicial: ');
            dist_eco = input('Distancia Amostras: ');
    
            if controlaGuitar 
                guitar = cumsum(audio_data);
                [audio_eco] = adicionarEco(guitar, ganho_eco, dist_eco, 5, fs_audio);
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_eco, fs_audio);
            else
                [audio_eco] = adicionarEco(audio_data, ganho_eco, dist_eco, 5, fs_audio);
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_eco, fs_audio);
            end
            fprintf('ECO Adicionado!');
        case 8
            controlaEco = false;
            if controlaGuitar
                guitar = cumsum(audio_data);
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(guitar, fs_audio);
            else
               [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_data, fs_audio);
            end
            fprintf('ECO Removido!');
        case 9
            controlaGuitar = true;
            if controlaEco
                guitar = cumsum(audio_eco);
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(guitar, fs_audio);
            else
                guitar = cumsum(audio_data);
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(guitar, fs_audio);
            end
            fprintf('Distorcao Adicionada!');
        case 10
            controlaGuitar = false;
            if controlaEco             
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_eco, fs_audio);     
            else
                [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_data, fs_audio);
            end  
            fprintf('Distorcao Removida!');
        case 11
            disp('FINALIZANDO...');
            controlador = false;
    end
end


%% PLOT

figure
hold all
plot(t_audio,POP,'k');
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Audio Distorcido');
grid on

%% Equalizador PERSONALIZADO
function [audio_PERSONALIZADO] = audio_PERSONALIZADO(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8, ganho)

    outputSignal_EQ_1 = audio_0*ganho(1) + audio_1*ganho(2) + audio_2*ganho(3);
    outputSignal_EQ_2 = audio_4*ganho(4) + audio_5*ganho(5) + audio_3*ganho(6); 
    outputSignal_EQ_3 = audio_6*ganho(7) + audio_7*ganho(8) + audio_8*ganho(9);

    audio_PERSONALIZADO = outputSignal_EQ_1 + outputSignal_EQ_2 + outputSignal_EQ_3;
end

%% Equalizador POP
function [audio_POP] = audio_POP(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8)
    % Aplicando ganhos POP
    ganho = [1 2 0 0 0 10 12 10 8];

    outputSignal_EQ_1 = audio_0*ganho(1) + audio_1*ganho(2) + audio_2*ganho(3);
    outputSignal_EQ_2 = audio_4*ganho(4) + audio_5*ganho(5) + audio_3*ganho(6); 
    outputSignal_EQ_3 = audio_6*ganho(7) + audio_7*ganho(8) + audio_8*ganho(9);

    audio_POP = outputSignal_EQ_1 + outputSignal_EQ_2 + outputSignal_EQ_3;
end

%% Equalizador ROCK
function [audio_ROCK] = audio_ROCK(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8)
    % Aplicando ganhos POP
    ganho = [2 0 8 10 8 0 0 0 0];

    outputSignal_EQ_1 = audio_0*ganho(1) + audio_1*ganho(2) + audio_2*ganho(3);
    outputSignal_EQ_2 = audio_4*ganho(4) + audio_5*ganho(5) + audio_3*ganho(6); 
    outputSignal_EQ_3 = audio_6*ganho(7) + audio_7*ganho(8) + audio_8*ganho(9);

    audio_ROCK = outputSignal_EQ_1 + outputSignal_EQ_2 + outputSignal_EQ_3;
end

%% Equalizador JAZZ
function [audio_JAZZ] = audio_JAZZ(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8)
    % Aplicando ganhos POP
    ganho = [2 0 10 12 10 8 0 0 0];

    outputSignal_EQ_1 = audio_0*ganho(1) + audio_1*ganho(2) + audio_2*ganho(3);
    outputSignal_EQ_2 = audio_4*ganho(4) + audio_5*ganho(5) + audio_3*ganho(6); 
    outputSignal_EQ_3 = audio_6*ganho(7) + audio_7*ganho(8) + audio_8*ganho(9);

    audio_JAZZ = outputSignal_EQ_1 + outputSignal_EQ_2 + outputSignal_EQ_3;
end

%% Equalizador HIPHOP
function [audio_HIPHOP] = audio_HIPHOP(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8)
    % Aplicando ganhos POP
    ganho = [2 5 5 4 0 0 0 0 0];

    outputSignal_EQ_1 = audio_0*ganho(1) + audio_1*ganho(2) + audio_2*ganho(3);
    outputSignal_EQ_2 = audio_4*ganho(4) + audio_5*ganho(5) + audio_3*ganho(6); 
    outputSignal_EQ_3 = audio_6*ganho(7) + audio_7*ganho(8) + audio_8*ganho(9);

    audio_HIPHOP = outputSignal_EQ_1 + outputSignal_EQ_2 + outputSignal_EQ_3;
end


%% Equalizador ELETRONICA
function [audio_ELETRONICA] = audio_ELETRONICA(audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8)
    % Aplicando ganhos POP
    ganho = [2 0 0 0 0 4 8 12 15];

    outputSignal_EQ_1 = audio_0*ganho(1) + audio_1*ganho(2) + audio_2*ganho(3);
    outputSignal_EQ_2 = audio_4*ganho(4) + audio_5*ganho(5) + audio_3*ganho(6); 
    outputSignal_EQ_3 = audio_6*ganho(7) + audio_7*ganho(8) + audio_8*ganho(9);

    audio_ELETRONICA = outputSignal_EQ_1 + outputSignal_EQ_2 + outputSignal_EQ_3;
end



%% Divisor de bandas
function [audio_0, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6, audio_7, audio_8] = bandas(audio_data, fs_audio)
    [audio_0] = filtroIIR(audio_data, fs_audio, [20 200], 'bandpass');
    [audio_1] = filtroIIR(audio_data, fs_audio, [200 400], 'bandpass');
    [audio_2] = filtroIIR(audio_data, fs_audio, [400 800], 'bandpass');
    [audio_3] = filtroIIR(audio_data, fs_audio, [800 1500], 'bandpass');
    [audio_4] = filtroIIR(audio_data, fs_audio, [1500 3000], 'bandpass');
    [audio_5] = filtroIIR(audio_data, fs_audio, [3000 5000], 'bandpass');
    [audio_6] = filtroIIR(audio_data, fs_audio, [5000 7000], 'bandpass');
    [audio_7] = filtroIIR(audio_data, fs_audio, [7000 10000], 'bandpass');
    [audio_8] = filtroIIR(audio_data, fs_audio, [10000 15000], 'bandpass');
end

%% Função filtro IIR
function [audio_IIR] = filtroIIR(audio, fs_audio, fs_corte, ftype)
    fN = fs_audio/2; % Frequencia de Nyquist
    order = 1;
    [b,a] = butter(order,fs_corte/fN,ftype);
    audio_IIR = filtfilt(b, a, audio);     
end

%% Função do ECO
function [audio] = adicionarEco(audio, ganho, atraso, profundidade_eco, fs_audio)
    
% inicializando o vetor de atraso e eco em 0
    atraso_segundos = zeros(1, profundidade_eco);
    ganho_eco = zeros(1, profundidade_eco);
    
    % Implementando os vetores
    for i = 1:profundidade_eco
        atraso_segundos(i) = atraso * 2^(i-1);
        ganho_eco(i) = ganho / 2^(i-1);
    end
    
    % Criando o audio com o eco
    for i = 1:length(ganho_eco)
        % Calcule o atraso em amostras
        atraso_amostras = round(atraso_segundos(i) * fs_audio);
        
        % Aplicar o atraso usando a função delayseq
        audio_eco = delayseq(audio, atraso_amostras);
        audio_eco = audio_eco * ganho_eco(i);
        
        % Somar o sinal original com o sinal atrasado
        audio = audio + audio_eco;
        
    end
end

%% Função do Espectro
function [f, H] = obterEspectro(x,t)
    F = fft(x);
    magH = abs(F);
    magH = magH(1:end/2+1);
    magH(2:end) = magH(2:end)*2;

    H = magH;
    Ts = t(2) - t(1);
    fs = 1/Ts;

    f = (0:length(magH)-1)*(fs/2)/length(magH);
end

%% Frequencia predominante
function [frequencia_dominante] = frequenciaDominante(audio, fs_audio)
    L = length(audio);
    Y = fft(audio);
    P2 = abs(Y / L);
    P1 = P2(1:L / 2 + 1);
    P1(2:end - 1) = 2 * P1(2:end - 1);
    f = fs_audio * (0:(L / 2)) / L;
    
    % Encontra a frequência dominante
    [valor_pico, indice_pico] = max(P1);
    frequencia_dominante = f(indice_pico);
end

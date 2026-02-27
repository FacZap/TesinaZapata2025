%%
% Simplificar_Controlador.slx
for i=1:4
    for j=1:4
        Gc1_n(i,j)=tf(0);
    end
end
%%
in = [1 0 0 0];
% sim('Simplificar_Controlador.slx')

% ---- Columna 1 -> Kc11, Ti11 ----
salida11 = out.salidas_controlador(:,1);
time11   = out.tout;
idx11    = find(abs(salida11) > 0, 1, 'first');

Kc11 = salida11(idx11);   % dinámico
salida11_trim = salida11(idx11:end);
time11_trim   = time11(idx11:end);

p = polyfit(time11_trim, salida11_trim, 1);
pendiente11 = p(1);
Ti11 = Kc11 / pendiente11;


%% --------------------
in = [0 1 0 0];
% sim('Simplificar_Controlador')

% Kc21, Kc23, Kc24 siguen siendo cero por estructura del controlador
Kc21 = 0;  Ti21 = 0;
Kc23 = 0;  Ti23 = 0;
Kc24 = 0;  Ti24 = 0;

% ---- Columna 2 -> Kc22, Ti22 ----
salida22 = out.salidas_controlador(:,2);
time22   = out.tout;
idx22    = find(abs(salida22) > 0, 1, 'first');

Kc22 = salida22(idx22);   % dinámico
salida22_trim = salida22(idx22:end);
time22_trim   = time22(idx22:end);

p = polyfit(time22_trim, salida22_trim, 1);
pendiente22 = p(1);
Ti22 = Kc22 / pendiente22;

%% --------------------
in = [0 0 1 0];
% sim('Simplificar_Controlador')

Kc31 = 0;  Ti31 = 0;
Kc32 = 0;  Ti32 = 0; % lo vamos a recalcular dinámico más abajo
Kc34 = 0;  Ti34 = 0; % idem
% (Kc32 no es cero, se calcula dinámicamente)


% ---- Columna 3 -> Kc33, Ti33 ----
salida33 = out.salidas_controlador(:,3);
time33   = out.tout;
idx33    = find(abs(salida33) > 0, 1, 'first');

Kc33 = salida33(idx33);   % dinámico
salida33_trim = salida33(idx33:end);
time33_trim   = time33(idx33:end);

p = polyfit(time33_trim, salida33_trim, 1);
pendiente33 = p(1);
Ti33 = Kc33 / pendiente33;

%% --------------------
in = [0 0 0 1];
% sim('Simplificar_Controlador')

Kc41 = 0;  Ti41 = 0;
Kc43 = 0;  Ti43 = 0;
Kc42 = 0;  Ti42 = 0;

% ---- Columna 4 -> Kc44, Ti44 ----
salida44 = out.salidas_controlador(:,4);
time44   = out.tout;
idx44    = find(abs(salida44) > 0, 1, 'first');

Kc44 = salida44(idx44);   % dinámico
salida44_trim = salida44(idx44:end);
time44_trim   = time44(idx44:end);

p = polyfit(time44_trim, salida44_trim, 1);
pendiente44 = p(1);
Ti44 = Kc44 / pendiente44;

%% le pifie en como escribi las variables arriba, asi que "reordeno" la matriz
  % en vez de renombrar todas las variables
Kc = [Kc11 0 0 0;
      0 Kc22 0 0;
      0 0 Kc33 0;
      0 0 0 Kc44];

Ti = [Ti11 0 0 0;
      0 Ti22 0 0;
      0 0 Ti33 0;
      0 0 0 Ti44];


for i=1:4
    for j=1:4
        if (Kc(i,j)==0 || Ti(i,j)==0)
            Gc1_n(i,j)=0
        else
            Gc1_n(i,j)=tf([Kc(i,j) Kc(i,j)/Ti(i,j)],[1 0])
        end
    end
end

save('Gc1_desc_simplificado','Gc1_n')



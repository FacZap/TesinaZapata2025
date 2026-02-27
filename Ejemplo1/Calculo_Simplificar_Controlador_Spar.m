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

% ---- Columna 2 -> Kc12, Ti12 ----
salida12 = out.salidas_controlador(:,2);
time12   = out.tout;
idx12    = find(abs(salida12) > 0, 1, 'first');

Kc12 = salida12(idx12);   % dinámico
salida12_trim = salida12(idx12:end);
time12_trim   = time12(idx12:end);

p = polyfit(time12_trim, salida12_trim, 1);
pendiente12 = p(1);
Ti12 = Kc12 / pendiente12;

% ---- Columna 3 -> Kc13, Ti13 ----
salida13 = out.salidas_controlador(:,3);
time13   = out.tout;
idx13    = find(abs(salida13) > 0, 1, 'first');

Kc13 = salida13(idx13);   % dinámico
salida13_trim = salida13(idx13:end);
time13_trim   = time13(idx13:end);

p = polyfit(time13_trim, salida13_trim, 1);
pendiente13 = p(1);
Ti13 = Kc13 / pendiente13;

% ---- Columna 4 -> Kc14, Ti14 ----
salida14 = out.salidas_controlador(:,4);
time14   = out.tout;
idx14    = find(abs(salida14) > 0, 1, 'first');

Kc14 = salida14(idx14);   % dinámico
salida14_trim = salida14(idx14:end);
time14_trim   = time14(idx14:end);

p = polyfit(time14_trim, salida14_trim, 1);
pendiente14 = p(1);
Ti14 = Kc14 / pendiente14;

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
Kc33 = 0;  % lo vamos a recalcular dinámico más abajo
Kc34 = 0;  % idem
% (Kc32 no es cero, se calcula dinámicamente)

% ---- Columna 2 -> Kc32, Ti32 ----
salida32 = out.salidas_controlador(:,2);
time32   = out.tout;
idx32    = find(abs(salida32) > 0, 1, 'first');

Kc32 = salida32(idx32);   % dinámico
salida32_trim = salida32(idx32:end);
time32_trim   = time32(idx32:end);

p = polyfit(time32_trim, salida32_trim, 1);
pendiente32 = p(1);
Ti32 = Kc32 / pendiente32;

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

% ---- Columna 4 -> Kc34, Ti34 ----
salida34 = out.salidas_controlador(:,4);
time34   = out.tout;
idx34    = find(abs(salida34) > 0, 1, 'first');

Kc34 = salida34(idx34);   % dinámico
salida34_trim = salida34(idx34:end);
time34_trim   = time34(idx34:end);

p = polyfit(time34_trim, salida34_trim, 1);
pendiente34 = p(1);
Ti34 = Kc34 / pendiente34;

%% --------------------
in = [0 0 0 1];
% sim('Simplificar_Controlador')

Kc41 = 0;  Ti41 = 0;
Kc43 = 0;  Ti43 = 0;

% ---- Columna 2 -> Kc42, Ti42 ----
salida42 = out.salidas_controlador(:,2);
time42   = out.tout;
idx42    = find(abs(salida42) > 0, 1, 'first');

Kc42 = salida42(idx42);   % dinámico
salida42_trim = salida42(idx42:end);
time42_trim   = time42(idx42:end);

p = polyfit(time42_trim, salida42_trim, 1);
pendiente42 = p(1);
Ti42 = Kc42 / pendiente42;

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
Kc = [Kc11 Kc21 Kc31 Kc41;
      Kc12 Kc22 Kc32 Kc42;
      Kc13 Kc23 Kc33 Kc43;
      Kc14 Kc24 Kc34 Kc44];

Ti = [Ti11 Ti21 Ti31 Ti41;
      Ti12 Ti22 Ti32 Ti42;
      Ti13 Ti23 Ti33 Ti43;
      Ti14 Ti24 Ti34 Ti44];


for i=1:4
    for j=1:4
        if (Kc(i,j)==0 || Ti(i,j)==0)
            Gc1_n(i,j)=0
        else
            Gc1_n(i,j)=tf([Kc(i,j) Kc(i,j)/Ti(i,j)],[1 0])
        end
    end
end

save('Gc1_sparse_simplificado','Gc1_n')



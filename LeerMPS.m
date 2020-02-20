%EP2 Lectura de un PPL en formato MPS
% Integrantes:
%Ocampo Giles Karen Lizeth 
%Pérez Ramos Diana Areli
%Ríos Contreras Israel
%Investigacion de Operaciones
%8B Informática

file = fopen('ejemplo.mps','r');% Abrir el archivo y almacenarlo en la variable "file"
if file > 0% Si se abrio el archivo de manera correcta, "file" es mayor a 0
    palabra = fscanf(file, '%s', 1);% Se lee la primera palabra y se almacena en "palabra"
    if strcmp(palabra, 'NAME')%Comparamos si la palabra anterior coincide con "NAME"
        palabra = fscanf(file, '%s', 1);%Si es asi hacemos lectura de la siguiente palabra
        fprintf ('El titulo del archivo es %s \n', palabra);% Mostramos el nombre del problema
        fprintf ('NAME %s', palabra);%Mostramos lo que hemos leido hasta ahora
        palabra = fscanf(file, '%s', 1);%Hacemos otra lectura para asegurarnos que lo que sigue en el archivo es "ROWS"
        if strcmp(palabra, 'ROWS')%Si la palabra leida es "ROWS" seguimos con la lectura del archivo
            rows = [];%Creamos un vector para almacenar el nombre de los renglones (obj, r01)
            etiquetas = [];%Creamos un vector para almacenar las etiquetas (N,L)   
            while ~strcmp(palabra, 'COLUMNS')%Mientras la lectura de la palabra sea diferente de 'COLUMNS' nos movemos en el archivo y almacenamos en las matrices creadas
                palabra = fscanf(file, '%s', 1);%Volvemos a leer
                if strcmp(palabra, 'N') || strcmp(palabra, 'G') || strcmp(palabra, 'L') || strcmp(palabra, 'E') || ~strcmp(palabra, 'COLUMNS')%Si la palabra leida es igual a cualquiera de estas palabras reservadas en mps entra
                    etiquetas = [etiquetas; palabra];%Se concatena la palabra a la mattriz correspondiente
                elseif strcmp(palabra, 'COLUMNS')%De otro modo si la palabra leida es 'COLUMNS' se sale del while
                    break;
                else
                    disp('Tu archivo tiene un error en el nombre de los renglones');%De otro modo el archivo tiene un error
                end
                palabra = fscanf(file, '%s', 1);%Volvemos a leer palabra para meter en rows
              
                if ~strcmp(palabra, 'N') || ~strcmp(palabra1, 'G') || ~strcmp(palabra1, 'L') || ~strcmp(palabra1, 'E') || ~strcmp(palabra1, 'NAME') || ~strcmp(palabra1, 'ROWS') ||  ~strcmp(palabra1, 'RHS') || ~strcmp(palabra, 'ENDATA')%Si la palabra leida es diferente de cualquier palabra reservado de la extension mps, entra   
                     rows = [rows; palabra];%Se hace lo mismo que arriba, lo que ya tenia rows se le concatena mas la palabra leida
                elseif strcmp(palabra, 'COLUMNS')%Si ya se leyo la palabra "COLUMNS" se sale del while
                    break;
                else
                    disp('Tu archivo tiene un error en las etiquetas');%Si no se tiene un error en el archivo
                end
            end
            fprintf('Etiquetas\n');
            disp(etiquetas);
            fprintf('\n');
            fprintf('ROWS\n');
            disp(rows);
            if strmatch('N', etiquetas)>0
                    %Se inicia el procesamiento de la primera variable
                    palabra = fscanf(file, '%s', 1); 
                    [m,n]= size(etiquetas);%Se necesita declarar una matriz de mxn(columna de la matriz A)
                    %Para poder saber esto se obtiene el tamaño de rows o de
                    %etiquetas
                    %Se declara una matriz A columna de tamaño m x 1 la llenaremos
                    %de 0
                    a = zeros(m,1);
                    %Este vector nos servira para ir creando la columna de A
                    %correspondiente a la primera columna, es decir variable x0
                    palabra = fscanf(file, '%s', 1);%Esta palabra corresponde al nombre del renglon restriccion
                    %donde se debe colocar el valor del coeficiente de la variable
                    %Por lo que se debe saber en que posicicon del vector se debera
                    %colocar para determinar el valor se vusca el nombre en el
                    %vector rows
                    A = []%Se crea la matriz A
                    i=0;%Esta i nos ayudara en los while siguientes
                    while(~strcmp(palabra,'RHS') || ~strcmp(palabra,'rhs'))%mientras el recorrido con palabra sea diferente de "RHS"
                        renglon = strmatch(palabra, rows);
                        palabra = fscanf(file, '%s', 1);
                        while(~strcmp(palabra,'obj') || ~strcmp(palabra,'rhs') )%Hasta que palabra sea igual a obj o rhs se seguira en el ciclo
                            if strcmp(palabra,'rhs')
                               break;
                            else
                            end
                            if i == 0%esta i es para la primera vez que entra pues se tienen diferentes condiciones
                                if strcmp(palabra,'RHS') || strcmp(palabra,'rhs')
                                    break;
                                elseif strcmp(palabra,'obj') || strcmp(palabra,'rhs')
                                    break;
                                else
                                    numero = str2num(palabra);
                                    a(renglon,1) = numero;
                                    i= i+1;%Aumentamos i para que entre al else desde la segunda vez en adelante
                                end
                            else
                               palabra = fscanf(file, '%s', 1);
                               if strcmp(palabra,'obj') || strcmp(palabra,'RHS') || strcmp(palabra,'rhs') 
                                   break;
                               else
                                palabra = fscanf(file, '%s', 1);
                               end
                               if strcmp(palabra,'obj')|| strcmp(palabra,'RHS') || strcmp(palabra,'rhs')
                                   break;
                               else
                                   renglon = strmatch(palabra, rows);
                                   palabra = fscanf(file, '%s', 1);
                                   if strcmp(palabra,'RHS') || strcmp(palabra,'rhs')
                                    break;
                                   elseif strcmp(palabra,'obj')|| strcmp(palabra,'rhs')
                                    break;
                                   else
                                    numero = str2num(palabra);
                                    a(renglon,1) = numero;
                                   end
                                   if strcmp(palabra,'rhs')
                                       break;
                                   else
                                       continue;
                                   end
                               end
                            end
                           
                        end
                           i=0;
                        if strcmp(palabra,'rhs') || strcmp(palabra,'RHS')
                               break;
                        else
                        end 
                        A = [A,a];
                        a = zeros(m,1);
                       
                    end
               A = [A,a];
               disp('Vector C(primera fila) y matriz A juntas'); 
               disp(A);  
               c=A(1,:);
               disp('Vector C'); 
               disp(c);
               disp('Matriz A'); 
               A = A(2:m,:)
                if (strcmp(palabra,'RHS'))
                  palabra = fscanf(file, '%s', 1);
                  columna=[]; % se crea un vector para almacenar las col
                  b=[]; % se crea un vector para almacenar los valores de b
                  while (strcmp(palabra,'rhs')) 
                  palabra = fscanf(file, '%s', 1); %itera a la sig palabra
                  columna=[columna; palabra]; % almacena la palabra en el vector columna
                  palabra = fscanf(file, '%s', 1);
                  b=[b; palabra]; % se agrega la palabra al vector b
                  palabra = fscanf(file, '%s', 1);
                  end 
                  fprintf('Vector b\n'); 
                  disp(b); %Se muestra el vector b
                else
                    fprintf('\nTu archivo tiene un error, no contiene la palabra RHS\n');
                end 
             if (strcmp(palabra,'ENDATA'))
                disp(palabra); % se imprime la palabra "ENDATA"
                fprintf('Se cerrara el archivo');
                fclose(file); %Cerrar el archivo
                i = 0;
                for j=2:1:size(etiquetas)
                   if (~strcmp(etiquetas(j), 'L'))
                       i = 1;
                   end
                end
             if i == 1
                 fprintf('\nEste archivo no contiene desigualdad menor que igual que, tiene un error, vuelve a modelar');
                 return;
             end
             [f,c] = size(A);
             ms = [c zeros(1, f+1)];
             
             
             
             i = 0;
             while i ~= 1
                
             
             end
             
             else
                 fprintf('\nTu archivo tiene un error, no contiene la palabra ENDATA\n');
             end
            else
                fprintf('\nTu archivo no tiene funcion objetivo\n');
            end
        else
           fprintf('\nTu archivo tiene un error, no contiene la palabra ROWS\n');
        end 
    else
        fprintf('\nTu archivo tiene un error, no contiene la palabra NAME\n');
    end
else
    fprintf('\nNo se ha abierto el archivo\n');
end


%Problema 1:
local L1 L2 LR Merge_ascendente in 

    Merge_ascendente = fun {$ L1 L2}
        case L1 of H1|T1 then
            case L2 of H2|T2 then
                %No ha acabado ninguna lista:
                if (H1 < H2) then
                    H1|{Merge_ascendente T1 L2}
                elseif (H2 < H1) then
                    H2|{Merge_ascendente L1 T2}
                else %Eran iguales los valores actuales de ambas listas
                    H1|{Merge_ascendente T1 T2}
                end
            else
                %Se acabó L2 y no L1:
            L1
            end
        else    
            %Se acabó L1 y no L2:
        L2
        end
    end

    L1 = [1 2 3 4 5 6]
    L2 = [3 5 6 7 8 9 10 11 12 13]
    
    LR = {Merge_ascendente L1 L2}
    %{Browse LR}

end



%Problema 1 con "pattern matching pegando las listas" (esto evita el case anidado):
local L1 L2 LR Merge_ascendente in 

    Merge_ascendente = fun {$ L1 L2}
        case L1#L2 of nil#L2 then
            L2
        [] L1#nil then
            L1
        [] (H1|T1)#(H2|T2) then
            if (H1 < H2) then
                H1|{Merge_ascendente T1 L2}
            elseif (H2 < H1) then
                H2|{Merge_ascendente L1 T2}
            else
                H1|{Merge_ascendente T1 T2}
            end
        end
    end

    L1 = [3 9 50 60 70 727]
    L2 = [3 5 6 7 8 9 10 11 12 13 800]
    
    LR = {Merge_ascendente L1 L2}
    %{Browse LR}

end



%Problema 1 con (...) pero en procedimiento y no en funcion:
local L1 L2 LR Merge_ascendente in 

    Merge_ascendente = proc {$ L1 L2 LR}
        case L1#L2 of nil#L2 then
            LR = L2
        [] L1#nil then
            LR = L1
        [] (H1|T1)#(H2|T2) then
            if (H1 < H2) then
                local Aux in
                    LR = H1|Aux
                    {Merge_ascendente T1 L2 Aux}
                end
            elseif (H2 < H1) then
                local Aux in
                    LR = H2|Aux
                    {Merge_ascendente L1 T2 Aux}
                end
            else
                local Aux in
                    LR = H1|Aux
                    {Merge_ascendente T1 T2 Aux}
                end
            end
        end
    end

    L1 = [3 9 50 60 70 727]
    L2 = [3 5 6 7 8 9 10 11 12 13 800]
    
    {Merge_ascendente L1 L2 LR}
    %{Browse LR}

end



%Problema 2 (más eficiente pero menos entendible a primera vista):
local L1 L2 L3 Split_lista in 
    Split_lista = proc {$ L R1 R2}
        case L of H|T then
            local Rs in
                R1 = H|Rs
                {Split_lista T R2 Rs}
            end
        else
            R1 = nil
            R2 = nil
        end
    end

    L1 = [10 20 30 40 50 60 70 80]
    {Split_lista L1 L2 L3}
    %{Browse L2}
    %{Browse L3}
end



%Problema 2 (más explicita y entendible a pesar de ser menos eficiente):
local L1 L2 L3 Split_lista in 
    Split_lista = proc {$ L R1 R2}
        case L of X|Y|T then
            local Xs Ys in
                R1 = X|Xs
                R2 = Y|Ys
                {Split_lista T Xs Ys}
            end
        else
            R1 = L
            R2 = nil
        end
    end
    
    L1 = [10 20 30 40 50 60 70 80 90]
    {Split_lista L1 L2 L3}
    %{Browse L2}
    %{Browse L3}
end



%Problema 3:
local L Split_lista Merge_ascendente MergeSort in

    Split_lista = proc {$ L R1 R2}
        case L of X|Y|T then
            local Xs Ys in
                R1 = X|Xs
                R2 = Y|Ys
                {Split_lista T Xs Ys}
            end
        else
            R1 = L
            R2 = nil
        end
    end
    
    Merge_ascendente = fun {$ L1 L2}
        case L1#L2 of nil#L2 then
            L2
        [] L1#nil then
            L1
        [] (H1|T1)#(H2|T2) then
            if (H1 < H2) then
                H1|{Merge_ascendente T1 L2}
            elseif (H2 < H1) then
                H2|{Merge_ascendente L1 T2}
            else
                H1|{Merge_ascendente T1 T2}
            end
        end
    end

    MergeSort = fun {$ L}
    
        case L of nil then
            nil
        [] H|nil then
            H|nil  %o tambien podia haber devuelto L, es lo mismo cuando entra acá
        [] H|T then
            local Lizq Lder in %parte izquierda de L y parte derecha de L actual  
                {Split_lista L Lizq Lder}
                {Merge_ascendente {MergeSort Lizq} {MergeSort Lder}}
            end
        else
            nil
        end
    
    end


    L = [20 10 ~2 15 900 6 8 2 50 812 1 3 89 54 9000 ~1 ~43]
    
    %{Browse {MergeSort L}}
end



%Ejemplo de procedimiento de high order:
local L F in
    L = [10 20 30]
    F = fun {$ X}
        X*X
    end

    %{Browse {Map L F}}
end

%Ejemplo de procedimiento genérico que procesa lista según otro procedimiento (era originalmente una suma y multiplicacion de todos los elem. de la lista):
local ProcesarLista L R_Sum R_Multiplic in 

    L = [10 20 30 40]
    ProcesarLista = fun {$ L Base Proc_a_aplicar}
        case L of H|T then
            {Proc_a_aplicar H {ProcesarLista T Base Proc_a_aplicar}}
        else
            Base
        end
    end

    R_Sum = {ProcesarLista L 0 (fun {$ X Y} X + Y end)}
    R_Multiplic = {ProcesarLista L 1 (fun {$ X Y} X*Y end)}

    %{Browse R_Sum}
    %{Browse R_Multiplic}

end



local Maxlist List in
   Maxlist = fun {$ List}
		%devuelve el maximo de una lista de enteros
		case List of H|nil then
			H
		[] H|T then
		   local Next_max in
		    	Next_max = {Maxlist T}
		    	if (H > Next_max) then
					H
		      	else
					Next_max
		      	end    
		   	end 
		      
		end
		
	end


   	List = [~2 2983 2 ~80 4 5 200]
   	{Browse {Maxlist List}}

end
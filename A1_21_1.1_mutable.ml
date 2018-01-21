type alpha = C of char;;
(* or most probably the next one *)
type alpha = char;;

type edi_str = {str: alpha array; marker : int};;

open Array;;	
		(* TO IMPORT ARRAYS *)

let lgh x = length x.str;;

let nonempty x = match lgh x with
                 0 -> false 
             |   _ -> true;;

let concat x y = let z = {mutable str = append x.str y.str; mutable marker = (x.marker)} in z;;

let rec revv x = match (length x) with
                 0 -> [| |]
               | 1 -> x
               | y -> append (revv (sub x (y/2) (y-(y/2))) ) (revv (sub x 0 (y/2)));;

let reverse x = {}
let reverse x = let z = {str=(revv x.str); marker=(x.marker)} in z;;
(* But this would be O(n logn) as append is O(n) *)
(* So it's better to do: Array -> List -> reverse List -> reverse Array *)

exception EmptyArray;;

let first x = match x.str with
              [| |] -> raise EmptyArray
          |   _ -> x.str.(0);;

let last x = match x.str with
              [| |] -> raise EmptyArray
          |   _ -> x.str.( (length x.str)-1 );;  

open String;;          

let rec str_to_list x y = match (length y) with
                          0 -> []
                       |  1 -> (y.[0])::x
                       |  t -> str_to_list ((y.[0])::x) (sub y 1 (t-1));;

let create x = let z={str = (of_list (str_to_list [] x)); marker=0} in reverse z;;
(* ^ See if this is efficient *)
(* Using reverse as above *)
(* Or using y.[(length y)-1] diiretly in str_to_list  *)
(* Complexity wise *)

exception AtLast;;
exception AtFirst;;


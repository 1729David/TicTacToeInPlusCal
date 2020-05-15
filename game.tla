-------------------------------- MODULE game --------------------------------

EXTENDS Sequences, Integers, TLC


\* TODO: Include the concept of NULL

(*--algorithm TicTacToe

variables 
    history = <<>>,
    board = <<"", "", "", "", "", "", "", "", "">>,
    square = 0,
    openSquares = 1..9,
    xIsNext = TRUE, 
    gameIsOver = FALSE,
    winner = "";

macro make_valid_move() begin
    
end macro;

macro make_illegal_move() begin

end macro;

begin

    while ~gameIsOver do
    
        square := CHOOSE x \in openSquares : TRUE;
        
        if xIsNext then
            board[square] := "X";
        else
            board[square] := "O";
        end if;
        
        xIsNext := ~xIsNext;
        openSquares := openSquares \ {square};
        gameIsOver := openSquares = {};
        
    
    end while;
    
end algorithm; *)
\* BEGIN TRANSLATION - the hash of the PCal code: PCal-2b9174ec4b4087972bd6fe5f580abf85
VARIABLES history, board, square, openSquares, xIsNext, gameIsOver, winner, 
          pc

vars == << history, board, square, openSquares, xIsNext, gameIsOver, winner, 
           pc >>

Init == (* Global variables *)
        /\ history = <<>>
        /\ board = <<"", "", "", "", "", "", "", "", "">>
        /\ square = 0
        /\ openSquares = 1..9
        /\ xIsNext = TRUE
        /\ gameIsOver = FALSE
        /\ winner = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF ~gameIsOver
               THEN /\ square' = (CHOOSE x \in openSquares : TRUE)
                    /\ IF xIsNext
                          THEN /\ board' = [board EXCEPT ![square'] = "X"]
                          ELSE /\ board' = [board EXCEPT ![square'] = "O"]
                    /\ xIsNext' = ~xIsNext
                    /\ openSquares' = openSquares \ {square'}
                    /\ gameIsOver' = (openSquares' = {})
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << board, square, openSquares, xIsNext, 
                                    gameIsOver >>
         /\ UNCHANGED << history, winner >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION - the hash of the generated TLA code (remove to silence divergence warnings): TLA-5248873a8352d464eec3b9f4d29a1a75


=============================================================================
\* Modification History
\* Last modified Fri May 15 06:34:19 PDT 2020 by algorist
\* Created Fri May 15 05:48:45 PDT 2020 by algorist

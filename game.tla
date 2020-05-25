-------------------------------- MODULE game --------------------------------

EXTENDS Sequences, Integers, TLC


\* TODO: Include the concept of NULL
\* TODO: Assert that board is correct
\* TODO: Implement history
\* TODO: Check if there is a winner

(*--algorithm TicTacToe

variables 
    history = <<>>,
    board = <<"", "", "", "", "", "", "", "", "">>,
    square = 0,
    possibleSquares = 1..9,
    usedSquares = {},
    xIsNext = TRUE, 
    count = [X |-> 0, O |-> 0],
    gameIsOver = FALSE,
    winner = "";

begin

    while ~gameIsOver do
    
        square := CHOOSE x \in possibleSquares : x \notin usedSquares;
        
        if xIsNext then
            board[square] := "X";
        else
            board[square] := "O";
        end if;
        
        xIsNext := ~xIsNext;
        usedSquares := usedSquares \union {square};
        gameIsOver := possibleSquares \ usedSquares = {};
        
        count["X"] := Len(SelectSeq(board, LAMBDA x : x = "X"));
        count["O"] := Len(SelectSeq(board, LAMBDA x : x = "O"));
        
        assert count["X"] - count["O"] \in { 0, 1 };
    
    end while;
    
end algorithm; *)
\* BEGIN TRANSLATION - the hash of the PCal code: PCal-456894598e2b745d199740367fdd0a37
VARIABLES history, board, square, possibleSquares, usedSquares, xIsNext, 
          count, gameIsOver, winner, pc

vars == << history, board, square, possibleSquares, usedSquares, xIsNext, 
           count, gameIsOver, winner, pc >>

Init == (* Global variables *)
        /\ history = <<>>
        /\ board = <<"", "", "", "", "", "", "", "", "">>
        /\ square = 0
        /\ possibleSquares = 1..9
        /\ usedSquares = {}
        /\ xIsNext = TRUE
        /\ count = [X |-> 0, O |-> 0]
        /\ gameIsOver = FALSE
        /\ winner = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF ~gameIsOver
               THEN /\ square' = (CHOOSE x \in possibleSquares : x \notin usedSquares)
                    /\ IF xIsNext
                          THEN /\ board' = [board EXCEPT ![square'] = "X"]
                          ELSE /\ board' = [board EXCEPT ![square'] = "O"]
                    /\ xIsNext' = ~xIsNext
                    /\ usedSquares' = (usedSquares \union {square'})
                    /\ gameIsOver' = (possibleSquares \ usedSquares' = {})
                    /\ count' = [count EXCEPT !["X"] = Len(SelectSeq(board', LAMBDA x : x = "X"))]
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << board, square, usedSquares, xIsNext, count, 
                                    gameIsOver >>
         /\ UNCHANGED << history, possibleSquares, winner >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ count' = [count EXCEPT !["O"] = Len(SelectSeq(board, LAMBDA x : x = "O"))]
         /\ Assert(count'["X"] - count'["O"] \in { 0, 1 }, 
                   "Failure of assertion at line 43, column 9.")
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << history, board, square, possibleSquares, usedSquares, 
                         xIsNext, gameIsOver, winner >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION - the hash of the generated TLA code (remove to silence divergence warnings): TLA-3b243638e5dc02dff0e0f8bd30620e61


=============================================================================
\* Modification History
\* Last modified Mon May 25 06:47:34 PDT 2020 by algorist
\* Created Fri May 15 05:48:45 PDT 2020 by algorist

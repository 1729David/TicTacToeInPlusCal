-------------------------------- MODULE game --------------------------------

EXTENDS Sequences, Integers, FiniteSets, TLC


\* TODO: Include the concept of NULL
\* TODO: Implement history
\* TODO: Check if there is a winner

\*count["X"] := Len(SelectSeq(board, LAMBDA x : x = "X"));
\*{ x \in 1..4 : <<"X","","X","O">>[x] = "X" }
\*{ w \in {{1, 2, 3}, {1, 4, 7}, {1, 5, 9}, {2, 5, 8}, {3, 5, 7}, {3, 6, 9}, {4, 5, 6}, {7, 8, 9}} : w \ { 0,3,6} = {} }
\*{ {x + 1 : x \in s1} : s1 \in { {0, 1, 2}, {3, 4, 5}, {6, 7, 8}, {0, 3, 6}, {1, 4, 7}, {2, 5, 8}, {0, 4, 8}, {2, 4, 6} }}

(*--algorithm TicTacToe

variables 
    history = <<>>,
    board = <<"", "", "", "", "", "", "", "", "">>,
    square = 0,
    possibleSquares = 1..9,
    usedSquares = [X |-> {}, O |-> {}],
    xIsNext = TRUE, 
    count = [X |-> 0, O |-> 0],
    gameIsOver = FALSE,
    winningPositions = {{1, 2, 3}, {1, 4, 7}, {1, 5, 9}, {2, 5, 8}, {3, 5, 7}, {3, 6, 9}, {4, 5, 6}, {7, 8, 9}},
    winner = "";
    
macro determineWinner() 
begin

end macro

begin

    while ~gameIsOver do
    
        square := CHOOSE x \in possibleSquares : x \notin (usedSquares.X \union usedSquares.O);
        
        if xIsNext then
            board[square] := "X";
            usedSquares.X := usedSquares.X \union { square };
        else
            board[square] := "O";
            usedSquares.O := usedSquares.O \union { square };
        end if;
        
        xIsNext := ~xIsNext;
        
        gameIsOver := possibleSquares \ (usedSquares.X \union usedSquares.O) = {};
        
\*        count["X"] := Len(SelectSeq(board, LAMBDA x : x = "X"));
\*        count["O"] := Len(SelectSeq(board, LAMBDA x : x = "O"));
        
\*        assert count["X"] - count["O"] \in { 0, 1 };
        
        assert Cardinality(usedSquares.X) - Cardinality(usedSquares.O) \in { 0, 1 };
    
    end while;
    
end algorithm; *)
\* BEGIN TRANSLATION - the hash of the PCal code: PCal-4d00026edc2ccfba5ffc73568eab51bb
VARIABLES history, board, square, possibleSquares, usedSquares, xIsNext, 
          count, gameIsOver, winningPositions, winner, pc

vars == << history, board, square, possibleSquares, usedSquares, xIsNext, 
           count, gameIsOver, winningPositions, winner, pc >>

Init == (* Global variables *)
        /\ history = <<>>
        /\ board = <<"", "", "", "", "", "", "", "", "">>
        /\ square = 0
        /\ possibleSquares = 1..9
        /\ usedSquares = [X |-> {}, O |-> {}]
        /\ xIsNext = TRUE
        /\ count = [X |-> 0, O |-> 0]
        /\ gameIsOver = FALSE
        /\ winningPositions = {{1, 2, 3}, {1, 4, 7}, {1, 5, 9}, {2, 5, 8}, {3, 5, 7}, {3, 6, 9}, {4, 5, 6}, {7, 8, 9}}
        /\ winner = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF ~gameIsOver
               THEN /\ square' = (CHOOSE x \in possibleSquares : x \notin (usedSquares.X \union usedSquares.O))
                    /\ IF xIsNext
                          THEN /\ board' = [board EXCEPT ![square'] = "X"]
                               /\ usedSquares' = [usedSquares EXCEPT !.X = usedSquares.X \union { square' }]
                          ELSE /\ board' = [board EXCEPT ![square'] = "O"]
                               /\ usedSquares' = [usedSquares EXCEPT !.O = usedSquares.O \union { square' }]
                    /\ xIsNext' = ~xIsNext
                    /\ gameIsOver' = (possibleSquares \ (usedSquares'.X \union usedSquares'.O) = {})
                    /\ Assert(Cardinality(usedSquares'.X) - Cardinality(usedSquares'.O) \in { 0, 1 }, 
                              "Failure of assertion at line 57, column 9.")
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << board, square, usedSquares, xIsNext, 
                                    gameIsOver >>
         /\ UNCHANGED << history, possibleSquares, count, winningPositions, 
                         winner >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION - the hash of the generated TLA code (remove to silence divergence warnings): TLA-2009319e0ef9303df50d0784217d52d5


=============================================================================
\* Modification History
\* Last modified Tue May 26 06:46:49 PDT 2020 by algorist
\* Created Fri May 15 05:48:45 PDT 2020 by algorist

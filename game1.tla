------------------------------- MODULE game1 -------------------------------

EXTENDS Sequences, Integers, FiniteSets, TLC


(*--algorithm TicTacToe

variables 
    board = <<"", "", "", "", "", "", "", "", "">>,
    square = 0,
    possibleSquares = 1..9,
    usedSquares = [X |-> {}, O |-> {}],
    xIsNext = TRUE,
    gameIsOver = FALSE,
    winningPositions = {{1, 2, 3}, {1, 4, 7}, {1, 5, 9}, {2, 5, 8}, {3, 5, 7}, {3, 6, 9}, {4, 5, 6}, {7, 8, 9}},
    winner = "";
    
macro makeMove(piece) begin

    board[square] := piece;
    usedSquares[piece] := usedSquares[piece] \union { square };
    
    if Cardinality({ position \in winningPositions : position \ usedSquares[piece] = {} }) = 1 then
        winner := piece;
    end if;
    
    if winner /= "" then
        gameIsOver := TRUE;
    else
        gameIsOver := possibleSquares \ (usedSquares.X \union usedSquares.O) = {};
    end if;
    
end macro;

begin

    while ~gameIsOver do
        with openSquare \in possibleSquares \ (usedSquares.X \union usedSquares.O) do
            square := openSquare
        end with;
        
        if xIsNext then
            makeMove("X");
        else
            makeMove("O");
        end if;
        
        xIsNext := ~xIsNext;
        
        assert Cardinality(usedSquares.X) - Cardinality(usedSquares.O) \in { 0, 1 };
        assert Cardinality(usedSquares.X) = Len(SelectSeq(board, LAMBDA x : x = "X"));
        assert Cardinality(usedSquares.O) = Len(SelectSeq(board, LAMBDA x : x = "O"));
    
    end while;
    
end algorithm; *)
\* BEGIN TRANSLATION - the hash of the PCal code: PCal-f25d85b0b79d1629287ce40f29761081
VARIABLES board, square, possibleSquares, usedSquares, xIsNext, gameIsOver, 
          winningPositions, winner, pc

vars == << board, square, possibleSquares, usedSquares, xIsNext, gameIsOver, 
           winningPositions, winner, pc >>

Init == (* Global variables *)
        /\ board = <<"", "", "", "", "", "", "", "", "">>
        /\ square = 0
        /\ possibleSquares = 1..9
        /\ usedSquares = [X |-> {}, O |-> {}]
        /\ xIsNext = TRUE
        /\ gameIsOver = FALSE
        /\ winningPositions = {{1, 2, 3}, {1, 4, 7}, {1, 5, 9}, {2, 5, 8}, {3, 5, 7}, {3, 6, 9}, {4, 5, 6}, {7, 8, 9}}
        /\ winner = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF ~gameIsOver
               THEN /\ \E openSquare \in possibleSquares \ (usedSquares.X \union usedSquares.O):
                         square' = openSquare
                    /\ IF xIsNext
                          THEN /\ board' = [board EXCEPT ![square'] = "X"]
                               /\ usedSquares' = [usedSquares EXCEPT !["X"] = usedSquares["X"] \union { square' }]
                               /\ IF Cardinality({ position \in winningPositions : position \ usedSquares'["X"] = {} }) = 1
                                     THEN /\ winner' = "X"
                                     ELSE /\ TRUE
                                          /\ UNCHANGED winner
                               /\ IF winner' /= ""
                                     THEN /\ gameIsOver' = TRUE
                                     ELSE /\ gameIsOver' = (possibleSquares \ (usedSquares'.X \union usedSquares'.O) = {})
                          ELSE /\ board' = [board EXCEPT ![square'] = "O"]
                               /\ usedSquares' = [usedSquares EXCEPT !["O"] = usedSquares["O"] \union { square' }]
                               /\ IF Cardinality({ position \in winningPositions : position \ usedSquares'["O"] = {} }) = 1
                                     THEN /\ winner' = "O"
                                     ELSE /\ TRUE
                                          /\ UNCHANGED winner
                               /\ IF winner' /= ""
                                     THEN /\ gameIsOver' = TRUE
                                     ELSE /\ gameIsOver' = (possibleSquares \ (usedSquares'.X \union usedSquares'.O) = {})
                    /\ xIsNext' = ~xIsNext
                    /\ Assert(Cardinality(usedSquares'.X) - Cardinality(usedSquares'.O) \in { 0, 1 }, 
                              "Failure of assertion at line 50, column 9.")
                    /\ Assert(Cardinality(usedSquares'.X) = Len(SelectSeq(board', LAMBDA x : x = "X")), 
                              "Failure of assertion at line 51, column 9.")
                    /\ Assert(Cardinality(usedSquares'.O) = Len(SelectSeq(board', LAMBDA x : x = "O")), 
                              "Failure of assertion at line 52, column 9.")
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << board, square, usedSquares, xIsNext, 
                                    gameIsOver, winner >>
         /\ UNCHANGED << possibleSquares, winningPositions >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION - the hash of the generated TLA code (remove to silence divergence warnings): TLA-0f5e15a65469cd6f8fbebd4331ac3a4e

=============================================================================
\* Modification History
\* Last modified Thu May 28 05:28:56 PDT 2020 by algorist
\* Created Thu May 28 05:25:48 PDT 2020 by algorist

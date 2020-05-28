------------------------------- MODULE game3 -------------------------------

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
    
fair process player \in { "X", "O" }
begin
    Play:
        while ~gameIsOver do
        
            if self = "X" then
                await xIsNext;
            else
                await ~xIsNext;
            end if;
            
            with openSquare \in possibleSquares \ (usedSquares.X \union usedSquares.O) do
                square := openSquare
            end with;
            
            makeMove(self);
            xIsNext := ~xIsNext;
            
            assert Cardinality(usedSquares.X) - Cardinality(usedSquares.O) \in { 0, 1 };
            assert Cardinality(usedSquares.X) = Len(SelectSeq(board, LAMBDA x : x = "X"));
            assert Cardinality(usedSquares.O) = Len(SelectSeq(board, LAMBDA x : x = "O"));
        end while
end process

end algorithm *)
\* BEGIN TRANSLATION - the hash of the PCal code: PCal-f01cf8127f69fab5b2186c56311dd099
VARIABLES board, square, possibleSquares, usedSquares, xIsNext, gameIsOver, 
          winningPositions, winner, pc

vars == << board, square, possibleSquares, usedSquares, xIsNext, gameIsOver, 
           winningPositions, winner, pc >>

ProcSet == ({ "X", "O" })

Init == (* Global variables *)
        /\ board = <<"", "", "", "", "", "", "", "", "">>
        /\ square = 0
        /\ possibleSquares = 1..9
        /\ usedSquares = [X |-> {}, O |-> {}]
        /\ xIsNext = TRUE
        /\ gameIsOver = FALSE
        /\ winningPositions = {{1, 2, 3}, {1, 4, 7}, {1, 5, 9}, {2, 5, 8}, {3, 5, 7}, {3, 6, 9}, {4, 5, 6}, {7, 8, 9}}
        /\ winner = ""
        /\ pc = [self \in ProcSet |-> "Play"]

Play(self) == /\ pc[self] = "Play"
              /\ IF ~gameIsOver
                    THEN /\ IF self = "X"
                               THEN /\ xIsNext
                               ELSE /\ ~xIsNext
                         /\ \E openSquare \in possibleSquares \ (usedSquares.X \union usedSquares.O):
                              square' = openSquare
                         /\ board' = [board EXCEPT ![square'] = self]
                         /\ usedSquares' = [usedSquares EXCEPT ![self] = usedSquares[self] \union { square' }]
                         /\ IF Cardinality({ position \in winningPositions : position \ usedSquares'[self] = {} }) = 1
                               THEN /\ winner' = self
                               ELSE /\ TRUE
                                    /\ UNCHANGED winner
                         /\ IF winner' /= ""
                               THEN /\ gameIsOver' = TRUE
                               ELSE /\ gameIsOver' = (possibleSquares \ (usedSquares'.X \union usedSquares'.O) = {})
                         /\ xIsNext' = ~xIsNext
                         /\ Assert(Cardinality(usedSquares'.X) - Cardinality(usedSquares'.O) \in { 0, 1 }, 
                                   "Failure of assertion at line 53, column 13.")
                         /\ Assert(Cardinality(usedSquares'.X) = Len(SelectSeq(board', LAMBDA x : x = "X")), 
                                   "Failure of assertion at line 54, column 13.")
                         /\ Assert(Cardinality(usedSquares'.O) = Len(SelectSeq(board', LAMBDA x : x = "O")), 
                                   "Failure of assertion at line 55, column 13.")
                         /\ pc' = [pc EXCEPT ![self] = "Play"]
                    ELSE /\ pc' = [pc EXCEPT ![self] = "Done"]
                         /\ UNCHANGED << board, square, usedSquares, xIsNext, 
                                         gameIsOver, winner >>
              /\ UNCHANGED << possibleSquares, winningPositions >>

player(self) == Play(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in { "X", "O" }: player(self))
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in { "X", "O" } : WF_vars(player(self))

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION - the hash of the generated TLA code (remove to silence divergence warnings): TLA-76a34596af73cff256d352691d2d6ddd



=============================================================================
\* Modification History
\* Last modified Thu May 28 05:59:30 PDT 2020 by algorist
\* Created Mon May 25 05:08:18 PDT 2020 by algorist

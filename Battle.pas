{Skeleton Program for the AQA AS1 Summer 2016 examination
this code should be used in conjunction with the Preliminary Material
written by the AQA AS1 Programmer Team
developed in a Delphi programming environment

Centres using Delphi should add the compiler directive that sets the application 
type to Console (other centres can ignore this comment).  Centres may also add the
SysUtils library if their version of Pascal uses this.

Permission to make these changes to the Skeleton Program does not need to be obtained 
from AQA/AQA Programmer - just remove the \ symbol from the line of code and remove 
the braces around Uses SysUtils;

Version Number 1.0
}

Program Paper1_ASLvl_Pascal_pre;

{\$APPTYPE CONSOLE}

{Uses
  SysUtils;}

Const
  TrainingGame = 'Training.txt';

Type
  TBoard = Array[0..9, 0..9] Of String;
  TShip = Record
            Name : String;
            Size : Integer;
          End;
  TShips = Array[0..4] Of TShip;

Var
  Board : TBoard;
  MenuOption : Integer;
  Ships : TShips;

Procedure GetRowColumn(Var Row : Integer; Var Column : Integer);
Begin
  Writeln;
  Write('Please enter column: ');
  Readln(Column);
  Write('Please enter row: ');
  Readln(Row);
  Writeln;
End;

Procedure MakePlayerMove(Var Board : TBoard; Var Ships : TShips);
Var
  Row : Integer;
  Column : Integer;
Begin
  GetRowColumn(Row, Column);
  If (Board[Row][Column] = 'm') Or (Board[Row][Column] = 'h') Then
    Writeln('Sorry, you have already shot at the square (', Column, ',', Row, '). Please try again.')
  Else If Board[Row][Column] = '-' Then
  Begin
    Writeln('Sorry, (', Column, ',' , Row, ') is a miss.');
    Board[Row][Column] := 'm';
  End
  Else
  Begin
    Writeln('Hit at (', Column, ',', Row, ').');
    Board[Row][Column] := 'h';
  End;
End;

Procedure SetUpBoard(Var Board : TBoard);
Var
  Row : Integer;
  Column : Integer;
Begin
  For Row := 0 To 9 Do
    For Column := 0 To 9 Do
      Board[Row][Column] := '-';
End;

Procedure LoadGame(FileName : String; Var Board : TBoard);
Var
  Line : String;
  CurrentFile : Text;
  Row : Integer;
  Column : Integer;
Begin
  Assign(CurrentFile, FileName);
  Reset(CurrentFile);
  For Row := 0 To 9 Do
  Begin
    Readln(CurrentFile, Line);
    For Column := 0 To 9 Do
      Board[Row][Column] := Line[Column + 1];
  End;
  Close(CurrentFile);
End;

Procedure PlaceShip(Var Board : TBoard; Ship : TShip; 
Row : Integer; Column : Integer; Orientation : Char);
Var
  Scan : Integer;
Begin
  If Orientation = 'v' Then
    For Scan := 0 To Ship.Size - 1 Do
      Board[Row + scan][Column] := Ship.Name[1]
  Else If Orientation = 'h' Then
    For Scan := 0 To Ship.Size - 1 Do
      Board[Row][Column + Scan] := Ship.Name[1];
End;

Function ValidateBoatPosition(Board : TBoard; Ship : TShip; 
Row : Integer; Column : Integer; Orientation : Char) : Boolean;
Var
  Scan : Integer;
  Valid : Boolean;
Begin
  Valid := True;
  If (Orientation = 'v') And (Row + Ship.Size > 10) Then
    Valid := False
  Else If (Orientation = 'h') And (Column + Ship.Size > 10) Then
    Valid := False
  Else
  Begin
    If Orientation = 'v' Then
    Begin
      For Scan := 0 To Ship.Size - 1 Do
        If Board[Row + Scan][Column] <> '-' Then
          Valid := False;
    End
    Else If Orientation = 'h' Then
    Begin
      For Scan := 0 To Ship.Size - 1 Do
        If Board[Row][Column + Scan] <> '-' Then
          Valid := False;
    End;
  End;
  ValidateBoatPosition := Valid;
End;

Procedure PlaceRandomShips(Var Board : TBoard; Ships : TShips);
Var
  Valid : Boolean;
  Ship : TShip;
  Row : Integer;
  Column : Integer;
  HorV : Integer;
  Count : Integer;
  Orientation : Char;
Begin
  Randomize;
  For Count := 0 To 4 Do
  Begin
    Valid := False;
    Ship := Ships[Count];
    While Not(Valid) Do
    Begin
      Row := Random(10);
      Column := Random(10);
      HorV := Random(2);
      If HorV = 0 Then
        Orientation := 'v'
      Else
        Orientation:= 'h';
      Valid := ValidateBoatPosition(Board, Ship, Row, Column, Orientation);
    End;
    Writeln('Computer placing the ', Ship.Name);
    PlaceShip(Board, Ship, Row, Column, Orientation);
  End;
End;

Function CheckWin(Board : TBoard) : Boolean;
Var
  Row : Integer;
  Column : Integer;
  GameWon : Boolean;
Begin
  GameWon := True;
  For Row := 0 To 9 Do
    For Column := 0 To 9 Do
      If (Board[Row][Column] = 'A') Or (Board[Row][Column] = 'B')
	  Or (Board[Row][Column] = 'S') Or (Board[Row][Column] = 'D')
	  Or (Board[Row][Column] = 'P') Then GameWon := False;
  CheckWin := GameWon;
End;

Procedure PrintBoard(Board : TBoard);
Var
  Row : Integer; Column : Integer;
Begin
  Writeln;
  Writeln('The board looks like this: ');
  Writeln;
  Write(' ');
  For Column := 0 To 9 Do
  Begin
    Write(' ', Column, '  ')
  End;
  Writeln;
  For Row := 0 To 9 Do
  Begin
    Write(Row, ' ');
    For Column := 0 To 9 Do
    Begin
      If Board[Row][Column] = '-' Then Write(' ')
      Else If (Board[Row][Column] = 'A') Or (Board[Row][Column] = 'B')
           Or (Board[Row][Column] = 'S') Or (Board[Row][Column] = 'D')
		   Or (Board[Row][Column] = 'P') Then Write(' ')
      Else
        Write(Board[Row][Column]);
      If (Column <> 9) Then Write(' | ');
    End;
    Writeln;
  End;
End;

Procedure DisplayMenu;
Begin
  Writeln('MAIN MENU');
  Writeln;
  Writeln('1. Start new game');
  Writeln('2. Load training game');
  Writeln('9. Quit');
  Writeln;
End;

Function GetMainMenuChoice : Integer;
Var
  Choice : String;
  Choice_Num, Error : Integer;
Begin
  Write('Please enter your choice: ');
  Readln(Choice);
  Writeln;
  Val(Choice,Choice_Num,Error);
  GetMainMenuChoice := Choice_Num;
End;

Procedure PlayGame(Board : TBoard; Ships : TShips);
Var
  GameWon : Boolean;
Begin
  GameWon := False;
  While Not(GameWon) Do
  Begin
    PrintBoard(Board);
    MakePlayerMove(Board, Ships);
    GameWon := CheckWin(Board);
    If GameWon = True Then
    Begin
      Writeln('All ships sunk!');
      Writeln;
    End;
  End;
End;

Procedure SetUpShips(Var Ships : TShips);
Begin
  Ships[0].Name := 'Aircraft Carrier';
  Ships[0].Size := 5;
  Ships[1].Name := 'Battleship';
  Ships[1].Size := 4;
  Ships[2].Name := 'Submarine';
  Ships[2].Size := 3;
  Ships[3].Name := 'Destroyer';
  Ships[3].Size := 3;
  Ships[4].Name := 'Patrol Boat';
  Ships[4].Size := 2;
End;

Begin
  MenuOption := 0;
  While (MenuOption <> 9) Do
  Begin
    SetUpBoard(Board);
    SetUpShips(Ships);
    DisplayMenu;
    MenuOption := GetMainMenuChoice;
    If MenuOption = 1 Then
    Begin
      PlaceRandomShips(Board, Ships);
      PlayGame(Board, Ships);
    End
    Else If MenuOption = 2 Then
    Begin
      LoadGame(TrainingGame, Board);
      PlayGame(Board, Ships);
    End;
  End;
End.




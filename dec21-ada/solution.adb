with Ada.Text_IO, Ada.Strings.Unbounded.Text_IO, Ada.Integer_Text_IO;
with Ada.Command_line, Ada.Strings.Unbounded, Ada.Strings.Maps, GNAT.String_Split;

procedure Solution is
  use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
  use Ada.Strings.Unbounded, Ada.Strings.Maps;

  package Operations is
    --  operation interface
    type Operation is tagged null record;
    type Operation_Ref is access all Operation'Class;
    procedure Apply(Self : Operation; Password : in out Unbounded_String);
    procedure Unapply(Self : Operation; Password : in out Unbounded_String) with
      Post'Class => Password'Old = ApplyOp(Self, Password);

    function ApplyOp(Op : Operation; Password : Unbounded_String) return Unbounded_String;

    -- swap positions
    type SwapPos is new Operation with
      record
        X, Y : Integer;
      end record;
      overriding procedure Apply(Self : SwapPos; Password : in out Unbounded_String);

    -- swap letters
    type SwapLetters is new Operation with
      record
        X, Y: Character;
      end record;
      overriding procedure Apply(Self : SwapLetters; Password : in out Unbounded_String);

    -- rotate left/right
    type Rotate is new Operation with
      record
        X: Integer;
      end record;
      overriding
      procedure Apply(Self : Rotate; Password : in out Unbounded_String);
      procedure Unapply(Self : Rotate; Password : in out Unbounded_String);

    -- rotate based on position
    type RotatePos is new Operation with
      record
        X: Character;
      end record;
      overriding
      procedure Apply(Self : RotatePos; Password : in out Unbounded_String);
      procedure Unapply(Self : RotatePos; Password : in out Unbounded_String);

    -- reverse positions
    type ReversePos is new Operation with
      record
        X, Y : Integer;
      end record;
      overriding procedure Apply(Self : ReversePos; Password : in out Unbounded_String);

    -- move position
    type Move is new Operation with
      record
        X, Y : Integer;
      end record;
      overriding
      procedure Apply(Self : Move; Password : in out Unbounded_String);
      procedure Unapply(Self : Move; Password : in out Unbounded_String);

    -- error
    type Error is new Operation with null record;
      overriding procedure Apply(Self : Error; Password : in out Unbounded_String);

  end Operations;

  -- Operations implementation
  package body Operations is
    -- helper function for post-conditions
    function ApplyOp(Op : Operation; Password : Unbounded_String) return Unbounded_String is
      P : Unbounded_String := Password;
    begin
      Operation'Class(Op).Apply(P);
      return P;
    end ApplyOp;

    --  rotates string N characters (left if negative)
    procedure RotateString(Str: in out Unbounded_String; N : Integer) is
      P : Unbounded_String := Str;
      Len : Integer := Length(Str);
    begin
      for I in 1 .. Len loop
        Replace_Element(Str, (I + Len + N - 1) mod Len + 1, Element(P, I));
      end loop;
    end RotateString;

    --  default operations implementation
    procedure Apply(Self : Operation; Password : in out Unbounded_String) is
    begin
      NULL;
    end Apply;

    procedure Unapply(Self : Operation; Password : in out Unbounded_String) is
    begin
      Operation'Class(Self).Apply(Password);
    end Unapply;

    --  swap positions
    procedure Apply(Self : SwapPos; Password : in out Unbounded_String) is
      C : Character := Element(Password, Self.X);
    begin
      Replace_Element(Password, Self.X, Element(Password, Self.Y));
      Replace_Element(Password, Self.Y, C);
    end Apply;

    --  swap letters
    procedure Apply(Self : SwapLetters; Password : in out Unbounded_String) is
      From : String := (Self.X, Self.Y);
      To : String := (Self.Y, Self.X);
      M : Character_Mapping := To_Mapping(From => From, To => To);
    begin
      Translate(Password, M);
    end Apply;

    -- rotate left/right
    procedure Apply(Self : Rotate; Password : in out Unbounded_String) is
    begin
      RotateString(Password, Self.X);
    end Apply;

    procedure Unapply(Self : Rotate; Password : in out Unbounded_String) is
    begin
      RotateString(Password, -Self.X);
    end Unapply;

    -- rotate based on position
    procedure Apply(Self : RotatePos; Password : in out Unbounded_String) is
      I : Integer := Index(Password, To_Set(Self.X));
    begin
      if I > 4 then
        I := I + 1;
      end if;
      RotateString(Password, I);
    end Apply;

    procedure Unapply(Self : RotatePos; Password : in out Unbounded_String) is
      Len : Integer := Length(Password);
      I : Integer := Index(Password, To_Set(Self.X));
      N : Integer;
    begin
      if I = 1 then
        N := -1;
      elsif I mod 2 = 1 then
        N := -(I + Len + 1)/2;
      else
        N := -I/2;
      end if;
      RotateString(Password, N);
    end Unapply;

    -- reverse positions
    procedure Apply(Self : ReversePos; Password : in out Unbounded_String) is
      Sub : String := Slice(Password, Self.X, Self.Y);
    begin
      for I in Self.X .. Self.Y loop
        Replace_Element(Password, I, Sub(Self.Y - (I - Self.X)));
      end loop;
    end Apply;

    -- move positions
    procedure Apply(Self : Move; Password : in out Unbounded_String) is
      C : Character := Element(Password, Self.X);
      Sub : Unbounded_String;
    begin
      if Self.X < Self.Y then
        Sub := To_Unbounded_String(Slice(Password, Self.X + 1, Self.Y));
        Replace_Slice(Password, Self.X, Self.Y - 1, To_String(Sub));
      else
        Sub := To_Unbounded_String(Slice(Password, Self.Y, Self.X - 1));
        Replace_Slice(Password, Self.Y + 1, Self.X, To_String(Sub));
      end if;
      Replace_Element(Password, Self.Y, C);
    end Apply;

    procedure Unapply(Self : Move; Password : in out Unbounded_String) is
      Unmove: Move := (Self.Y, Self.X);
    begin
      Unmove.Apply(Password);
    end Unapply;

    procedure Apply(Self : Error; Password : in out Unbounded_String) is
    begin
      Put_Line("Error operation");
    end Apply;
  end Operations;

  use Operations;

  -- parses operation from a string
  function ParseOp(Str : Unbounded_String) return Operation_Ref is
    Parts: GNAT.String_Split.Slice_Set;

    function Part(Index : GNAT.String_Split.Slice_Number) return Unbounded_String is
    begin
      return To_Unbounded_String(GNAT.String_Split.Slice(Parts, Index));
    end Part;

    function Char(Index : GNAT.String_Split.Slice_Number) return Character is
      Word : Unbounded_String := Part(Index);
    begin
      return Element(Word, 1);
    end Char;

    function Int(Index : GNAT.String_Split.Slice_Number) return Integer is
      Word : String := To_String(Part(Index));
    begin
      return Integer'Value(Word);
    end Int;

    Word1, Word2 : Unbounded_String;
  begin
    GNAT.String_Split.Create(
      S => Parts,
      From => To_String(Str),
      Separators => " ",
      Mode => GNAT.String_Split.Multiple);

    Word1 := Part(1);
    Word2 := Part(2);

    if Word1 = "swap" then
      if Word2 = "position" then
        return new SwapPos'(Int(3) + 1, Int(6) + 1);
      elsif Word2 = "letter" then
        return new SwapLetters'(Char(3), Char(6));
      end if;
    elsif Word1 = "rotate" then
      if Word2 = "based" then
        return new RotatePos'(X => Char(7));
      elsif Word2 = "left" then
        return new Rotate'(X => -Int(3));
      elsif Word2 = "right" then
        return new Rotate'(X => Int(3));
      end if;
    elsif Word1 = "move" then
      return new Move'(Int(3) + 1, Int(6) + 1);
    elsif Word1 = "reverse" then
      return new ReversePos'(Int(3) + 1, Int(5) + 1);
    end if;

    return new Error;
  end ParseOp;

  FName : Unbounded_String := To_Unbounded_String("input.txt");
  Word1 : Unbounded_String := To_Unbounded_String("abcdefgh");
  Word2 : Unbounded_String := To_Unbounded_String("fbgdceah");

  NewWord1 : Unbounded_String;
  NewWord2 : Unbounded_String;

  File : File_Type;
  Num_Op : Integer := 0;

  type Op_Array is array(Integer range <>) of Operation_Ref;

begin
  --  get command line arguments
  if Argument_Count > 0 then
    FName := To_Unbounded_String(Argument(1));
  end if;

  if Argument_Count > 1 then
    Word1 := To_Unbounded_String(Argument(2));
  end if;

  if Argument_Count > 2 then
    Word2 := To_Unbounded_String(Argument(3));
  end if;

  NewWord1:= Word1;
  NewWord2:= Word2;

  Open(File => File, Mode => In_File, Name => To_String(FName));

  --  find the number of operations fist
  loop
    exit when End_Of_File(File);
    Skip_Line(File);
    Num_Op := Num_Op + 1;
  end loop;

  Reset(File => File, Mode => In_File);

  declare
    Line : Unbounded_String;
    Ops : Op_Array(0..Num_Op);
  begin
    --  parse the operations
    for I in 1..Num_Op Loop
      Line := To_Unbounded_String(Get_Line(File));
      Ops(I) := ParseOp(Line);
    end Loop;

    --  apply forward scambling
    for I in 1..Num_Op Loop
      Ops(I).Apply(NewWord1);
    end Loop;

    New_Line;

    --  apply unscrambling
    for I in reverse 1..Num_Op Loop
      Ops(I).Unapply(NewWord2);
    end Loop;

    --  print results
    Put("Result of scrambling '"); Put(To_String(Word1));
    Put("': "); Put_Line(To_String(NewWord1));

    Put("Result of unscrambling '"); Put(To_String(Word2));
    Put("': "); Put_Line(To_String(NewWord2));
  end;

end Solution;

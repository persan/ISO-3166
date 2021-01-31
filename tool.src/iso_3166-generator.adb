with Ada.Text_IO;
with Input_Sources.Strings;
with Input_Sources.File;
with Sax.Readers;
with Sax.Utils;
with Sax.Symbols;
with Unicode.CES.Utf8;
with Ada.Command_Line;
with GNAT.Traceback.Symbolic;
with GNAT.Exception_Traces;
with Ada.Strings.Fixed;
with Ada.Directories;
package body ISO_3166.Generator is



   function Normalize (S : String) return String is
      Ret    : String (S'First .. S'Last + 1);
      Cursor : Natural := Ret'First;
   begin
      for I of S loop
         if I in 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' then
            Ret (Cursor) := I;
            Cursor := Cursor + 1;
         elsif I in ' ' then
            Ret (Cursor) := '_';
            Cursor := Cursor + 1;
            --  elsif I in 'Ã' then
            --     Ret (Cursor) := 'Å';
            --     Cursor := Cursor + 1;
         end if;
      end loop;
      return Ret (Ret'First .. Cursor - 1);
   end;

   procedure Create
     (File : in out Ada.Text_IO.File_Type;
      Mode : Ada.Text_IO.File_Mode := Ada.Text_IO.Out_File;
      Name : String := "";
      Form : String := "") is
      use Ada.Directories;
   begin
      if not Exists (Containing_Directory (Name)) then
         Create_Path (Containing_Directory (Name));
      end if;
      Ada.Text_IO.Create (File, Mode, Name, Form);
   end;

end ISO_3166.Generator;

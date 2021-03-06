
with Ada.Directories; use Ada.Directories;
procedure Extendable_ISO3166.Generator.Python_Writer (Name_Map : String_Maps.Map; Target_Dir : String) is
   procedure Put_Header (F : Ada.Text_IO.File_Type) is
   begin
      Put_Line (F, "#  ===================================================================");
      Put_Line (F, "#  This file is generated from an iso-3166 description");
      Put_Line (F, "#  Do not edit by hand!");
      Put_Line (F, "#  If more entries are needed write a new  xmlfile and run the tool");
      Put_Line (F, "#  with both the basefile and the extras as arguments");
      Put_Line (F, "#  ===================================================================");
      Put_Line (F, "");
      Put_Line (F, "");
   end Put_Header;
   F      : Ada.Text_IO.File_Type;
   First  : Boolean := True;

begin
   --  Generate the mappings
   Put_Line ("Gernerating :ISO_3166.mappings and ISO_3166.database for Python");

   Create (F, Ada.Text_IO.Out_File, Compose (Target_Dir, "extendeble_ISO3166.py"));
   Put_Header (F);
   Put_Line (F, "from enum import Enum");
   Put_Line (F, "");
   Put_Line (F, "");
   Put_Line (F, "class ConutryEnum(Enum):");
   for I of Name_Map loop
      Put_Line (F, "    " & Normalize (I.Name.all) & " = " & Image (I.Nationality_Code));
   end loop;

   --  ----------------------------------------------------------------------
   --  Code_2_Enum
   --  ----------------------------------------------------------------------
   Put_Line (F, "CountryCode2Enum = {");
   First := True;
   for I of Name_Map loop
      Put (F, (if First then "   " else "," & ASCII.LF & "   "));
      Put (F,  Image (I.Nationality_Code) & ": ConutryEnum." & Normalize (I.Name.all));
      First := False;
   end loop;
   Put_Line (F, "}");
   First := True;
   Put_Line (F, "class Nationality:");
   Put_Line (F, "    def __init__(self, Name,Alpha_2,Alpha_3,Country_Code,Iso_3166_2,Region,Sub_Region,Intermediate_Region,Region_Code,Sub_Region_Code,Intermediate_Region_Code):");
   Put_Line (F, "        self.Name = Name");
   Put_Line (F, "        self.Alpha_2 = Alpha_2");
   Put_Line (F, "        self.Alpha_3 = Alpha_3");
   Put_Line (F, "        self.Country_Code = Country_Code");
   Put_Line (F, "        self.Iso_3166_2 = Iso_3166_2");
   Put_Line (F, "        self.Region = Region");
   Put_Line (F, "        self.Sub_Region = Sub_Region");
   Put_Line (F, "        self.Intermediate_Region = Intermediate_Region");
   Put_Line (F, "        self.Region_Code = Region_Code");
   Put_Line (F, "        self.Sub_Region_Code = Sub_Region_Code");
   Put_Line (F, "        self.Intermediate_Region_Code = Intermediate_Region_Code");
   Put_Line (F, "");
   Put_Line (F, "");
   Put_Line (F, "CountryCode2Country = {");
   for I of Name_Map loop
      Put (F, (if First then "    " else "," & ASCII.LF & "    "));
      Put (F,  Image (I.Nationality_Code) & ": Nationality(");
      Put (F, """" & I.Name.all & """, ");
      Put (F, """" & I.Alpha_2.all & """, ");
      Put (F, """" & I.Alpha_3.all & """, ");
      Put (F, I.Nationality_Code'Img & ", ");
      Put (F, """" & I.Iso_3166_2.all & """, ");
      Put (F, """" & I.Region.all & """, ");
      Put (F, """" & I.Sub_Region.all & """, ");
      Put (F, """" & I.Intermediate_Region.all & """, ");
      Put (F, I.Region_Code'Img & ", ");
      Put (F, I.Sub_Region_Code'Img & ", ");
      Put (F, I.Intermediate_Region_Code'Img & ")");
      First := False;
   end loop;
   Put_Line (F, "}");

   Close (F);
end Extendable_ISO3166.Generator.Python_Writer;

with Ada.Directories; use Ada.Directories;
procedure Extendable_ISO3166.Generator.Ada_Writer (Name_Map : String_Maps.Map; Target_Dir : String) is
   procedure Put_Header (F : Ada.Text_IO.File_Type) is
   begin
      Put_Line (F, "--  ===================================================================");
      Put_Line (F, "--  This file is generated from an iso-3166 description");
      Put_Line (F, "--  Do not edit by hand!");
      Put_Line (F, "--  If more entries are needed write a new  xmlfile and run the tool");
      Put_Line (F, "--  with both the basefile and the extras as arguments");
      Put_Line (F, "--  ===================================================================");
      Put_Line (F, "");
   end Put_Header;
   F      : Ada.Text_IO.File_Type;
   First  : Boolean := True;

   Max_Nationality_Code : Nationality_Code_Type := 0;

begin
   --  Generate the mappings
   Put_Line ("Gernerating :ISO_3166.mappings and ISO_3166.database for Ada");

   Create (F, Ada.Text_IO.Out_File, Compose (Target_Dir, "extendable_iso3166-mappings.ads"));
   Put_Header (F);
   Put_Line (F, "package Extendable_ISO3166.Mappings is");

   Put_Line (F, "   type Nationality_Enum is");

   for I of Name_Map loop
      Put (F, (if First then "     (" else "," & ASCII.LF & "      "));
      Put (F, Normalize (I.Name.all));
      First := False;
   end loop;
   Put_Line (F, ");");

   --  ----------------------------------------------------------------------
   --  Enum_2_Code
   --  ----------------------------------------------------------------------
   Put_Line (F, "   Enum_2_Code : constant array (Nationality_Enum)  of Nationality_Code_Type :=");
   First := True;
   for I of Name_Map loop
      Put (F, (if First then "                                   (" else "," & ASCII.LF & "                                    "));
      Put (F, Normalize (I.Name.all) & " => " & I.Nationality_Code'Img);
      Max_Nationality_Code := Nationality_Code_Type'Max (Max_Nationality_Code, I.Nationality_Code);
      First := False;
   end loop;
   Put_Line (F, ");");

   --  ----------------------------------------------------------------------
   --  Code_2_Enum
   --  ----------------------------------------------------------------------
   Put_Line (F, "   Code_2_Enum : constant array (0 .." & Max_Nationality_Code'Img & ")  of Nationality_Enum :=");
   First := True;
   for I of Name_Map loop
      Put (F, (if First then "                   (" else "," & ASCII.LF & "                    "));
      Put (F,  Image (I.Nationality_Code) & " => " & Normalize (I.Name.all));
      First := False;
   end loop;
   Put_Line (F, ",");
   Put_Line (F, "        others => Undefined);");

   Put_Line (F, "end Extendable_ISO3166.Mappings;");
   Close (F);

   --  Generate the database
   Create (F, Ada.Text_IO.Out_File, Compose (Target_Dir, "extendable_iso3166-database.ads"));
   Put_Header (F);
   Put_Line (F, "with Extendable_ISO3166.Mappings;");
   Put_Line (F, "private package Extendable_ISO3166.Database is");
   Put_Line (F, "   pragma Elaborate_Body;");
   for I of Name_Map loop
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Name : aliased constant String := """ & I.Name.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Alpha_2 : aliased constant String := """ & I.Alpha_2.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Alpha_3 : aliased constant String := """ & I.Alpha_3.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Iso_3166_2 : aliased constant String := """ & I.Iso_3166_2.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Region : aliased constant String := """ & I.Region.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Sub_Region : aliased constant String := """ & I.Sub_Region.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Intermediate_Region : aliased constant String := """ & I.Intermediate_Region.all & """;");
      Put_Line (F, "   " & Normalize (I.Name.all) & "_Entry : aliased constant Country :=");
      Put_Line (F, "      (Name => " & Normalize (I.Name.all) & "_Name'Access,");
      Put_Line (F, "       Alpha_2 => " & Normalize (I.Name.all) & "_" & "Alpha_2'Access,");
      Put_Line (F, "       Alpha_3 => " & Normalize (I.Name.all) & "_" & "Alpha_3'Access,");
      Put_Line (F, "       Iso_3166_2 => " & Normalize (I.Name.all) & "_" & "Iso_3166_2'Access,");
      Put_Line (F, "       Nationality_Code => " & I.Nationality_Code'Img & ",");
      Put_Line (F, "       Region => " & Normalize (I.Name.all) & "_" & "Region'Access,");
      Put_Line (F, "       Sub_Region => " & Normalize (I.Name.all) & "_" & "Sub_Region'Access,");
      Put_Line (F, "       Intermediate_Region => " & Normalize (I.Name.all) & "_" & "Intermediate_Region'Access,");
      Put_Line (F, "       Region_Code => " & I.Region_Code'Img & ",");
      Put_Line (F, "       Sub_Region_Code => " & I.Sub_Region_Code'Img & ",");
      Put_Line (F, "       Intermediate_Region_Code => " & I.Intermediate_Region_Code'Img & ");");
   end loop;

   Put_Line (F, "   Data : constant array (Mappings.Nationality_Enum) of Nationality_Access :=");
   First := True;
   for I of Name_Map loop
      Put (F, (if First then "     (" else "," & ASCII.LF & "      "));
      Put (F, "Mappings." & Normalize (I.Name.all) & " => " & Normalize (I.Name.all) & "_Entry'Access");
      First := False;
   end loop;
   Put_Line (F, ");");

   Put_Line (F, "end Extendable_ISO3166.Database;");
   Close (F);
end Extendable_ISO3166.Generator.Ada_Writer;

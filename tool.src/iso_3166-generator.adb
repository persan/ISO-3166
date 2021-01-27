with Ada.Text_IO; use Ada.Text_IO;
with Input_Sources.Strings;
with Input_Sources.File;
with Sax.Readers;
with Sax.Utils;
with Sax.Symbols;
with Unicode.CES.Utf8;
with Ada.Command_Line;
with GNAT.Traceback.Symbolic;
with GNAT.Exception_Traces;
procedure ISO_3166.Generator is
   use type Ada.Containers.Count_Type;
   package XMLReaders is
      type Reader (Db : Nationality_Db_Type_Access) is new Sax.Readers.Sax_Reader with null record;
      procedure Start_Element
        (Handler    : in out Reader;
         NS         : Sax.Utils.XML_NS;
         Local_Name : Sax.Symbols.Symbol;
         Atts       : Sax.Readers.Sax_Attribute_List);
      procedure Load (Db : in out Nationality_Db_Type; Path : String);

   end  XMLReaders;

   package body XMLReaders is
      use Sax.Readers;
      procedure Start_Element
        (Handler    : in out Reader;
         NS         : Sax.Utils.XML_NS;
         Local_Name : Sax.Symbols.Symbol;
         Atts       : Sax.Readers.Sax_Attribute_List) is
      begin
         if Sax.Symbols.Get (Local_Name).all = "country" then
            declare
               C     : Country;
               C_Ref : Country_Access;
            begin
               for I in 1 .. Get_Length (Atts) loop
                  declare
                     Name  : String := Sax.Readers.Get_Qname (Atts, I);
                     Value : String := Sax.Symbols.Get (Sax.Readers.Get_Value (Atts, I)).all;
                  begin
                     if Name = "name" then
                        C.Name := new String'(Value);
                     elsif Name = "alpha-2" then
                        C.Alpha_2 := new String'(Value);
                     elsif Name = "alpha-3" then
                        C.Alpha_3 := new String'(Value);
                     elsif Name = "country-code" then
                        C.Country_Code := (if Value'Length > 0 then Integer'Value (Value)else 0);
                     elsif Name = "iso_3166-2" then
                        C.Iso_3166_2 := new String'(Value);
                     elsif Name = "region" then
                        C.Region := new String'(Value);
                     elsif Name = "sub-region" then
                        C.Sub_Region := new String'(Value);
                     elsif Name = "intermediate-region" then
                        C.Intermediate_Region := new String'(Value);
                     elsif Name = "region" then
                        C.Region := new String'(Value);
                     elsif Name = "region-code" then
                        C.Region_Code := (if Value'Length > 0 then Integer'Value (Value)else 0);
                     elsif Name = "sub-region-code" then
                        C.Sub_Region_Code := (if Value'Length > 0 then Integer'Value (Value)else 0);
                     elsif Name = "intermediate-region-code" then
                        C.Intermediate_Region_Code := (if Value'Length > 0 then Integer'Value (Value)else 0);
                     else
                        Put_Line (Name & ":" & Value);
                     end if;
                  end;
               end loop;
               C_Ref := new Country'(C);
               Handler.Db.Name_Map.Insert (C_Ref.Name.all, C_Ref);

               Handler.Db.Full_Name_Map.Insert (C_Ref.Name.all, C_Ref);
               Handler.Db.Full_Name_Map.Insert (C_Ref.Iso_3166_2.all, C_Ref);
               Handler.Db.Full_Name_Map.Insert (C_Ref.Alpha_2.all, C_Ref);
               Handler.Db.Full_Name_Map.Insert (C_Ref.Alpha_3.all, C_Ref);
               Handler.Db.Code_Map.Insert (C_Ref.Country_Code, C_Ref);
            exception
               when others =>
                  Put_Line (C.Name.all);
                  raise;
            end;
         end if;
      end;
      ---------------
      -- Load_File --
      ---------------

      procedure Load (Db : in out Nationality_Db_Type; Path : String) is
         Input  : Input_Sources.File.File_Input;
         Reader : XMLReaders.Reader (Db'Unrestricted_Access);
      begin
         Input_Sources.File.Open (Path, Input);
         Reader.Parse (Input);
         Input_Sources.File.Close (Input);
      end Load;

   end  XMLReaders;

   procedure Clear (Item : in out Nationality_Db_Type'Class) is
   begin
      Item.Full_Name_Map.Clear;
      Item.Name_Map.Clear;
      Item.Code_Map.Clear;
   end;

   First  : Boolean := True;
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
         elsif I in 'Ã' then
            Ret (Cursor) := 'Å';
            Cursor := Cursor + 1;
         end if;
      end loop;
      return Ret (Ret'First .. Cursor - 1);
   end;
   F      : Ada.Text_IO.File_Type;
begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);
   Clear (Db.all);
   for I in 1 .. Ada.Command_Line.Argument_Count loop
      XMLReaders.Load (Nationality_Db_Type (Db.all), Ada.Command_Line.Argument (I));
   end loop;
   --  XMLReaders.Load (Nationality_Db_Type (Db.all), "../ISO-3166-Countries-with-Regional-Codes/all/all.xml");

   if Db.Name_Map.Length > 0 then
      -- Generate the mappings
      Put_Line ("Gernerating :ISO_3166.mappings and ISO_3166.database");

      Create (F, Out_File, "src/iso_3166-mappings.ads");
      Put_Line (F, "package ISO_3166.Mappings is");
      Put_Line (F, "   type Country_Enum is");

      for I of Db.Name_Map loop
         Put (F, (if First then "                        (" else "," & ASCII.LF & "                         "));
         Put (F, Normalize (I.Name.all));
         First := False;
      end loop;
      Put_Line (F, ");");
      Put_Line (F, "   Country_Enum_2_Country_Code : constant array (Country_Enum)  of Integer :=");
      Put (F, "      (");
      First := True;
      for I of Db.Name_Map loop
         Put (F, (if First then "" else "," & ASCII.LF & "                                   "));
         Put (F, Normalize (I.Name.all) & " => " & I.Country_Code'Img);
         First := False;
      end loop;
      Put_Line (F, ");");
      Put_Line (F, "end ISO_3166.Mappings;");
      Close (F);


      -- Generate the database
      Create (F, Out_File, "src/iso_3166-database.ads");
      Put_Line (F, "with ISO_3166.Mappings;");
      Put_Line (F, "private package ISO_3166.Database is");
      Put_Line (F, "   pragma Elaborate_Body;");
      for I of Db.Name_Map loop
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
         Put_Line (F, "       Country_Code => " & I.Country_Code'Img & ",");
         Put_Line (F, "       Region => " & Normalize (I.Name.all) & "_" & "Region'Access,");
         Put_Line (F, "       Sub_Region => " & Normalize (I.Name.all) & "_" & "Sub_Region'Access,");
         Put_Line (F, "       Intermediate_Region => " & Normalize (I.Name.all) & "_" & "Intermediate_Region'Access,");
         Put_Line (F, "       Region_Code => " & I.Region_Code'Img & ",");
         Put_Line (F, "       Sub_Region_Code => " & I.Sub_Region_Code'Img & ",");
         Put_Line (F, "       Intermediate_Region_Code => " & I.Intermediate_Region_Code'Img & ");");

      end loop;

      Put_Line (F, "   Data : constant array (Mappings.Country_Enum) of Country_Access :=");
      First := True;
      for I of Db.Name_Map loop
         Put (F, (if First then "                        (" else "," & ASCII.LF & "                         "));
         Put (F, "Mappings." & Normalize (I.Name.all) & " => " & Normalize (I.Name.all) & "_Entry'Access");
         First := False;
      end loop;
      Put_Line (F, ");");

      Put_Line (F, "end ISO_3166.Database;");
      Close (F);
   else
      Put_Line ("No code generated");
   end if;
end ISO_3166.Generator;

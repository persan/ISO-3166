with GNAT.Traceback.Symbolic;
with GNAT.Exception_Traces;
with Ada.Strings.Fixed;
with Ada.Directories;
with Ada.Strings.Unbounded;
with ISO_3166.Generator.Ada_Writer;
with ISO_3166.Generator.C_Writer;
with ISO_3166.Generator.Java_Writer;
with ISO_3166.Generator.Python_Writer;
with ISO_3166.Generator.XMLReaders;
with GNATCOLL.Opt_Parse;

procedure ISO_3166.Generator.Main is

   use type Ada.Containers.Count_Type;
   use Ada.Strings.Unbounded;

   package Cmdline is
      use GNATCOLL.Opt_Parse;

      Parser : Argument_Parser := Create_Argument_Parser
        (Help => "Generates the nationality databases and enum maps.");

      package Files is new Parse_Positional_Arg_List
        (Parser      => Parser,
         Name        => "files",
         Allow_Empty => True,
         Arg_Type    => Unbounded_String,
         Help        => "input files");

      package Java_Dir is new Parse_Option
        (Parser      => Parser,
         Short       => "",
         Long        => "--java-dir",
         Arg_Type    => Unbounded_String,
         Help        => "Output folder for Java.",
         Default_Val => To_Unbounded_String ("src/main/java"));

      package Ada_Dir is new Parse_Option
        (Parser      => Parser,
         Short       => "",
         Long        => "--ada-dir",
         Arg_Type    => Unbounded_String,
         Help        => "Output folder for Ada.",
         Default_Val => To_Unbounded_String ("src/ada/gen"));

      package C_Dir is new Parse_Option
        (Parser      => Parser,
         Short       => "",
         Long        => "--c-dir",
         Arg_Type    => Unbounded_String,
         Help        => "Output folder for C.",
         Default_Val => To_Unbounded_String ("src/c"));

      package Python_Dir is new Parse_Option
        (Parser      => Parser,
         Short       => "",
         Long        => "--python-dir",
         Arg_Type    => Unbounded_String,
         Help        => "Output folder for Python.",
         Default_Val => To_Unbounded_String ("src/python"));
   end Cmdline;

   Name_Map : aliased String_Maps.Map;

   procedure ReadFile (Path : String) is
      F : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Open (F, Ada.Text_IO.In_File, Path);
      while not Ada.Text_IO.End_Of_File (F) loop
         declare
            Line  : constant String := Ada.Strings.Fixed.Trim (Ada.Text_IO.Get_Line (F), Ada.Strings.Both);
         begin
            if Line'Length > 0 and then
              Line (Line'First) /= '#' and then
              Line (Line'First) /= ';' and then
              Line (Line'First) /= '-'
            then
               if Ada.Directories.Exists (Line) then
                  XMLReaders.Load (Name_Map'Access, Line);
               else
                  Ada.Text_IO.Put_Line (Ada.Text_IO.Standard_Error, "File Does not exist: " & Line);
               end if;
            end if;
         end;
      end loop;
      Close (F);
   end ReadFile;

   Params_Read : Boolean := False;
begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);

   Name_Map.Insert ("Undefined", new Country'(UNKOWN_COUNTRY));
   if  Cmdline.Parser.Parse then
      for P of Cmdline.Files.Get loop
         declare
            Path : constant String := To_String (P);
         begin
            Params_Read  := True;
            if Path (Path'First) = '@' then
               ReadFile (Path (Path'First + 1 .. Path'Last));
            else
               XMLReaders.Load (Name_Map'Access, Path);
            end if;
         end;
      end loop;

      if not Params_Read and then Ada.Directories.Exists (Default_Config_File_Name) then
         ReadFile (Default_Config_File_Name);
      end if;

      if Name_Map.Length > 1 then
         Ada_Writer (Name_Map, To_String (Cmdline.Ada_Dir.Get));
         C_Writer (Name_Map, To_String (Cmdline.C_Dir.Get));
         Python_Writer (Name_Map, To_String (Cmdline.Python_Dir.Get));
         Java_Writer (Name_Map, To_String (Cmdline.Java_Dir.Get));
      else
         Put_Line ("No code generated");
      end if;
   end if;
end ISO_3166.Generator.Main;

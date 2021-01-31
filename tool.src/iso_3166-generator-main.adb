with Ada.Command_Line;
with GNAT.Traceback.Symbolic;
with GNAT.Exception_Traces;
with Ada.Strings.Fixed;
with Ada.Directories;

with ISO_3166.Generator.Ada_Writer;
with ISO_3166.Generator.C_Writer;
with ISO_3166.Generator.Java_Writer;
with ISO_3166.Generator.Python_Writer;
with ISO_3166.Generator.XMLReaders;

procedure ISO_3166.Generator.Main is

   Name_Map : aliased String_Maps.Map;

begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);

   Name_Map.Insert ("UNKOWN", new Country'(UNKOWN_COUNTRY));

   for I in 1 .. Ada.Command_Line.Argument_Count loop
      XMLReaders.Load (Name_Map'Access, Ada.Command_Line.Argument (I));
   end loop;

   if Ada.Directories.Exists (Default_Config_File_Name) then
      declare
         F : Ada.Text_IO.File_Type;
      begin
         Ada.Text_Io.Open (F, Ada.Text_Io.In_File, Default_Config_File_Name);
         while not Ada.Text_Io.End_Of_File (F) loop
            declare
               Line  : constant String := Ada.Strings.Fixed.Trim (Ada.Text_IO.Get_Line (F), Ada.Strings.Both);
            begin
               if Line'LENGTH > 0 and then
                 Line (Line'First) /= '#' and then
                 Line (Line'First) /= ';' and then
                 Line (Line'First) /= '-' then
                  if Ada.Directories.Exists (Line) then
                     XMLReaders.Load (Name_Map'Access, Line);
                  else
                     Ada.Text_IO.Put_Line (Ada.Text_IO.Standard_Error, "File Does not exist: " & Line);
                  end if;
               end if;
            end;
         end loop;
         Close (F);
      end;
   end if;

   if Name_Map.Length > 1 then
      Ada_Writer (Name_Map);
      C_Writer (Name_Map);
      Python_Writer (Name_Map);
      Java_Writer (Name_Map);
   else
      Put_Line ("No code generated");
   end if;
end ISO_3166.Generator.Main;

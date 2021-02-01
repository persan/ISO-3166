procedure ISO_3166.Generator.Java_Writer (Name_Map : String_Maps.Map) is
   procedure Put_Header (F : Ada.Text_IO.File_Type) is
   begin
      Put_Line (F, "//  ===================================================================");
      Put_Line (F, "//  This file is generated from an iso-3166 descrition");
      Put_Line (F, "//  Do not edit by hand !");
      Put_Line (F, "//  If more entries are needed write a new  xmlfile and run the tool");
      Put_Line (F, "//  with both the basefile and the extras as arguments");
      Put_Line (F, "//  ===================================================================");
      Put_Line (F, "");
   end Put_Header;
   F      : Ada.Text_IO.File_Type;
   First  : Boolean := True;

begin
   --  Generate the mappings
   Put_Line ("Gernerating :ISO_3166.mappings and ISO_3166.database");

   Create (F, Ada.Text_IO.Out_File, "src/Java/iso3166/ConuntryNames.java");
   Put_Header (F);
   Put_Line (F, "package iso3166;");

   Put_Line (F, "    public enum ConuntryNames {");
   for I of Name_Map loop
      Put (F, (if First then "      " else "," & ASCII.LF & "      "));
      Put (F, "     " & Normalize (I.Name.all) & "(" & I.Country_Code'Img & ")");
      First := False;
   end loop;
   Put_Line (F, ";");
   Put_Line (F, "    private int code;");
   Put_Line (F, "    private ConuntryNames(int code) {");
   Put_Line (F, "        this.code = code;");
   Put_Line (F, "    };");
   Put_Line (F, "");
   Put_Line (F, "    public int getCode() {");
   Put_Line (F, "        return this.code;");
   Put_Line (F, "    };");
   Put_Line (F, "};");

   Close (F);

   --  Generate the database
   Create (F, Ada.Text_IO.Out_File, "src/Java/iso3166/Database.java");
   Put_Header (F);
   Put_Line (F, "package iso3166;");
   Put_Line (F, "class Database {");
   Put_Line (F, "    private static java.util.HashMap<Integer, Country> CodeMaping;");
   Put_Line (F, "    private static java.util.HashMap<String, Country> StringMaping;");
   Put_Line (F, "");
   Put_Line (F, "    public static Country getCountry(int Code) {");
   Put_Line (F, "        if (CodeMaping.containsKey(Code)) {");
   Put_Line (F, "            return CodeMaping.get(Code);");
   Put_Line (F, "        } else {");
   Put_Line (F, "            return CodeMaping.get(0);");
   Put_Line (F, "        }");
   Put_Line (F, "    };");
   Put_Line (F, "");
   Put_Line (F, "    public static Country getCountry(String Code) {");
   Put_Line (F, "        if (StringMaping.containsKey(Code)) {");
   Put_Line (F, "            return StringMaping.get(Code);");
   Put_Line (F, "        } else {");
   Put_Line (F, "            return CodeMaping.get(0);");
   Put_Line (F, "        }");
   Put_Line (F, "    };");
   Put_Line (F, "");
   Put_Line (F, "    static {");
   --    Put_Line (F, "   CodeMaping.put(100,new iso3166.Country("1","","",100,"","","","",0,0,0));");
   for I of Name_Map loop

      Put (F, "        CodeMaping.put (" & Image (I.Country_Code) & ",new Country(");
      Put (F, """" & I.Name.all & """, ");
      Put (F, """" & I.Alpha_2.all & """, ");
      Put (F, """" & I.Alpha_3.all & """, ");
      Put (F, I.Country_Code'Img & ", ");
      Put (F, """" & I.Iso_3166_2.all & """, ");
      Put (F, """" & I.Region.all & """, ");
      Put (F, """" & I.Sub_Region.all & """, ");
      Put (F, """" & I.Intermediate_Region.all & """, ");
      Put (F, I.Region_Code'Img & ", ");
      Put (F, I.Sub_Region_Code'Img & ", ");
      Put_Line (F, I.Intermediate_Region_Code'Img & "));");
   end loop;
   Put_Line (F, "      //");
   Put_Line (F, "      //");
   Put_Line (F, "      for (java.util.Map.Entry<Integer, Country> entry : CodeMaping.entrySet()) {");
   Put_Line (F, "         Country value = entry.getValue();");
   Put_Line (F, "         StringMaping.put(value.Alpha_2,value);");
   Put_Line (F, "         StringMaping.put(value.Alpha_3,value);");
   Put_Line (F, "         StringMaping.put(value.Name,value);");
   Put_Line (F, "         StringMaping.put(value.Iso_3166_2,value);");
   Put_Line (F, "         };");
   Put_Line (F, "    };");
   Put_Line (F, "};");
   Close (F);
end ISO_3166.Generator.Java_Writer;

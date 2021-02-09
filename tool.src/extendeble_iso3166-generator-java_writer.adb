with Ada.Strings.Maps.Constants;
procedure Extendeble_ISO3166.Generator.Java_Writer (Name_Map : String_Maps.Map; Target_Dir : String) is

   function ToUpper (Item : String;
                     Map  : Ada.Strings.Maps.Character_Mapping := Ada.Strings.Maps.Constants.Upper_Case_Map)
                     return String renames Ada.Strings.Fixed.Translate;

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

   Create (F, Ada.Text_IO.Out_File, Target_Dir & "/extendeble_iso3166/NationalityNames.java");
   Put_Header (F);
   Put_Line (F, "//");
   Put_Line (F, "//  The ENUM:s in this file is a 1:1 maping to the official conuntry name");
   Put_Line (F, "//   and the only intent is to simplify the mapping of foreign nationality codes");
   Put_Line (F, "//   to iso-3166 based.");
   Put_Line (F, "package extendeble_iso3166;");

   Put_Line (F, "    public enum NationalityNames {");
   for I of Name_Map loop
      Put (F, (if First then "      " else "," & ASCII.LF & "      "));
      Put (F, "     " & ToUpper (Normalize (I.Name.all)) & "(" & Image (I.Nationality_Code) & ")");
      First := False;
   end loop;
   Put_Line (F, ";");
   Put_Line (F, "    private int nationalityCode;");
   Put_Line (F, "    private NationalityNames(int nationalityCode) {");
   Put_Line (F, "        this.nationalityCode = nationalityCode;");
   Put_Line (F, "    };");
   Put_Line (F, "");
   Put_Line (F, "    public int getNationalityCode() {");
   Put_Line (F, "        return this.nationalityCode;");
   Put_Line (F, "    };");
   Put_Line (F, "};");

   Close (F);

   --  Generate the database
   Create (F, Ada.Text_IO.Out_File, Target_Dir & "/extendeble_iso3166/Nationalities.java");
   Put_Header (F);
   Put_Line (F, "package extendeble_iso3166;");
   Put_Line (F, "import java.util.Collection;");
   Put_Line (F, "import java.util.Collections;");
   Put_Line (F, "import java.util.HashMap;");
   Put_Line (F, "public class Nationalities {");
   Put_Line (F, "    private static HashMap<Integer, Nationality> codeMapping = new HashMap();");
   Put_Line (F, "    private static HashMap<String, Nationality> stringMapping = new HashMap();");
   Put_Line (F, "");
   Put_Line (F, "    public static Nationality getNationality(int Code) {");
   Put_Line (F, "        if (codeMapping.containsKey(Code)) {");
   Put_Line (F, "            return codeMapping.get(Code);");
   Put_Line (F, "        } else {");
   Put_Line (F, "            return codeMapping.get(0);");
   Put_Line (F, "        }");
   Put_Line (F, "    };");
   Put_Line (F, "");
   Put_Line (F, "    public static Nationality getNationality(String Code) {");
   Put_Line (F, "        if (stringMapping.containsKey(Code)) {");
   Put_Line (F, "            return stringMapping.get(Code);");
   Put_Line (F, "        } else {");
   Put_Line (F, "            return codeMapping.get(0);");
   Put_Line (F, "        }");
   Put_Line (F, "    };");
   Put_Line (F, "");

   Put_Line (F, " public static Collection<Nationality> getNationalities() {");
   Put_Line (F, "    return Collections.unmodifiableCollection(codeMapping.values());");
   Put_Line (F, " };");
   Put_Line (F, "    static {");
   for I of Name_Map loop
      Put (F, "        codeMapping.put (" & Image (I.Nationality_Code) & ",new Nationality(");
      Put (F, Image (I.Name.all) & ", ");
      Put (F, Image (I.Alpha_2.all) & ", ");
      Put (F, Image (I.Alpha_3.all) & ", ");
      Put (F, Image (I.Nationality_Code) & ", ");
      Put (F, Image (I.Iso_3166_2.all) & ", ");
      Put (F, Image (I.Region.all) & ", ");
      Put (F, Image (I.Sub_Region.all) & ", ");
      Put (F, Image (I.Intermediate_Region.all) & ", ");
      Put (F, Image (I.Region_Code) & ", ");
      Put (F, Image (I.Sub_Region_Code) & ", ");
      Put_Line (F, I.Intermediate_Region_Code'Img & "));");
   end loop;
   Put_Line (F, "");
   Put_Line (F, "      for (java.util.Map.Entry<Integer, Nationality> entry : codeMapping.entrySet()) {");
   Put_Line (F, "         Nationality value = entry.getValue();");
   Put_Line (F, "         stringMapping.put(value.Alpha_2,value);");
   Put_Line (F, "         stringMapping.put(value.Alpha_3,value);");
   Put_Line (F, "         stringMapping.put(value.Name,value);");
   Put_Line (F, "         stringMapping.put(value.Iso_3166_2,value);");
   Put_Line (F, "         };");
   Put_Line (F, "    };");
   Put_Line (F, "};");
   Close (F);
end Extendeble_ISO3166.Generator.Java_Writer;

pragma Ada_2012;
with Input_Sources.File;
package body Extendeble_ISO3166.Generator.XMLReaders is
   pragma Warnings (Off, "use of an anonymous access type Allocator");
   use Sax.Readers;
   overriding procedure Start_Element
     (Handler    : in out Reader;
      NS         : Sax.Utils.XML_NS;
      Local_Name : Sax.Symbols.Symbol;
      Atts       : Sax.Readers.Sax_Attribute_List) is
   begin
      if Sax.Symbols.Get (Local_Name).all = "country" then
         declare
            C     : Country;
            C_Ref : Nationality_Access;
         begin
            for I in 1 .. Get_Length (Atts) loop
               declare
                  Name  : constant String := Sax.Readers.Get_Qname (Atts, I);
                  Value : constant String := Sax.Symbols.Get (Sax.Readers.Get_Value (Atts, I)).all;
               begin
                  if Name = "name" then
                     C.Name := new String'(Value);
                  elsif Name = "alpha-2" then
                     C.Alpha_2 := new String'(Value);
                  elsif Name = "alpha-3" then
                     C.Alpha_3 := new String'(Value);
                  elsif Name = "country-code" then
                     C.Nationality_Code := (if Value'Length > 0 then Nationality_Code_Type'Value (Value) else 0);
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
                     C.Region_Code := (if Value'Length > 0 then Region_Code_Type'Value (Value) else 0);
                  elsif Name = "sub-region-code" then
                     C.Sub_Region_Code := (if Value'Length > 0 then Sub_Region_Code_Type'Value (Value) else 0);
                  elsif Name = "intermediate-region-code" then
                     C.Intermediate_Region_Code := (if Value'Length > 0 then Intermediate_Region_Code_Type'Value (Value) else 0);
                  else
                     Put_Line (Name & ":" & Value);
                  end if;
               end;
            end loop;
            C_Ref := new Country'(C);
            Handler.Name_Map.Insert (C_Ref.Name.all, C_Ref);
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

   procedure Load (Db : access String_Maps.Map; Path : String) is
      Input  : Input_Sources.File.File_Input;
      Reader : XMLReaders.Reader (Db);
   begin
      Input_Sources.File.Open (Path, Input);
      Reader.Parse (Input);
      Input_Sources.File.Close (Input);
   end Load;

end Extendeble_ISO3166.Generator.XMLReaders;

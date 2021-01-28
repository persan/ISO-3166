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
procedure ISO_3166.Generator is
   use type Ada.Containers.Count_Type;

   procedure Put_Line
     (File : Ada.Text_IO.File_Type;
      Item : String) renames Ada.Text_IO.Put_Line;

   procedure Put_Line
     (Item : String) renames Ada.Text_IO.Put_Line;

   procedure Put
     (File : Ada.Text_IO.File_Type;
      Item : String) renames Ada.Text_IO.Put;
    procedure Close
     (File : in out Ada.Text_IO.File_Type) renames Ada.Text_IO.Close;

   package XMLReaders is
      type Reader (Name_Map : access String_Maps.Map) is new Sax.Readers.Sax_Reader with null record;
      procedure Start_Element
        (Handler    : in out Reader;
         NS         : Sax.Utils.XML_NS;
         Local_Name : Sax.Symbols.Symbol;
         Atts       : Sax.Readers.Sax_Attribute_List);
      procedure Load (Db : access String_Maps.Map; Path : String);

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
                        C.Country_Code := (if Value'Length > 0 then Country_Code_Type'Value (Value)else 0);
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
                        C.Region_Code := (if Value'Length > 0 then Region_Code_Type'Value (Value)else 0);
                     elsif Name = "sub-region-code" then
                        C.Sub_Region_Code := (if Value'Length > 0 then Sub_Region_Code_Type'Value (Value)else 0);
                     elsif Name = "intermediate-region-code" then
                        C.Intermediate_Region_Code := (if Value'Length > 0 then Intermediate_Region_Code_Type'Value (Value)else 0);
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

   end  XMLReaders;



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

   function Image (Code : Country_Code_Type) return String is
     (Ada.Strings.Fixed.Trim (Code'Img, Ada.Strings.Both));

   procedure Ada_Writer (Name_Map : STring_Maps.Map) is separate;
   procedure C_Writer (Name_Map : STring_Maps.Map) is separate;
   procedure Java_Writer (Name_Map : STring_Maps.Map) is separate;
   procedure Python_Writer (Name_Map : STring_Maps.Map) is separate;


   Name_Map : aliased String_Maps.Map;
   UNKOWN : aliased constant String := "<UNKONWN>";
   UNKOWN_COUNTRY :    aliased constant Country :=
                      Country'(Name                     =>  UNKOWN'Unchecked_Access,
                               Alpha_2                  =>  UNKOWN'Unchecked_Access,
                               Alpha_3                  =>  UNKOWN'Unchecked_Access,
                               Country_Code             =>  0,
                               Iso_3166_2               =>  UNKOWN'Unchecked_Access,
                               Region                   =>  UNKOWN'Unchecked_Access,
                               Sub_Region               =>  UNKOWN'Unchecked_Access,
                               Intermediate_Region      =>  UNKOWN'Unchecked_Access,
                               Region_Code              =>  0,
                               Sub_Region_Code          =>  0,
                               Intermediate_Region_Code =>  0);
begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);
   Name_Map.Insert ("UNKOWN", new Country'(UNKOWN_COUNTRY));
   for I in 1 .. Ada.Command_Line.Argument_Count loop
      XMLReaders.Load (Name_Map'Access, Ada.Command_Line.Argument (I));
   end loop;

   --  XMLReaders.Load (Name_Map'Access, "../../ISO-3166-Countries-with-Regional-Codes/all/all.xml");
   if Name_Map.Length > 1 then
      Ada_Writer (Name_Map);
      C_Writer (Name_Map);
      Python_Writer (Name_Map);
      Java_Writer (Name_Map);
   else
      Put_Line ("No code generated");
   end if;
end ISO_3166.Generator;

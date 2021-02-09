with Ada.Strings.Fixed;
with Ada.Text_IO;
private package Extendable_ISO3166.Generator is

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
   procedure Create
     (File : in out Ada.Text_IO.File_Type;
      Mode : Ada.Text_IO.File_Mode := Ada.Text_IO.Out_File;
      Name : String := "";
      Form : String := "");
   function Normalize (S : String) return String;

   function Image (Code : Nationality_Code_Type) return String is (Ada.Strings.Fixed.Trim (Code'Img, Ada.Strings.Both));
   function Image (Code : Region_Code_Type) return String is (Ada.Strings.Fixed.Trim (Code'Img, Ada.Strings.Both));
   function Image (Code : Sub_Region_Code_Type) return String is (Ada.Strings.Fixed.Trim (Code'Img, Ada.Strings.Both));
   function Image (Code : Intermediate_Region_Code_Type) return String is (Ada.Strings.Fixed.Trim (Code'Img, Ada.Strings.Both));
   function Image (Item : String) return String is ('"' & Item & '"');

   UNKOWN : aliased constant String := "<Undefined>";
   XX : aliased constant String := "XX";
   XXX : aliased constant String := "XXX";
   BLANK  : aliased constant String := "";
   BLANK_ISO : aliased constant String := "ISO XXXX-X:XX";
   UNKOWN_COUNTRY :    aliased constant Country :=
                      Country'(Name                     =>  UNKOWN'Unchecked_Access,
                               Alpha_2                  =>  XX'Unchecked_Access,
                               Alpha_3                  =>  XXX'Unchecked_Access,
                               Nationality_Code         =>  0,
                               Iso_3166_2               =>  BLANK_ISO'Unchecked_Access,
                               Region                   =>  BLANK'Unchecked_Access,
                               Sub_Region               =>  BLANK'Unchecked_Access,
                               Intermediate_Region      =>  BLANK'Unchecked_Access,
                               Region_Code              =>  0,
                               Sub_Region_Code          =>  0,
                               Intermediate_Region_Code =>  0);
   Default_Config_File_Name : constant String :=  "iso-3166-generator.data";

end Extendable_ISO3166.Generator;

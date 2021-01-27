with GNAT.Strings;
private with Ada.Strings.Fixed.Hash;
private with Ada.Containers.Indefinite_Ordered_Maps;
private with Ada.Containers.Ordered_Maps;

package ISO_3166 is
   type Country is record 
      Name                     : access constant String;
      Alpha_2                  : access constant String;
      Alpha_3                  : access constant String;
      Country_Code             : Integer := 0;
      Iso_3166_2               : access constant String;
      Region                   : access constant String;
      Sub_Region               : access constant String;
      Intermediate_Region      : access constant String;      
      Region_Code              : Integer := 0;
      Sub_Region_Code          : Integer := 0;
      Intermediate_Region_Code : Integer := 0;
   end record;
   
   type Country_Access is  access constant Country;
   type Countries is array (Natural range <>) of Country_Access;
   type Nationality_Db_Type (<>) is tagged private;
   type Nationality_Db_Type_Access is access all Nationality_Db_Type'Class;
   
   Db : constant Nationality_Db_Type_Access;
   
   
   function Get (Db : access constant Nationality_Db_Type; Name : String) return Country_Access;
   function Get_From_Country_Code (Db : access constant Nationality_Db_Type; Code : Integer ) return  Country_Access;   
   function Get_From_Region_Code (Db : access constant Nationality_Db_Type; Code : Integer ) return  Countries;
   function Get_From_Intermediate_Region_Code (Db : access constant Nationality_Db_Type; Code : Integer ) return Countries;
   

   
private

   package Integer_Maps is new Ada.Containers.Ordered_Maps (Key_Type     => Integer,
                                                            Element_Type => Country_Access);
   type String_Access is access Constant String with Storage_Size => 0;


   function "<" (L, R : String_Access) return Boolean is
     (L.all < L.all);
   
   package String_Maps is new Ada.Containers.Indefinite_Ordered_Maps (Key_Type        => String,
                                                           Element_Type    => Country_Access);
   type Nationality_Db_Type is tagged record
      Full_Name_Map : String_Maps.Map;      
      Name_Map      : String_Maps.Map;
      Code_Map      : Integer_Maps.Map;
   end record;
   
   Db : constant Nationality_Db_Type_Access := new Nationality_Db_Type;
end ISO_3166;

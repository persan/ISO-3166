private with Ada.Containers.Indefinite_Ordered_Maps;
private with Ada.Containers.Ordered_Maps;

package ISO_3166 is

   type Country_Code_Type is new Integer;

   type Region_Code_Type is new Integer;

   type Sub_Region_Code_Type is new Integer;

   type Intermediate_Region_Code_Type is new Integer;

   type Country is tagged record
      Name                     : access constant String;
      Alpha_2                  : access constant String;
      Alpha_3                  : access constant String;
      Country_Code             : Country_Code_Type := 0;
      Iso_3166_2               : access constant String;
      Region                   : access constant String;
      Sub_Region               : access constant String;
      Intermediate_Region      : access constant String;
      Region_Code              : Region_Code_Type := 0;
      Sub_Region_Code          : Sub_Region_Code_Type := 0;
      Intermediate_Region_Code : Intermediate_Region_Code_Type := 0;
   end record;

   function Is_Unkonwn (C : access Country) return Boolean is
     (C = null or else C.all.Country_Code = 0);

   type Country_Access is  access constant Country;
   type Countries is array (Natural range <>) of Country_Access;

   type Nationality_Db_Type (<>) is tagged private;
   type Nationality_Db_Type_Access is not null access all Nationality_Db_Type'Class;

   Db : constant Nationality_Db_Type_Access;
   --  Handle to the database to be used
   --  This "database" is populated during elaboration of this library.
   --  -------------------------------------------------------------------------

   function Get_Country (Db   : access constant Nationality_Db_Type;
                         Name : String) return Country_Access;
   --  Locks up the country in the database using the official name, alpha-2,
   --   alpha-2 or ISO_3166-2 code
   --  returns No_Country if no matching country was found
   --  -------------------------------------------------------------------------

   function Get_Country (Db   : access constant Nationality_Db_Type;
                         Code : Country_Code_Type) return  Country_Access;
   --  Locks up the country in the database using the country-code
   --  returns No_Country if no matching country was found
   --  -------------------------------------------------------------------------

   function Get_Countries (Db   : access constant Nationality_Db_Type;
                           Code : Region_Code_Type) return  Countries;
   --  Locks up all countries witin a region.
   --  returns an empty vector if no Countries where found.
   --  -------------------------------------------------------------------------

private

   package Country_Code_Maps is new Ada.Containers.Ordered_Maps
     (Key_Type     => Country_Code_Type,
      Element_Type => Country_Access);

   type String_Access is access constant String with Storage_Size => 0;

   package String_Maps is new Ada.Containers.Indefinite_Ordered_Maps
     (Key_Type        => String,
      Element_Type    => Country_Access);

   type Nationality_Db_Type is tagged record
      Full_Name_Map : String_Maps.Map;
      Code_Map      : Country_Code_Maps.Map;
   end record;

   Db : constant Nationality_Db_Type_Access := new Nationality_Db_Type;
end ISO_3166;

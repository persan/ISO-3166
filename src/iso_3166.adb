pragma Ada_2012;
with ISO_3166.Database;
package body ISO_3166 is

   ---------
   -- Get --
   ---------

   function Get
     (Db : access constant Nationality_Db_Type; Name : String)
      return Country_Access
   is
   begin
      return Db.Name_Map (Name);
   end Get;

   ---------------------------
   -- Get_From_Country_Code --
   ---------------------------

   function Get_From_Country_Code
     (Db : access constant Nationality_Db_Type; Code : Integer)
      return Country_Access
   is
   begin
      return Db.Code_Map (Code);
   end Get_From_Country_Code;

   --------------------------
   -- Get_From_Region_Code --
   --------------------------

   function Get_From_Region_Code
     (Db : access constant Nationality_Db_Type; Code : Integer)
      return Countries
   is
      Temp : Countries (1 .. Database.Data'Length);
      Cursor : Natural := Temp'First;
   begin
      for I of Database.Data loop
         if I.Region_Code = Code then
            Temp (Cursor) := I;
            Cursor := Cursor + 1;
         end if;
      end loop;
      return Temp (Temp'First .. Cursor - 1);
   end Get_From_Region_Code;

   ---------------------------------------
   -- Get_From_Intermediate_Region_Code --
   ---------------------------------------

   function Get_From_Intermediate_Region_Code
     (Db : access constant Nationality_Db_Type; Code : Integer)
      return Countries
   is
      Temp : Countries (1 .. Database.Data'Length);
      Cursor : Natural := Temp'First;
   begin
      for I of Database.Data loop
         if I.Intermediate_Region_Code = Code then
            Temp (Cursor) := I;
            Cursor := Cursor + 1;
         end if;
      end loop;
      return Temp (Temp'First .. Cursor - 1);
   end Get_From_Intermediate_Region_Code;

end ISO_3166;

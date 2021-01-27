pragma Ada_2012;
with ISO_3166.Database;
package body ISO_3166 is

   ---------
   -- Get --
   ---------

   function Get_Country
     (Db : access constant Nationality_Db_Type; Name : String) return  Country_Access
   is
   begin
      if Db.Full_Name_Map.Contains (Name) then
         return Db.Full_Name_Map (Name);
      else
         return No_Country'Access;
      end if;
   end Get_Country;

   ---------------------------
   -- Get_From_Country_Code --
   ---------------------------

   function Get_Country
     (Db : access constant Nationality_Db_Type; Code : Country_Code_Type)
      return Country_Access
   is
   begin
      if Db.Code_Map.Contains (Code) then
         return Db.Code_Map (Code);
      else
         return No_Country'Access;
      end if;
   end Get_Country;

   --------------------------
   -- Get_From_Region_Code --
   --------------------------

   function Get_Countries
     (Db : access constant Nationality_Db_Type; Code : Region_Code_Type)
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
   end Get_Countries;

end ISO_3166;

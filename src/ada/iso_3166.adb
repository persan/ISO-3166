pragma Ada_2020;
with ISO_3166.Database; pragma Unreferenced (Iso_3166.Database);
package body ISO_3166 is
   use type Ada.Containers.Count_Type;

   ---------
   -- Get --
   ---------

   function Get_Country
     (Db : not null access constant Nationality_Db_Type; Name : String) return  Country_Access
   is
   begin
      if Db.Full_Name_Map.Contains (Name) then
         return Db.Full_Name_Map (Name);
      else
         return Db.Get_Country (0);
      end if;
   end Get_Country;

   ---------------------------
   -- Get_From_Country_Code --
   ---------------------------

   function Get_Country
     (Db : not null access constant Nationality_Db_Type; Code : Country_Code_Type)
      return Country_Access
   is
   begin
      if Db.Code_Map.Contains (Code) then
         return Db.Code_Map (Code);
      else
         return Db.Get_Country (0);
      end if;
   end Get_Country;

   --------------------------
   -- Get_From_Region_Code --
   --------------------------
   function Get_Countries
     (Db : not null access constant Nationality_Db_Type; Code : Region_Code_Type)
      return Countries
   is
      Temp   : Countries (1 .. Db.Code_Map.Length);
      Cursor : Ada.Containers.Count_Type := Temp'First;
   begin
      for I of Db.Code_Map loop
         if I.Region_Code = Code then
            Temp (Cursor) := I;
            Cursor := Cursor + 1;
         end if;
      end loop;
      return Temp (Temp'First .. Cursor - 1);
   end Get_Countries;

end ISO_3166;

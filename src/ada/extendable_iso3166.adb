pragma Ada_2020;
with Extendable_ISO3166.Database; pragma Unreferenced (Extendable_Iso3166.Database);
package body Extendable_ISO3166 is
   use type Ada.Containers.Count_Type;

   ---------
   -- Get --
   ---------

   function Get_Nationality
     (Db : not null access constant Nationality_Db_Type; Name : String) return  Nationality_Access
   is
   begin
      if Db.Full_Name_Map.Contains (Name) then
         return Db.Full_Name_Map (Name);
      else
         return Db.Get_Nationality (0);
      end if;
   end Get_Nationality;

   ---------------------------
   -- Get_From_Country_Code --
   ---------------------------

   function Get_Nationality
     (Db : not null access constant Nationality_Db_Type; Code : Nationality_Code_Type)
      return Nationality_Access
   is
   begin
      if Db.Code_Map.Contains (Code) then
         return Db.Code_Map (Code);
      else
         return Db.Get_Nationality (0);
      end if;
   end Get_Nationality;

   --------------------------
   -- Get_From_Region_Code --
   --------------------------
   function Get_Nationalities
     (Db : not null access constant Nationality_Db_Type; Code : Region_Code_Type)
      return Nationalities
   is
      Temp   : Nationalities (1 .. Db.Code_Map.Length);
      Cursor : Ada.Containers.Count_Type := Temp'First;
   begin
      for I of Db.Code_Map loop
         if I.Region_Code = Code then
            Temp (Cursor) := I;
            Cursor := Cursor + 1;
         end if;
      end loop;
      return Temp (Temp'First .. Cursor - 1);
   end Get_Nationalities;

end Extendable_ISO3166;

pragma Ada_2012;
package body ISO_3166.Database is
begin
   for I of Database.Data loop
      Db.Full_Name_Map.Include (I.Name.all, I);
      Db.Name_Map.Include (I.Name.all, I);
      Db.Full_Name_Map.Include (I.Alpha_2.all, I);
      Db.Full_Name_Map.Include (I.Alpha_3.all, I);
      Db.Full_Name_Map.Include (I.Iso_3166_2.all, I);
      Db.Code_Map.Include (I.Country_Code, I);
   end loop;
end ISO_3166.Database;

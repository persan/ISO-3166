with Extendeble_ISO3166;
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is

begin
   Put_Line (Extendeble_ISO3166.Nationality_Db.Get_Nationality (4).Name.all);
end Main;

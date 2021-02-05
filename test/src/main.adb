with ISO_3166;
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is

begin
   Put_Line(ISO_3166.Nationality_Db.Get_Country(4).Name.all);
end Main;

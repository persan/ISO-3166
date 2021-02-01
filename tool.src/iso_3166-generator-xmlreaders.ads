--  This is an xml reader for the format used in
--    https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/
--        all/all.xml
--

with Sax.Readers;
with Sax.Utils;
with Sax.Symbols;
package ISO_3166.Generator.XMLReaders is
   type Reader (Name_Map : access String_Maps.Map) is new Sax.Readers.Sax_Reader with null record;
   overriding procedure Start_Element
     (Handler    : in out Reader;
      NS         : Sax.Utils.XML_NS;
      Local_Name : Sax.Symbols.Symbol;
      Atts       : Sax.Readers.Sax_Attribute_List);
   procedure Load (Db : access String_Maps.Map; Path : String);

end ISO_3166.Generator.XMLReaders;

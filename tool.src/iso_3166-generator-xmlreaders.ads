with Input_Sources.Strings;
with Input_Sources.File;
with Sax.Readers;
with Sax.Utils;
with Sax.Symbols;
with Unicode.CES.Utf8;

Package ISO_3166.Generator.XMLReaders is
   type Reader (Name_Map : access String_Maps.Map) is new Sax.Readers.Sax_Reader with null record;
   procedure Start_Element
     (Handler    : in out Reader;
      NS         : Sax.Utils.XML_NS;
      Local_Name : Sax.Symbols.Symbol;
      Atts       : Sax.Readers.Sax_Attribute_List);
   procedure Load (Db : access String_Maps.Map; Path : String);

end ISO_3166.Generator.XMLReaders;

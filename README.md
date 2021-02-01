# ISO 3166
Is a library for simple access and mapping to the ISO-3166 country codes.
With enumeration values to simplify mapping from local standards to ISO-3166.

The core data in the library is taken from the specification:
   https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes
   
And the database could be extended to contain abstract countries like the red-cross, UN and so forth by providing more county databases (.xml-files) and rerun the generator.

The component contains API:s to be used in the languages Ada, C, Java and Pyton.

The whole idea behind this component is to provide an extensible countrycode that could be used to access a full descriptin of the country.
Associated with the country code is an enumeration type to make it easy to map from a uniqe definition of country to the ISO-3166 (possibly exytended) set of codes.



The generator could be extended to read the XML from https://www.iso.org/iso-3166-country-codes.html as well.



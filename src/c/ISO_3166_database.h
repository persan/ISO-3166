
#include "ISO_3166_mappings.h"

struct  ISO_3166_Country {
  char *Name;
  char *Alpha_2;
  char *Alpha_3;
  char *Iso_3166_2;
  int Country_Code;
  char *Region;
  char *Sub_Region;
  char *Intermediate_Region;
  int Region_Code;
  int Sub_Region_Code;
  int Intermediate_Region_Code;
} ISO_3166_Country;

struct ISO_3166_Country* ISO_3166_get_from_string(char *name);
struct ISO_3166_Country* ISO_3166_get_from_code(int country_code);


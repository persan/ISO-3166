#include <stdio.h>
#include <ISO_3166_database.h>
int main(int argc, char *argv[]) {
  printf("%s\n",ISO_3166_get_from_code(4)->Name);
}

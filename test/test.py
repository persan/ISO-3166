import sys
from os.path import *
sys.path.append(join(dirname(dirname(__file__)), "src", "python"))


from iso_3166 import CountryCode2Country

print(CountryCode2Country[4].Name)

package extendeble_iso3166;

public class Nationality {

	public final String Name;
	public final String Alpha_2;
	public final String Alpha_3;
	public final int Country_Code;
	public final String Iso_3166_2;
	public final String Region;
	public final String Sub_Region;
	public final String Intermediate_Region;
	public final int Region_Code;
	public final int Sub_Region_Code;
	public final int Intermediate_Region_Code;

	public Nationality(String Name, String Alpha_2, String Alpha_3, int Country_Code, String Iso_3166_2, String Region,
			String Sub_Region, String Intermediate_Region, int Region_Code, int Sub_Region_Code,
			int Intermediate_Region_Code) {
		this.Name = Name;
		this.Alpha_2 = Alpha_2;
		this.Alpha_3 = Alpha_3;
		this.Country_Code = Country_Code;
		this.Iso_3166_2 = Iso_3166_2;
		this.Region = Region;
		this.Sub_Region = Sub_Region;
		this.Intermediate_Region = Intermediate_Region;
		this.Region_Code = Region_Code;
		this.Sub_Region_Code = Sub_Region_Code;
		this.Intermediate_Region_Code = Intermediate_Region_Code;
	};
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Country_Code;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Nationality other = (Nationality) obj;
		if (Country_Code != other.Country_Code)
			return false;
		return true;
	}

};

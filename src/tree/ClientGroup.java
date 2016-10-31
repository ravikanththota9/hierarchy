package tree;

import java.util.List;

public class ClientGroup {
	
	private String cgname;
	
	private List<LegalEntity> legalEntites;

	public String getCgname() {
		return cgname;
	}

	public void setCgname(String cgname) {
		this.cgname = cgname;
	}

	public List<LegalEntity> getLegalEntites() {
		return legalEntites;
	}

	@Override
	public String toString() {
		return "ClientGroup [cgname=" + cgname + ", legalEntites=" + legalEntites + "]";
	}

	public void setLegalEntites(List<LegalEntity> legalEntites) {
		this.legalEntites = legalEntites;
	}
	
	

}

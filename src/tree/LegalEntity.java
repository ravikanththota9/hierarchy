package tree;

import java.util.List;

public class LegalEntity {
	
	private String lename;
	
	private List<TradingEntity> tradingEntities;

	public String getLename() {
		return lename;
	}

	public void setLename(String lename) {
		this.lename = lename;
	}

	public List<TradingEntity> getTradingEntities() {
		return tradingEntities;
	}

	public void setTradingEntities(List<TradingEntity> tradingEntities) {
		this.tradingEntities = tradingEntities;
	}

	@Override
	public String toString() {
		return "LegalEntity [lename=" + lename + ", tradingEntities=" + tradingEntities + "]";
	}

}

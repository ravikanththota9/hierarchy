package tree;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;


public class Hierarchy {
	
	
	
	
	public static void main(String[] args) throws SQLException, ClassNotFoundException {
		try{
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			String dbURL = "jdbc:sqlserver://localhost:1433;user=Ravi;password=rkrk;database=Test";
			Connection conn = DriverManager.getConnection(dbURL);
			if (conn != null) {
			    System.out.println("Connected");
			}
			CallableStatement cs = null;
			cs = conn.prepareCall("{call client_view_data(?)}");
			 cs.setString(1, "enti");
	         cs.execute();
	         ResultSet rs = cs.getResultSet();
	         System.out.println(rs);
	         
			/*Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("select * from finaltable");*/
			
			int pcgid = 0;
			int pleid = 0;
			int pteid = 0;
			ClientGroup clientGroup = null;
			LegalEntity legalEntity = null;
			TradingEntity tradingEntity = null;
			
			List<TradingEntity> tradingEntityList = null;
			List<LegalEntity> legalEntityList = null;
			List<ClientGroup> clientGroupList = new  ArrayList<ClientGroup>();
			
			while(rs.next()){
				
				int cgid = rs.getInt(1);//1
				int leid = rs.getInt(2);//2
				int teid = rs.getInt(3);//1
				
				
				if(pcgid != cgid ){
					if(legalEntity!=null){
						legalEntity.setTradingEntities(tradingEntityList);
						legalEntityList.add(legalEntity);
					}
					if(clientGroup!=null){
						clientGroup.setLegalEntites(legalEntityList);
						clientGroupList.add(clientGroup);
						pcgid = 0;
						pleid = 0;
						pteid = 0;
						legalEntity = null;
						clientGroup=null;
					}
					clientGroup = new ClientGroup();
					clientGroup.setCgname(rs.getString(4));
					legalEntityList = new ArrayList<LegalEntity>();
					pcgid = cgid;
				}
				if(pleid != leid){
					if(legalEntity!=null){
						legalEntity.setTradingEntities(tradingEntityList);
						legalEntityList.add(legalEntity);
					}
					legalEntity = new LegalEntity();
					legalEntity.setLename(rs.getString(5));
					tradingEntityList = new ArrayList<TradingEntity>();
					pleid = leid;
				}
				if(pteid != teid){
					tradingEntity = new TradingEntity();
					tradingEntity.setTeName(rs.getString(6));
					tradingEntityList.add(tradingEntity);
					pteid = teid;
				}								
			}
			legalEntity.setTradingEntities(tradingEntityList);
			legalEntityList.add(legalEntity);
			clientGroup.setLegalEntites(legalEntityList);
			clientGroupList.add(clientGroup);
			
			Map map = new HashMap();
			map.put("ClientGroup", clientGroupList);
			  ObjectMapper mapper = new ObjectMapper();
			String responseJSON = "";
			try {
				responseJSON = mapper.writeValueAsString(map);
			} catch (JsonParseException e) {
			} catch (JsonMappingException e) {
			} catch (IOException e) {
			}
			
			System.out.println(responseJSON);
		
		}catch(Exception e){
			e.printStackTrace();
		}
			
	}

}

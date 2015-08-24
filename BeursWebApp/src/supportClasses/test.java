package supportClasses;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

public class test 
{
	public static void main(String [] args) throws SQLException
	{
		// test 1
		
		DatabaseInteraction dbInt = new DatabaseInteraction();
		ArrayList<HashMap<String,Object>> queryResult = dbInt.executeQuery("SELECT * FROM users");
		
		for(HashMap<String,Object> row:queryResult)
		{
			for(String key:row.keySet())
			{
				System.out.println(key + " " + row.get(key));
			}
		}
		
		// test 2
		
		HashSet<String> queryResult2 = dbInt.getTableNames();
		for(String tableName:queryResult2)
		{
			System.out.println(tableName);
		}
		
		// test 3
	}
	
	
}

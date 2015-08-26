package supportClasses;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;

public class test 
{
	public static void main(String [] args) throws SQLException
	{
		// test 1
		
		DatabaseInteraction dbInt = new DatabaseInteraction();
		QueryResult queryResult = dbInt.executeQuery("SELECT * FROM users");
		
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
		String password = "louis";
		String candidate = "jams";
		String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));

		// Check that an unencrypted password matches one that has
		// previously been hashed
		if (BCrypt.checkpw(candidate, hashed))
			System.out.println("It matches");
		else
			System.out.println("It does not match");
		
		// test 4
		queryResult = dbInt.executeQuery("SELECT * FROM users");
		for(String key: queryResult.getColumnNames())
		{
			System.out.println(key);
		}
		
		// test 5
		try
		{
			dbInt.addUser("louis", "pass");
		}
		catch(Exception e)
		{
			System.out.println("error");
		}
	}
	
	
}

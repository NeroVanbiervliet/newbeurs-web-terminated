package supportClasses;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;


public class BcryptEnServerTest 
{
	public static void main(String [] args) throws SQLException, OakDatabaseException
	{
		// test 1
		
		DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
		QueryResult queryResult = dbInt.executeQuery("SELECT * FROM user");
		
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
		String password = "fromzerotoone";
		String candidate = "jams";
		String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
		System.out.println("hasshedpassword");
		System.out.println(hashed);
		
		// Check that an unencrypted password matches one that has
		// previously been hashed
		if (BCrypt.checkpw(candidate, hashed))
			System.out.println("It matches");
		else
			System.out.println("It does not match");
		
		// test 4
		queryResult = dbInt.executeQuery("SELECT * FROM user");
		for(String key: queryResult.getColumnNames())
		{
			System.out.println(key);
		}
		
		// test 5
		try
		{
			dbInt.addUser("louis", "pass");
			dbInt.addUser("beurs", "frmzrtn5894rndm");
		}
		catch(Exception e)
		{
			System.out.println("bestaat al in database");
		}
		
		// test 6 
		boolean isCorrect;
		try 
		{
			isCorrect = dbInt.isCorrectPassword("louis", "pass");
		} catch (OakDatabaseException e) 
		{
			isCorrect = false;
		}
		
		if(isCorrect)
		{
			System.out.println("passOK");
		}
		else
		{
			System.out.println("passFAUT");
		}
		
		
	}
	
	
}

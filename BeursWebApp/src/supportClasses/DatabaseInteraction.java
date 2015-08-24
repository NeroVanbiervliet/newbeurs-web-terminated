package supportClasses;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.management.Query;

import java.sql.*;

// A class to interact with the oak beurs database (c) Nero
public class DatabaseInteraction 
{
	
	// variables
	private String dbHost = "localhost";;
	private String dbName = "oakTest";;
	private String dbUser;
	private String dbPassword;
	
	// TODO arraylists van maken? 
	List<String> userList = Arrays.asList("root","baerto","beurs");
	List<String> passwordList = Arrays.asList("lnrddvnc","baertpass","fromzerotoone");
	
	// the JDBC connector class
	private String dbClassName = "com.mysql.jdbc.Driver";
	
	private String connectionArgs;
	
	// default constructor
	// NEED root verwijderen als default user
	public DatabaseInteraction()
	{
		this("root");
	}
	
	// constructor 
	public DatabaseInteraction(String dbUser)
	{
		this.dbUser = dbUser; 
		
		// get password
		if(userList.contains(dbUser)) // known user
		{
			int userIndex = this.userList.indexOf(dbUser);
			this.dbPassword = this.passwordList.get(userIndex);
		}
		else // unknown user, default pass is empty
		{
			this.dbPassword = "";
		}
		
		// looks like jdbc:mysql://localhost/oakTest
		this.connectionArgs = "jdbc:mysql://" + this.dbHost + "/" + this.dbName;
		
		// internet code
		try 
		{
			Class.forName(dbClassName);
		} 
		catch (ClassNotFoundException e) 
		{
			// NEED testen of dit geprint wordt op webpagina als dbClassName niet gevonden wordt (brolnaam intypen)
			e.printStackTrace();
		}
	}
	
	// functions
	
	// returns an array of all valid table names NEED throw goed? 
	public HashSet<String> getTableNames() throws SQLException
	{
		String query = "SHOW TABLES";
		
		ArrayList<HashMap<String, Object>> rawQueryResult = executeQuery(query);
		
		HashSet<String> queryResult = new HashSet<>();
		
		for(HashMap<String, Object> hashMap:rawQueryResult)
		{
			for(Object value: hashMap.values())
			{
				queryResult.add(value.toString());
			}
		}
		
		return queryResult;
	}
	
	// NEED throws aanpassen?
	public ArrayList<HashMap<String,Object>> getAllTableEntries(String tableName) throws SQLException
	{
		String query = "SELECT * FROM " + tableName;
		return executeQuery(query);
	}
	
	// executes a given query
	public ArrayList<HashMap<String,Object>>  executeQuery(String query) throws SQLException
	{		
		Connection conn = java.sql.DriverManager.getConnection(connectionArgs,dbUser,dbPassword);
		Statement statement = conn.createStatement();
		
	    ResultSet rawQueryResult = null;
	    boolean returnsRows = statement.execute(query);
	    
	    // vanaf hier code van internet met eigen aanpassingen
	    
	    if (returnsRows) // query gefailed
	    {
	    	rawQueryResult = statement.getResultSet();
	    }
	    else
	    {
	    	return new ArrayList<HashMap<String,Object>>();
	    }
	    
	    // get metadata
	    ResultSetMetaData metaData = null;
	    metaData = rawQueryResult.getMetaData();
	    
	    // get column names
	    int colCount = metaData.getColumnCount();
	    ArrayList<String> columns = new ArrayList<String>();
	    for(int i=1; i<=colCount; i++)
	    {
	      columns.add(metaData.getColumnName(i));
	    }
	    
	    // fetch out rows
	    ArrayList<HashMap<String,Object>> queryResult = new ArrayList<HashMap<String,Object>>();

	    while(rawQueryResult.next()) 
	    {
			  HashMap<String,Object> currentRow = new HashMap<String,Object>();
			  for(String columnName:columns) 
			  {
				  	if(columnName.equals("TABLE_NAME"))
				  	{
				  		Object value = rawQueryResult.getString(1);
					    currentRow.put(columnName,value);
				  	}
				  	else // alle normale columns
				  	{
				  		Object value = rawQueryResult.getObject(columnName);
					    currentRow.put(columnName,value);
				  	}
				  	
			  }
			  queryResult.add(currentRow);
	    }
	    
	    statement.close();
        conn.close();
        
        return queryResult;
	}
	
}
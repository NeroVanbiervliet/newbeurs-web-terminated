package supportClasses;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import supportClasses.OakDatabaseException;

import java.sql.*;

// A class to interact with the oak beurs database (c) Nero
public class DatabaseInteraction 
{
	
	// variables
	private String dbHost = "localhost";
	private String dbName;
	private String dbUser;
	private String dbPassword;
	
	// TODO arraylists van maken? 
	List<String> userList = Arrays.asList("root","baerto","beurs","webapp");
	List<String> passwordList = Arrays.asList("lnrddvnc","baertpass","fromzerotoone","fromzerotoone");
	
	// the JDBC connector class
	private String dbClassName = "com.mysql.jdbc.Driver";
	
	private String connectionArgs;
	
	// default constructor
	// NEED root verwijderen als default user
	public DatabaseInteraction(String dbName)
	{
		this(dbName, "root");
	}
	
	// constructor 
	public DatabaseInteraction(String dbName, String dbUser)
	{
		this.dbName = dbName;
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
		
		QueryResult rawQueryResult = executeQuery(query);
		
		HashSet<String> tableNames = new HashSet<>();
		
		for(HashMap<String, Object> hashMap:rawQueryResult)
		{
			for(Object value: hashMap.values())
			{
				tableNames.add(value.toString());
			}
		}
		
		return tableNames;
	}
	
	// creates new user
	public void addUser(String name, String password) throws SQLException
	{

		String passwordHashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
		
		String query = "INSERT INTO user(name, passwordHashed) ";
		query += String.format("VALUES ('%s', '%s')", name, passwordHashed);
	
		executeQuery(query);
	}
	
	// NEED throws aanpassen?
	public QueryResult getAllTableEntries(String tableName) throws SQLException
	{
		String query = "SELECT * FROM " + tableName;
		return executeQuery(query);
	}
	
	// executes a given query
	public QueryResult  executeQuery(String query) throws SQLException
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
	    	return new QueryResult(new ArrayList<HashMap<String,Object>>());
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
        
        
        QueryResult queryResultPackage = new QueryResult(queryResult);
        
        return queryResultPackage;
	}
	
	// gets the info of a user
	public QueryResult getUserInfo(String userName) throws OakDatabaseException
	{
		String query = String.format("SELECT * FROM user WHERE name='%s'", userName);
		try 
		{
			return executeQuery(query);
		} 
		catch (SQLException e) 
		{
			// NEED reden voor exception erin verwerken (halen uit e.getmessage of zo)
			throw new OakDatabaseException("Unknown database error.");
		}
	}
	
	// checks if the password of a user is correct
	public boolean isCorrectPassword(String userName, String password) throws OakDatabaseException
	{
		QueryResult userInfo = getUserInfo(userName);
		
		if(userInfo.containsData())
		{
			String passwordHashed = (String) userInfo.iterator().next().get("passwordHashed");
			
			// checken of paswoord klopt
			if (BCrypt.checkpw(password, passwordHashed))
			{
				// password matches
				return true;
			}
			else
			{
				// password does not match
				return false;
			}
		}
		else // er is geen match in de database voor deze userName
		{
			throw new OakDatabaseException("userName komt niet voor in de user table.");
		}

	}
	
	// sets the isActive column of a strategy
	// TODO misschien niet zo netjes om hier strings te gebruiken
	public void setIsActive(String id, String isActive) throws SQLException
	{
		String query = String.format("UPDATE strategy SET isActive=%s WHERE id=%s",isActive,id);
		executeQuery(query);
	}
	
	// updates the parameters of a strategy
	// TODO misschien niet zo netjes om hier strings te gebruiken
	public void setNewParameters(String strategyId, String userId, String newParameters) throws SQLException
	{
		// NEED geen record aanmaken als de data niet veranderd is
		// create strategyEditHistory entry
		String query = "INSERT INTO strategyEditHistory(strategy,editor,newParameters) ";
		query += String.format("VALUES ('%s','%s','%s'); ", strategyId,userId,newParameters);
		
		executeQuery(query);
		
		query = String.format("UPDATE strategy SET parameters='%s' WHERE id=%s;",newParameters,strategyId);
		
		executeQuery(query);
	}
	
	// adds an entry to the simulation table
	public void addSimulation(String name,String description,String owner,String strategy) throws SQLException
	{
		// INSERT INTO simulation(name,description,owner,strategy,totalGain,totalReturn,status,progress) VALUES('denaam','descip0','1','1','3','4','running','40');
		String query = "INSERT INTO simulation(name,description,owner,strategy,status,progress) ";
		query += String.format("VALUES('%s','%s','%s','%s','running','0')",name,description,owner,strategy);
		
		executeQuery(query);
	}
	
}

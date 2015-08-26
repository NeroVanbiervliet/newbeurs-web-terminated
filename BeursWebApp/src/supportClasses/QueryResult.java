package supportClasses;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class QueryResult implements Iterable<HashMap<String, Object>> {

	private ArrayList<HashMap<String,Object>> data;
	
	// constructor
	public QueryResult(ArrayList<HashMap<String,Object>> data) 
	{
		this.data = data;
	}
	
	@Override
	public Iterator<HashMap<String, Object>> iterator() 
	{
		return data.iterator();
	}

	// returns all column names if this.containsData()
	public Set<String> getColumnNames()
	{
		
		if(this.containsData())
		{
			return this.iterator().next().keySet();
		}
		else
		{
			return new HashSet<String>();
		}
	}
	
	// returns false if no rows are present in the query result
	public boolean containsData()
	{
		Iterator<HashMap<String, Object>> iterator = this.iterator();
		
		if(iterator.hasNext()) // iterator is niet leeg
		{
			return true;
		}
		else // iterator is leeg
		{
			return false;
		}
	}
}

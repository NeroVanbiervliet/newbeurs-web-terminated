package supportClasses;

public class OakDatabaseException extends Exception 
{

	// obligated because serializable class
	private static final long serialVersionUID = 6293987536715542348L;

	public OakDatabaseException(String message)
	{
		super(message);
	}
}

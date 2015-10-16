package supportClasses;

import java.sql.SQLException;

import sun.security.util.Length;

public class test {

	public static void main(String [] args)
	{
		String hallo = "{eerste}{tweede}";
		String[] parts = hallo.split("}");
		for(String part : parts)
		{
			System.out.println(part);
		}
		System.out.print(hallo.substring(1,hallo.length()));
	}
}

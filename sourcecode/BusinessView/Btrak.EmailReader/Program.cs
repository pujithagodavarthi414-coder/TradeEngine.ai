using System;
using System.Configuration;
public class Program
{
    public static void Main(string[] args)
    {
        var emailReader = new EmailReader();
        Console.WriteLine("Emails reading started");
        while (true)
        {
            
            emailReader.GetEmailsList();
            Console.WriteLine("Emails reading ended");

            //One minute delay 
            System.Threading.Thread.Sleep(1 * (1000 * 60));

        }

    }
}
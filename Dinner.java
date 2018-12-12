/*
 * @author Zack Neefe, Xinyi Lyu
 * This is Dinner class. It determine the philosopher's state. It managers
 * the dinner. It set N forks to N philosphers.
 * 
 */
import java.util.Scanner;
public class Dinner 
{
   private Scanner input = new Scanner(System.in);
   private int philosopherNum = 0, dinnerLast = 0;
   private Philosopher[] philosophers;
   private Fork[] forks;
   
   /**
 *
 * @author Xinyi Lyu 
 * this runs this class
 */
   public void run()
   {
      System.out.println("How many philosophers are dining?");
      philosopherNum = input.nextInt();
      System.out.println("How long will the dinner last (in milliseconds)?");
      dinnerLast = input.nextInt();
      System.out.println();
      
      philosophers = new Philosopher[philosopherNum];
      forks = new Fork[philosopherNum];
      
      for(int i = 0; i < philosopherNum; i++)
      {
         forks[i] = new Fork();
      }
      for(int i = 0; i < philosopherNum; i++)
      {
         philosophers[i] = new Philosopher(i, forks[i], 
                                           forks[(i+1)%philosopherNum]);
         philosophers[i].start();
      }
      
      try
      {
      Thread.sleep(dinnerLast);
      System.out.println();
      }
      catch(Exception e)
      {
          System.out.println("error: " + e);
      }
      StopEating();
      PrintPhilosophers();
   }
   
   /**
 *
 * @author Zack Neefe
 * set all philosopher stop eating
 */
   private void StopEating()
   {
      for(int i = 0; i < philosopherNum; i++)
      {
         philosophers[i].stopEating();
      }
   }
   
   /**
 *
 * @author Xinyi Lyu
 * print the philosopher statistics.
 */
   private void PrintPhilosophers()
   {
      for(int i = 0; i < philosopherNum; i++)
      {
         philosophers[i].Print();
      }
   }
}

/*
 *Name: Zack Neefe, Xinyi Lyu
 *This class is philospoher class. A philosopher will eat and think in the
 *program. Each philosopher have one fork on his left side and one fork on his
 *right side. He will eat will two forks are avalliable.
 */
import java.util.Random;
public class Philosopher extends Thread
{
   private int ID;
   private Fork fork1;
   private Fork fork2;
   private boolean eating = true;
   private Random waitTime = new Random();
   private int timeEat;
   private int timeThink;
   private int eats;
   
   /**
 *
 * @author neefez
 * Constructor that takes in the id number and the two adjacent forks.
 */
   public Philosopher(int id, Fork f1, Fork f2)
   {
      ID = id;
      fork1 = f1;
      fork2 = f2;
   }
   
   /**
 *
 * @author neefez
 * it runs
 */
   public void run()
   {
      while(eating)
      {
         if(eating)
            System.out.println(ID + ". THINKING");
         timeThink += IdleWait();
         WaitForForks();
         
         if(eating)
            System.out.println (ID + ". EATING"); 
         eats++;
         timeEat += IdleWait();
         startThinking();
      }
   }
   
   /**
 *
 * @author Xinyi Lyu
 * it wait for fork while forks are avaliable
 */
   private void WaitForForks()
   {
      while(!fork1.isUsed() && !fork2.isUsed())
      {
         if(!fork1.isUsed())
            fork1.useFork();
         if(!fork2.isUsed())
            fork2.useFork();
      }    
   }
           
   /**
 *
 * @author Xinyi Lyu
 * count the random time for waiting
 */
   private int IdleWait()
   {
      try
      {
         int timeWaiting = waitTime.nextInt(999) + 1;
         Thread.sleep(timeWaiting);
         return timeWaiting;
      }
      catch(Exception ex)
      {
         System.out.println("Error: " + ex);
         return 0;
      }
   }        
        
   /**
 *
 * @author neefez
 * set the whole eating time to false
 */
   public void stopEating()
   {
      eating = false;
   }
   
   /**
 *
 * @author neefez
 * philosopher start thinking
 */
   private void startThinking()
   {      
      fork1.doneWithFork();
      fork2.doneWithFork();
   }        
   
   /**
 *
 * @author neefez
 * print the statistics of each philosopher's state
 */
   public void Print()
   {
      System.out.println("Philosopher ID: " + ID);
      System.out.println("Philosopher eat time: " + eats);
      System.out.println("Time spent eating: " + timeEat + " mSecs");
      System.out.println("Time spent thinking: " + timeThink + " mSecs");
      System.out.println();
   }
}

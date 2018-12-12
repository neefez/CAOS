/*
 * Name: Zack Neefe, Xinyi Lyu
 * This is Fork class. It determine the state of forks.
 */
public class Fork 
{
   public boolean beingUsed;
   
   /**
 *
 * @author neefez
 * Default constructor. Fork is not used right away
 */
   public Fork()
   {
      beingUsed = false;
   }
   
   /**
 *
 * @author neefez
 * set fork to be used
 */
   public boolean isUsed()
   {
      return beingUsed;
   }
   
   /**
 *
 * @author neefez
 * return fork is used
 */
   public void useFork()
   {
      beingUsed = true;
   }
   
   /**
 *
 * @author neefez
 * return fork is not be used
 */
   public void doneWithFork()
   {
      beingUsed = false;
   }
}

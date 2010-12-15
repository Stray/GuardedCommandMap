package 
{
	import org.robotlegs.core.IGuard;

	public class DoubleInjectedGuard implements IGuard
	{
	    [Inject]
		public var answer:IInjectedAnswer;

	    [Inject]
		public var otherAnswer:IInjectedAnswer;

	    //---------------------------------------
	    // IGuard Implementation
	    //---------------------------------------

	    //import org.robotlegs.core.IGuard;
	    public function approve():Boolean
	    {
	    	return (answer.approve() && otherAnswer.approve());
	    }
	
	} 

}
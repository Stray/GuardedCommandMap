package {
	                                 
	import org.robotlegs.mvcs.Command;
	import ICommandReporter;
	
	public class SampleCommandB extends Command {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function SampleCommandB() {			
			// pass constants to the super constructor for properties
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		override public function execute():void
		{
			reporter.reportCommand(SampleCommandB);
		}
		
	}
}
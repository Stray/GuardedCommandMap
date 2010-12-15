package {
	                                 
	import org.robotlegs.mvcs.Command;
	import ICommandReporter;
	
	public class SampleCommandA extends Command {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function SampleCommandA() {			
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
			reporter.reportCommand(SampleCommandA);
		}
		
	}
}
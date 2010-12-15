package {
	                                 
	import org.robotlegs.mvcs.Command;
	import ICommandReporter;
	
	public class SampleCommandC extends Command {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function SampleCommandC() {			
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
			reporter.reportCommand(SampleCommandC);
		}
	}
}
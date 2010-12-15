package org.robotlegs.base {
	
	import org.robotlegs.base.CommandMap;
	import flash.events.IEventDispatcher;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	
	public class GuardedCommandMap extends CommandMap {
		
		public function GuardedCommandMap(eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector) {
			super(eventDispatcher, injector, reflector);
		}
		
		//---------------------------------------
		// IGuardedCommandMap Implementation
		//---------------------------------------

		//import org.robotlegs.core.IGuardedCommandMap;
		public function mapGuardedEvent(eventType:String, commandClass:Class, guards:*, eventClass:Class = null, oneshot:Boolean = false):void
		{
			
		}

		 
	}
}
package org.robotlegs.base {

	import asunit.errors.AssertionFailedError;     
	import asunit.framework.TestCase;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mockolate.errors.VerificationError;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;
   	import mockolate.verify;
	import org.hamcrest.core.anything;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.core.ICommandMap;  
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import ICommandReporter;

	public class GuardedCommandMapTest extends TestCase {
		private var instance:GuardedCommandMap;
        private var injector:IInjector;
		private var eventDispatcher:EventDispatcher;
		private var _reportedCommands:Array;

		public function GuardedCommandMapTest(methodName:String=null) {
			super(methodName)
		}

		override public function run():void{
			var mockolateMaker:IEventDispatcher = prepare(IMediatorMap, ICommandMap);
			mockolateMaker.addEventListener(Event.COMPLETE, prepareCompleteHandler);
		}

		private function prepareCompleteHandler(e:Event):void{
			IEventDispatcher(e.target).removeEventListener(Event.COMPLETE, prepareCompleteHandler);
			super.run();
		}
        
		public function reportCommand(commandClass:Class):void
		{
			_reportedCommands.push(commandClass);
		}

		override protected function setUp():void {
			super.setUp();
			_reportedCommands = [];
			injector = new SwiftSuspendersInjector();
			var reflector:IReflector = new SwiftSuspendersReflector();  
			eventDispatcher = new EventDispatcher();
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(DisplayObjectContainer, new Sprite());
			injector.mapValue(IMediatorMap, nice(IMediatorMap));
			injector.mapValue(ICommandMap, nice(ICommandMap));
			injector.mapValue(ICommandReporter, this);
			injector.mapValue(IInjector, injector);

			instance = new GuardedCommandMap(eventDispatcher, injector, reflector);
			
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is GuardedCommandMap", instance is GuardedCommandMap);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_one_command_with_one_guard_fires_when_guard_gives_yes():void {
			assertTrue("One command with one guard fires when guard gives yes -> not implemented", false);
		} 
		
		public function test_one_command_with_one_guard_doesnt_fire_when_guard_gives_no():void {
			assertTrue("One command with one guard doesnt fire when guard gives no -> not implemented", false);
		}
		
		public function test_one_command_with_two_guards_fires_if_both_say_yes():void {
			assertTrue("One command with two guards fires if both say yes -> not implemented", false);
		}
		
		public function test_one_command_with_two_guards_doesnt_fire_if_one_says_no():void {
			assertTrue("One command with two guards doesnt fire if one says no -> not implemented", false);
		}
		
		public function test_command_doesnt_fire_if_double_injected_guard_says_no():void {
			assertTrue("Command doesnt fire if double injected guard says no -> not implemented", false);
		}
		
		public function test_three_commands_with_different_guards_fire_correctly():void {
			assertTrue("Three commands with different guards fire correctly -> not implemented", false);
		}
		
		public function test_error_thrown_if_non_guards_provided_in_guard_argument():void {
			assertTrue("Error thrown if non guards provided in guard argument -> not implemented", false);
		}
		
		public function test_unmapping_stops_command_firing():void {
			assertTrue("Unmapping stops command firing -> not implemented", false);
		}
		
		public function test_unmapping_and_remapping_with_guards_works_fine():void {
			assertTrue("Unmapping and remapping with guards works fine -> not implemented", false);
		}
		
	}
}
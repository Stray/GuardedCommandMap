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
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.base.ContextError;

	public class GuardedCommandMapTest extends TestCase implements ICommandReporter {
		private var guardedCommandMap:GuardedCommandMap;
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

			guardedCommandMap = new GuardedCommandMap(eventDispatcher, injector, reflector);
			
		}

		override protected function tearDown():void {
			super.tearDown();
			guardedCommandMap = null;
		}

		public function testInstantiated():void {
			assertTrue("guardedCommandMap is GuardedCommandMap", guardedCommandMap is GuardedCommandMap);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_one_command_with_one_guard_fires_when_guard_gives_yes():void {             
			var guard:Class = HappyGuard;
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [SampleCommandA], _reportedCommands);
		} 
		
		public function test_one_command_with_one_guard_doesnt_fire_when_guard_gives_no():void {
			var guard:Class = GrumpyGuard;
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [], _reportedCommands);
		}
		
		public function test_one_command_with_two_guards_fires_if_both_say_yes():void {
			injector.mapSingletonOf(IInjectedAnswer, InjectedYes);
			var guards:Array = [InjectedGuard, HappyGuard];
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guards, ContextEvent); 
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [SampleCommandA], _reportedCommands);
		}
		
		public function test_one_command_with_two_guards_doesnt_fire_if_one_says_no():void {
			var guards:Array = [GrumpyGuard, HappyGuard];
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guards, ContextEvent); 
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [], _reportedCommands);
		}
		
		public function test_command_doesnt_fire_if_double_injected_guard_says_no():void {
			injector.mapSingletonOf(IInjectedAnswer, InjectedYes);
			injector.mapSingletonOf(IInjectedOtherAnswer, InjectedNo);
			var guards:Array = [HappyGuard, DoubleInjectedGuard]; 
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guards, ContextEvent); 
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [], _reportedCommands);
		}
		
		public function test_three_commands_with_different_guards_fire_correctly():void { 
			injector.mapSingletonOf(IInjectedAnswer, InjectedYes);
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, HappyGuard, ContextEvent);
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandB, GrumpyGuard, ContextEvent);
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandC, [HappyGuard, InjectedGuard], ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP)); 
			assertEqualsArraysIgnoringOrder("received the correct command", [SampleCommandA, SampleCommandC], _reportedCommands);
		}
		
		public function test_error_thrown_if_non_guards_provided_in_guard_argument():void {
			assertThrows(ContextError, function():void{
				guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, Sprite, ContextEvent);
			});
		}
		
		public function test_error_thrown_if_non_guards_provided_in_guard_argument_array():void {
			assertThrows(ContextError, function():void{
				guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, [HappyGuard, Sprite], ContextEvent);
			});
		}
		
		public function test_unmapping_stops_command_firing():void {
			var guard:Class = HappyGuard;
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			guardedCommandMap.unmapEvent(ContextEvent.STARTUP, SampleCommandA, ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [], _reportedCommands);
		}		
		
		public function test_unmapping_and_remapping_with_guards_works_fine():void {
			var guard:Class = HappyGuard;
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			guardedCommandMap.unmapEvent(ContextEvent.STARTUP, SampleCommandA, ContextEvent);
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [SampleCommandA], _reportedCommands);  
		}
		
	}
}
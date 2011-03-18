package org.robotlegs.core {
		
	import org.robotlegs.core.ICommandMap;
	
	public interface IGuardedCommandMap extends ICommandMap { 
		
		/**
		 * Map a Command to an Event type, with Guards
		 * 
		 * <p>The <code>commandClass</code> must implement an <code>execute()</code> method</p>
		 * <p>The <code>guards</code> must be a Class which implements an <code>approve()</code> method</p>
		 * <p>or an <code>Array</code> of Classes which implements an <code>approve()</code> method</p>
		 * 
		 * @param eventType The Event type to listen for
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>. Your commandClass can optionally [Inject] a variable of this type to access the event that triggered the command.
		 * @param oneshot Unmap the Class after execution?
		 * 
		 * @throws org.robotlegs.base::ContextError
		*/
		function mapGuardedEvent(eventType:String, commandClass:Class, guards:*, eventClass:Class = null, oneshot:Boolean = false):void;
		
		/**
		 * Map a Command to an Event type, with Guards
		 * 
		 * <p>The <code>commandClass</code> must implement an <code>execute()</code> method - run if the guard approves</p>
		 * <p>The <code>fallbackCommandClass</code> must implement an <code>execute()</code> method - run if the guard doesn't approve</p>
		 * <p>The <code>guards</code> must be a Class which implements an <code>approve()</code> method</p>
		 * <p>or an <code>Array</code> of Classes which implements an <code>approve()</code> method</p>
		 * 
		 * @param eventType The Event type to listen for
		 * @param commandClass The Class to instantiate if the guard approves - must have an execute() method
		 * @param fallbackCommandClass The Class to instantiate if the guard refuses - must have an execute() method
		 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>. Your commandClass can optionally [Inject] a variable of this type to access the event that triggered the command.
		 * @param oneshot Unmap the Class after execution?
		 * 
		 * @throws org.robotlegs.base::ContextError
		*/
		function mapGuardedEventWithFallback(eventType:String, commandClass:Class, fallbackCommandClass:Class, guards:*, eventClass:Class = null, oneshot:Boolean = false):void;
	
		
	}
}
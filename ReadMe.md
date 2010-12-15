**What is a GuardedCommandMap?**

Sometimes you want to map behaviour to an event, but only if certain other conditions are met.

It could be that the condition is relevant to some other property of the event - say the specific key being pressed in a KeyboardEvent - or it could be something else, for example whether the user already has local account details in a SOL.

Usually we wind up implementing this kind of logic using if() statements and early bails in the execution of the Command.

The GuardedCommandMap abstracts the conditions from the actions.

**Like how?**

As well as mapping a Command, you also map one or more Guards. The Command is only executed if all the Guards agree to it.

This has the advantage of allowing you to map a Command as oneShot, but know that it won't be executed and unmapped unless all the Guards are passed.

**What's a Guard?**

A Guard is very similar to a Command. It has only one public method: approve():Boolean.

The Guard Classes are instantiated in the same way as Command classes - so they can have injections in the same way as the Command, and can receive the Event class that triggered the CommandMap, just as the Command eventually will.

The approve() method returns true or false. If all the approve() methods return true then the Command will be instantiated and will run. If any approve() method returns false then the process is aborted.      

**Give me an example**

My strategy game has a daily cycle which includes offering the player some casual labour, but we don't want to do this in the first three cycles of the game, while the player is still picking up the basics.

So - currently the command "OfferExtraLabour" has an execute like this:

	override public function execute():void 
	{
		if(calendarModel.daysPassed > config.numberOfNormalDaysAtStart)
		{
			labourSurpriseEventCaster.castSurpriseEvent();
		}
		else
		{
			labourSurpriseEventCaster.castNormalEvent();
		}
	}
	
But that's a brittle condition. There no inherent link between the action and the condition. My logic is a little tangled.

And, worse, there are a bunch of other things that I also don't want to kick in until day 3. So the logic is repeated in these other Commands as well as being tangled up with irrelevant things. If I decided to define the learning period differently I'd have to make changes in several places. We can do better!

With the GuardCommandMap I can refactor to put the logic into one OnlyAfterLearningPeriod with this approval function:

	override public function approve():Boolean 
	{
		return (calendarModel.daysPassed > config.numberOfNormalDaysAtStart)
	}
	
Which simplifies the actual Commands to:

    override public function execute():void 
	{
		labourSurpriseEventCaster.castSurpriseEvent();
	}    

And even better, makes my mapping more declarative of my intent:

	guardedCommandMap.mapGuardedEvent(DayCycleEvent.STONE_DELIVERY_COMPLETE, OfferLabourCommand, OnlyAfterLearningPeriod, DayCycleEvent);

And if I wanted to combine guards, I can supply an array of guards instead of a single class:

	guardedCommandMap.mapGuardedEvent(DayCycleEvent.STONE_DELIVERY_COMPLETE, OfferLabourCommand, [OnlyAfterLearningPeriod, OnlyWhenBehindSchedule], DayCycleEvent);


**Incorporating GuardedCommandMap into your robotlegs project** 

You just need to instantiate and map it in your context - either early in startup, or by overriding the mapInjections context method:

	override protected function mapInjections():void
	{
		super.mapInjections();
		injector.mapValue(IGuardedCommandMap, new GuardedCommandMap(eventDispatcher, injector, reflector));
	}

Then just inject against IGuardedCommandMap in your other Commands.    

**How do I create a Guard?**

There is an optional interface - IGuard - to keep you honest, but any class which implements approves() and returns something will work, though you should be aware that the return value will be coerced to boolean.

The standard interface to implement is:

	function approve():Boolean;      
	
Other than that there are no constraints on your guards, which means that if you're the sort of person who feels that lots of classes are a drag, you could hacky-hack your existing models to be guards - for example if you wanted to guard against something until a particular model has initialised. But I don't encourage that sort of thing. And you're probably using controllers anyway.


**Compatibility with robotlegs versions**

This util has been tested against robotlegs versions 1.0 and 1.4 - it should work for any. By simply including the 3 classes in the source of your project you can ensure it compiles against the same version of robotlegs that you're using.                  


**Wot no swc** 

Truth is, I can't get the damn thing to build a swc without also pulling in the robotlegs classes it extends, which would break compatibility with other versions of robotlegs. If you are a swc wizard, please fork and build a swc and share it.

**Are these like Haskell Guards?**

Kinda, maybe.

The inspiration for this CommandMap variation comes from the following blog post: http://blog.iconara.net/2008/03/30/separating-event-handling-from-event-filtering/

There is more discussion on guarding in general in the comments there.

Thanks to @AmyBlankenship for the suggestion.
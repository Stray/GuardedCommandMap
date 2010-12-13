**What is a GuardedCommandMap?**

Sometimes you want to map behaviour to an event, but only if certain other conditions are met.

It could be that the condition is relevant to some other property of the event - say the specific key being pressed in a KeyboardEvent - or it could be something else, for example whether the user already has local account details in a SOL.

Usually we wind up implementing this kind of logic using if() statements and early bails in the execution of the Command.

The GuardedCommandMap abstracts the conditions from the actions.

**Like how?**

As well as mapping a Command, you also map one or more Guards. The Command is only executed if all the Guards agree to it.

This has the advantage of allowing you to map a Command as oneShot, but know that it won't be executed and unmapped unless all the Guards are passed.

**What's a Guard?**

A Guard is very similar to a Command. It has only one public method: guard():Boolean.

The Guard Classes are instantiated in the same way as Command classes - so they can have injections in the same way as the Command, and will receive the Event class that triggered the CommandMap, just as the Command eventually will.

The guard() method returns true or false. If all the guard() methods return true then the Command be instantiated and will run. If any guard() method returns false then the process is aborted.

**Are these like Haskell Guards?**

Kinda, maybe.

The inspiration for this CommandMap variation comes from the following blog post: http://blog.iconara.net/2008/03/30/separating-event-handling-from-event-filtering/

There is more discussion on guarding in general in the comments there.

Thanks to @AmyBlankenship for the suggestion.
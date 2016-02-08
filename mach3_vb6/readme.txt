
example using MACH 3 COM object from VB6.

note Mach3 must be running.

use Mach3Version3.042.020.exe from the ftp server. 

New versions dont properly register the COM objects in the registry.

The ScriptInterface and OEMCodes bits are only partial implementations.
Mach supports a ton of functionality, I have not explored it all yet.
this will get you started, post updates if you figure more out!

Note this exe does not have an interface, to early and to much typing.
Start it in the IDE, then hit pause, then experiment with it in the
immediate window or write your own code to do the tasks you desire.

this is free for any use.



One other note: there is apparent a bug in mach, it does not increment
the reference count on the Mach4.Document when you call GetObject() on it,
so I have to artifically increment so it doesnt unload when we are done with it.
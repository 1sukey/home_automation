
example using MACH 3 COM object from VB6.

should now work with any version of Mach3. Newer versions were missing
a registry key, it should detect and repair that automatically so it can
work correctly. 

The ScriptInterface and OEMCodes bits are only partial implementations.
Mach supports a ton of functionality, I have not explored it all yet.
this will get you started, post updates if you figure more out!

The main interface includes buttons to demo a few of the CMach
functions, but by no means all. The best way to play with this
is to open the source in the IDE, start it then hit pause. Now you can
experiment with it in the immediate window or write your own code 
as you desire.

this is free for any use.


One other note: there is apparent a bug in mach, it does not increment
the reference count on the Mach4.Document when you call GetObject() on it,
so I have to artifically increment so it doesnt unload when we are done with it.
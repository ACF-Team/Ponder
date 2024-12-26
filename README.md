# Ponder

This is a work-in-progress, in-game documentation system, heavily inspired by the Create Minecraft mod's "Pondering" system.
A couple of example storyboards are provided in lua/ponder/storyboards_cl/.

## For Other Addons
A simple "Open storyboard" button control is provided for you. You should include the lua/vgui/ponder_about.lua file in your addons source code. The control will automatically error-check and notify the user if Ponder is not installed on the server.
You should make new storyboards in a lua/ponder/storyboards_cl directory in your addon. Name them something unique, so they don't override other addons storyboards. If Ponder is installed, it automatically will load all files in that directory.

You create a new storyboard with Ponder.API.NewStoryboard(). The arguments are addon name, category name, and storyboard name. These three names have their spaces turned into dashes, then are merged into each other (and separated by dots) to form the UUID. For example, "Ponder", "Tests", and "Taking a Shower" as arguments translates to "ponder.tests.taking-a-shower".

Instructions are written to individual chapters in the storyboard. Chapter objects are created by calling Storyboard:Chapter(). You can have one or more chapters. 
Chapter:AddInstruction() writes an instruction to the current chapter. The length of a chapter is determined by the Chapter's Start Time + the last Instruction's Time + Length.
Instructions are, by default, concurrent. The only instruction that is not concurrent right now is the Delay instruction, which intentionally adds an offset to the StartTime.
All instructions have a Time and Length parameter (where the Length can be 0 for some instructions). Time is a time offset (that adds onto the Chapter's start time), and Length determines how long the instruction lasts. Different instructions handle Length differently (or don't handle it at all).

You can also create your own instructions by placing files in lua/ponder/instructions_cl/. The following methods are used in instructions, all of which have a single argument (a Ponder Playback object; see lua/ponder/classes_cl/playback.lua):

**First()**: Runs once Playback.Time >= Instruction.Time. Only runs once.
**Update()**: Runs while Playback.Time is inrange of Instruction.Time -> Instruction.Time + Instruction.Length. Will run one more time before Last() is called.
**Last()**: Runs once Playback.Time >= Instruction.Time + Instruction.Length. Only runs once.
**Render3D()**: Allows defining custom rendering behavior in the 3D context while the instruction is active (same conditions as Update)
**Render2D()**: Ditto, but runs in the 2D context

Hopefully, this explains things well enough; if it does not, feel free to [reach out here](https://discord.gg/jf4cwarPUG).

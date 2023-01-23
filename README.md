# rpr-theme - A theme song for the youtube channel, "Retro Positive Review", written in assembly 6502 for the NES (Nintendo Entertainment System).

Hail, fellow 8-bit enthusiasts! 

This project is an assembly file, which compiles to an .NES file, which plays the theme song (which I also wrote) for the YouTube channel "Retro Positive Review" (channel here: https://www.youtube.com/channel/UCr39KpVEjjbkz6Twl4WSEaQ_).

<h2>Building the project</h2>
To compile the file, use VASM (url here: http://sun.hasenbraten.de/vasm/), and use the following command: <br>
vasm6502_oldstyle_win32.exe "rpr-theme.asm" -chklabels -nocase -Dvasm=1  -DBuildNES=1 -Fbin -o "rpr-theme.nes"

<h2>What does rpr-theme.nes do? How do I play the song?</h2>
To play the song, you will need an NES emulator to load the digital "cartridge". I use Nestopia (http://nestopia.sourceforge.net/), although any emulator should work fine. Just download an appropriate emulator, then open the file using said emulator. Make sure your speakers are on! There are currently no graphics for the project, so all you'll see is a blank(black) screen.

<h2>Why 6502 Assembly? Why NES?</h2>
Initially, when I was tasked with writing a song for the channel, I thought it would be appropriate to make it in the format of an NES file/game, as the channel reviews classic movies and games, including NES games. As I happened to be learning 6502 assembly, it was the perfect opportunity to show off what I have learned so far!

<h2>Future plans for the rpr-theme</h2>
The end-product, while reminiscent of NES music of old, is fairly simple, and only uses 2 of the NES' 4 music channels. My intent is to return to this project in the future with a fully-formed NES sound engine, so that an even more polished version of the song can be released. I will also be adding a title screen/graphics to the project.



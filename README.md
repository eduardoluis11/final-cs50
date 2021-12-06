# GOLDEN HEART: A GAME MADE WITH LUA AND LOVE
#### Video Demo:  <URL HERE>
#### Description:

Copyright (c) 2021 Eduardo Salinas

Most of the code was written by Eduardo Salinas. The class.lua file and the sprites used are copyright of their respective owners. See the "references.txt" file to check this project's references, that is, to learn more about the sources cited for this project.
	
This is Golden Heart, a game made by Eduardo Salinas for CS50x’s Final Project Assignment.

##### A bit of background information:

I've wanted to make a 2D platformer with a focus on finding treasure since my very first CS50 assignment, that is, since the project that we had to do in Scratch. In fact, I originally wanted to add the final puzzle of this game into the Scratch project.

However, I soon realized that making the puzzle, as well as making the game as I wanted it to be was too complex and would have taken me too much time if I had done it on Scratch. The Scratch project was supposed to be a one-week project. However, to make my game as I wanted, it would have taken me way longer than that.

Therefore, I could say that Golden Heart, the game I’m submitting as my final project, is the fully realized version of the game that I originally envisioned for my very first homework assignment for CS50x’s class.

##### What this game is about:

Golden Heart is a 2D platformer in which you have to explore a castle and find all of its treasure. You will have to solve some basic puzzles to unlock some of the chests.

The game was heavily inspired by Wario Land.

To beat the game, you need to open all of the 5 treasure chests that are present in the game.


##### Controls:

- **Left and right arrow keys:** Move around.
- **Spacebar:** Jump.
- **E:** Enter through a door, activate a lever, open a chest.
- **Esc:** Exit the game.



##### System requirements:

**OS:** Windows 10, 64-bit.

**Storage:** less than 10 MB.




##### What each file in the source code does:

*1) graphics folder:*
 
This folder contains all of the sprites used in the game.

*2) Block.lua:*

This is the script for a gameplay mechanic that I ended up removing from the game. This script was going to allow me to create blocks that the player could pick up, throw, and use as platforms. This script currently doesn’t do anything. 

However, if I want to release this game to Steam or any other storefront in the future, and I want to add more stuff to the game, I will use this script and add more code to it to add the blocks to the game.

*3) Chest.lua:*

This is a class that allows me to create each instance of a treasure chest. Or in other words, this script allows me to add chests to the game.

*4) class.lua:*

This file was not made by me. It was made by Matthias Richter (see the credits section of this README file or the references.txt for more information.) This script allows me to create classes in Lua, since, by default, Lua doesn’t let me create classes. 

By creating classes, I could use Object Oriented Programming, which made it easier for me to create each individual chest, treasure, lever, among other things by writing efficient code. That is, this script allows me to create every chest or other similar object without needing to repeat code.

*5) Door.lua:*

This is the class that allows me to create the game’s doors.
	
*6) Entity.lua:*

This script creates the gravity and the collision detection. That is, it allows the player to fall after jumping, and to fall off a bottomless pit. It also prevents the player from falling through the floor.
	
It was also going to be a base class for all of the game’s objects (the player, the doors, the chests, the floor, etc,) but doing that caused many bugs to show up. So, I didn’t end up using it as a base class for the game’s objects.

*7) Floor.lua:*

This is the script that creates the floors in the game. Not to confuse it with the platforms. The floors and platforms have different sprites. The bottom of the floor sprites is purple or dark blue.

The sprite for the floor where the player is standing at the start of the game is the floor that this script corresponds to.

*8) GoldenHeart-1.0.zip:*

Here’s where the actual game is. That is, the executable file that allows you to play the game is located inside of this zip file.

This zip file has the .exe file with the game, and all of the code for LOVE 11.3 for 64-bit versions of Windows 10 machines. The entire code for LOVE 11.3 is needed so that the user is able to boot the game without needing to install LOVE on their computer.

The executable file that lets you play the game is called “GoldenHeart.exe”.

Please, DO NOT DELETE any of the files in this zip folder, and DO NOT RENAME any file (other than “GoldenHeart.exe”). Doing so will make an error message appear and the game won’t boot up any longer.  

*9) Lever.lua:*

This is the script that allows me to add levers into the game.

*10) main.lua:*

This is one of the most important files of the entire game.
	
This script allows the game to run on the LOVE game engine. This is where the load(), update, and draw() functions are located, and the file itself is needed to run the game in Love2D. Without a main.lua file, the game will display an error and won’t run.

Also, this file calls all of the other scripts to add all of the objects (the player, the chests, the floors, etc) into the game.

*11) Platform.lua:*

This creates the game’s platforms. Do not confuse the platforms with the game’s floors.

The platforms can be seen beginning from Room 1 and onwards. The sprites for the platforms are smaller than the floor ones. They don’t have any purple/dark blue color in them. The platforms' sprites are entirely reddish. 

*12) Player.lua:*

This is the script that contains all of the code of the playable character.

*13) references.txt:*

This contains all of the external sources used in the making of this game. Here, you will find the sources for the sprites, the class.lua file, and some code snippets that I used in this game that were not made by me. 

The same information in this file can be found at the bottom of the README file, as well as in credits.txt in the zip folder with the game’s executable file. 

*14) Stalactite.lua:*

This script has the class that allows me to add stalactites into the game.

*15) Treasure.lua:*

This is the script that allows me to add the individual treasures that you find inside of the chests. Do not confuse this script with the script that renders the actual chests. This script allows me to render, for instance, the ring and the armor that you can find on their respective chests, not the chests themselves.

*16) TreasureList.lua:*

This is the script for the UI that appears on top of the screen, which shows you each individual treasure that you have found thus far.

*17) Wall.lua:*

This is the script for another feature of the game that I ended up removing. I was going to add walls into the game which would prevent the player from moving out of the horizontal bounds of the screen.

I may use this script if I ever decide to make the game longer. However, this script currently doesn’t do anything.

 
##### Features removed from the game: 

###### Block mechanic:

I was going to originally let the player pick up blocks and throw them around so that they could stack them and use them as a platform. I was going to introduce those blocks in the game’s room 4. However, adding them was a bit too complicated for me, and the deadline for the project was near. 

To add the blocks, I would most likely have had to use Lua’s tables so that the blocks had collision detection. I needed the collision detection so that the player could have jumped on top of them so that they could use them as platforms to reach chests on high platforms. However, collision detection was already giving me a ton of problems. So, if I had added the blocks, I would have needed to modify the collision detection. That would have been too complicated with my limited knowledge in Lua. Also, adding that functionality would cause a ton of bugs, which would require me too much time to fix them.

Therefore, I decided to remove the block mechanic entirely. In room 4, I decided to replace the blocks for a lever that spawns stalactites to be used as platforms.

However, if I decide to revisit the game, I may add the block mechanic.

###### Walls:

I was going to add walls to each room to prevent the player from going outside the horizontal boundaries of the rooms. However, just like with the blocks, I had issues with the collision detection, which caused me a ton of bugs.

I will be adding walls to the game if I ever update it and add more rooms and levels to it.

##### Credits and references:

Here are all of the external sources used for creating this game. You’ll also find this information in the references.txt and credits.txt files, which are included in the game’s source code.

###### Sprites and backgrounds' references:

I downloaded sprites and backgrounds from the following sources:


- 0x72. (2017). 16x16 dungeon tileset by 0x72. 0x72. Retrieved November 30, 2021, from 
https://0x72.itch.io/16x16-dungeon-tileset. 

- ansimuz. (2017, April 10). Caverns environment by Ansimuz. ansimuz. Retrieved November 
30, 2021, from https://ansimuz.itch.io/caverns-environment. 

- BlackSpire Studio. (2018). Medieval pixel art asset free by Blackspire Studio. BlackSpire 
Studio. Retrieved November 30, 2021, from 
https://blackspirestudio.itch.io/medieval-pixel-art-asset-free. 

- greatdocbrown. (2020, July 21). Coins &amp; Gems &amp; Chests &amp; etc by Greatdocbrown. 
greatdocbrown. Retrieved November 30, 2021, from https://greatdocbrown.itch.io/coins-gems-etc. 

- Kyrise. (2018). Kyrise's free 16x16 RPG icon pack by Kyrise. Kyrise's Game Assets. Retrieved 
November 30, 2021, from https://kyrise.itch.io/kyrises-free-16x16-rpg-icon-pack. This sprite 
pack is licensed under CC BY 4.0: https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1

- Lil Cthulhu. (2021, May 21). Animated pixel character by Lil Cthulhu. Lil Cthulhu. Retrieved 
November 30, 2021, from https://lil-cthulhu.itch.io/animated-pixel-charackter. 

- Raou. (2020, June 8). Free dungeon mini-tileset by Raou. Raou. Retrieved November 30, 2021, 
from https://raou.itch.io/free-dungeon-mini-tileset. 

- RottingPixels. (2019, July 1). Cave platformer tileset [16x16][free] by RottingPixels. 
RottingPixels. Retrieved November 30, 2021, from 
https://rottingpixels.itch.io/cave-platformer-tileset-16x16free. 

- RottingPixels. (2019, June 23). Dungeon platformer tileset [16x16][free] by RottingPixels. 
RottingPixels. Retrieved November 30, 2021, from 
https://rottingpixels.itch.io/platformer-dungeon-tileset. 



###### Code references: 

I took code snippets or anything else related to code from these sources:

- (2018). Breakout - Lecture 2 - CS50's Introduction to Game Development 2018. 
Retrieved November 30, 2021, from https://www.youtube.com/watch?v=F86edI_EF3s. 

- (2018). Flappy Bird - Lecture 1 - CS50's Introduction to Game Development 2018. 
Retrieved November 30, 2021, from https://youtu.be/3IdOCxHGMIo. 

- Ensayia . (2012). Default Screen Size. LÖVE - Free 2D Game Engine. Retrieved 
November 30, 2021, from 
https://love2d.org/forums/viewtopic.php?t=8995#:~:text=Re%3A%20Default%20Screen%20Size&amp;text=With%20no%20config%20file%20specifying,is%20the%201344x768%20widescreen%20variant. I learned Love2D's default window resolution thanks to Ensayia's post.

- Jasoco. (2012). Bugs When Window Is Moved. LÖVE - Free 2D Game Engine. Retrieved 
November 30, 2021, from https://love2d.org/forums/viewtopic.php?t=8740. I used 
a code snippet from Jasoco's post.

- Jasoco. (2013, December 23). Game runs too fast on a laptop? LÖVE - Free 2D Game 
Engine. Retrieved November 30, 2021, from 
https://love2d.org/forums/viewtopic.php?t=76758. I learned how to use delta time 
thanks to Jasoco's post.

- Kankaanpaa, H. (2015). Doing game gravity right. OpenArena. Retrieved November 
30, 2021, from http://openarena.ws/board/index.php?topic=5100.0. I used "delta 
time / 2" in my code thanks to GrosBedo's post citing Hannu Kankaanpaa about 
how to use delta time.

- KeyConstant. LOVE. (2021, March 2). Retrieved November 30, 2021, from 
https://love2d.org/wiki/KeyConstant. I learned how to access the space bar key 
in Love2D from here.

- Richter, M. (2018). class.lua. CS50’s Introduction to Game Development. computer 
software. Retrieved November 30, 2021, from 
http://cdn.cs50.net/games/2018/spring/lectures/1/src1.zip. 

- Sheepolution. (n.d.). Chapter 23 - Resolving collision. Sheepolution. Retrieved 
November 30, 2021, from https://sheepolution.com/learn/book/23. 

- Sheepolution. (n.d.). Chapter 24 - Platformer. Sheepolution. Retrieved November 
30, 2021, from https://sheepolution.com/learn/book/24. 

- Sheepolution. (n.d.). Chapter 7 - Tables and for-loops. Sheepolution. Retrieved 
November 30, 2021, from https://sheepolution.com/learn/book/7. 

- Sheepolution. (n.d.). Chapter 8 - Objects. Sheepolution. Retrieved November 30, 
2021, from https://sheepolution.com/learn/book/8. 
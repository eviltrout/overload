## Information Overload

Information Overload is a game I built in ActionScript within a few days work. The game is on Kongregate if you want to try it out:

[Play Information Overload](http://www.kongregate.com/games/EvilTrout/information-overload)

Here's the description from there:

Did you know there’s more information being created in a second than you could consume in your entire lifetime?

Information Overload is a retro-style shooter based on a simple concept: information is flowing through the series of tubes that is the Internet, and it is threatening to overwhelm you. Shoot it! Shoot it all!

The information in the game is gathered from dozens live sources, including Twitter, Google News and many of the world’s top newspapers and blogs.

### About this Source

This source code is the game exactly as it is on Kongregate with the exception of the music which I licensed from iStockPhoto. The art was contracted for the project by the excellent Camdoggery who has also helped with my other site, Forumwarz.com.

It relies heavily on [Flixel](http://flixel.org/), which is an excellent library for creating Flash games. The version included in this project is out of date though, as I made most of the game in late 2009 over Christmas. Check out the official site for a newer and greater version.

It also uses the excellent [Tweener](http://code.google.com/p/tweener/) library for doing tweening. It's been included with the source.

The rest of the code was built by yours truly. Feel free to learn from it or reuse to your pleasure.

### How to compile

You need a copy of the Flex SDK to compile the source. It's fortunately available for free and you don't need an expensive copy of Flash or anything.
Just download it from Adobe and then type:

mxmlc -target-player=10.0 Overload.as

to compile on the command line. It'll spit out a SWF file you can open in your browser. 

I have included two trivial sh scripts I used for compiling that you should be able to use out of the box if you're on a Mac. ./compile_test will compile and open the swf in the flash standalone player if you have it installed. ./compile_test_browser will open it in your browser of choice.

### Contact Me

I'm eviltrout on github. You can find my personal site at [eviltrout.com](http://eviltrout.com)

You might also want to try out my web based MMO, [Forumwarz](http://www.forumwarz.com)

I hope you enjoy the source and find it useful in some respect!

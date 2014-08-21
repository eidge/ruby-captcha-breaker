Ruby Captcha Solver
====================

Ever wondered how to solve a captcha? Do you think **Ruby could do it**?

These were the questions I set out to answer.

Turns out that Ruby is quite slow, but as so many other interpreted languages, it has binds for powerful libraries written in C and the likes. This means you get to enjoy the simplicity of Ruby and the speed of a compiled language for the tasks that matter.

I've choosen a simple catcha used by the [NOAA](http://www.noaa.gov/) service to protect their service from automated requests. I really like this for meteo forecasts (I'm a paraglider pilot), but the god damn captchas are so annoying!

![alt tag](https://raw.github.com/username/projectname/branch/path/to/img.png)

This is the victim.

1. First I fill everything that's white with black - this removes the breaks in the letters we're supposed to read.
2. Then I turn the image into a binary image (only black and white).
3. It's then time to erode the image 3 times - Eroding means that the outer black pixels of the letters will become white, since the noise letters are thinner they'll disappear.
4. In the end I dilate the image 4 times to make it ready for tessaract to read the caracters - dilating is the opposite of eroding, so the white pixels adjacent to a black pixel become black as well. This just restores the wheight of the font.
5. Ask tessaract to read the charactes and *voi la*, we've solved a captcha.

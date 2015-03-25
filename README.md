Ivory
=====

Ivory is a simple web browser written in the Vala programming language.
Its aim is to provide both simple usage of the basic web browsing features
and a layer of mechanisms providing maximum efficiency for power users.

At this point ivory is in a very early stage of development and most of
the planned features are not yet implemented.

Planned features
----------------

 * Facilities for testing the user interface
 * Advanced keybindings similar to the Vimperator plugin for firefox
 * Regular expression search on websites
 * An efficient bookmarking facility

Hackability
-----------

Ivory needs to stay hackable. The code needs to be clean, concise and
well documented. I started this project to personalize my web browsing
experience from the ground up. Ivory should serve as a foundation
for people wanting to do the same.

Building ivory
--------------

Ivory depends on GTK+ with at least version 3.16. As far as i know no
major (non-meta) distribution is using this version at this point so
you have to build GTK+ from git. Fortunately the jhbuild utility eases
this a lot.
```bash
$ jhbuild build gtk+
```
should do the job. By default jhbuild installs built modules into
`$HOME/jhbuild/install` so you need to adjust your `PKG_CONFIG_PATH`
accordingly during configure-time.
```bash
$ export PKG_CONFIG_PATH="$HOME/jhbuild/install/lib/pkgconfig/"
```
Now you can build ivory using
```bash
$ ./configure && make
```

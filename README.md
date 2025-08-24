# GAMEJAM STARTING POINT

## CODE STRUCTURE
### DATA
This module contains *mostly* static data about elements of the game.This can include objects in the game, and even scenes. Any helper functions that this data needs to provide lives in this module as well.
### ENGINE
This module contains the setup/gameplay loop logic necessary for the game to work.
### UI
This module contains *components* (which are just functions) That are used by scenes.
### VIEW
This module handles actually drawing to the screen. Provides a few primitives (called render-commands) which the codebase can use to draw to the screen.

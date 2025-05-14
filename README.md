# Simple Cards

I am working on my own card game and i did not see any addon that does what I wanted so I made my own.

## Main Features
Cards with clean amimations using shaders or tweens.
//TODO: Add gif here

Modularity by using reusable resources.
//TODO: Add gif here

## How it works
!Don't forget to enable the plugin!

Use the example scene to get an idea of how it works.

### Cards
Create a new card using the 'create new node screen'.
In the inspector add or create a card resource. Adjust the other parameters to you liking.

#### Functionality
Left click to drag and drop the card
Right Click the card to flip it to the front face; if its alread on the front face, right click will play the effects instead.
play_key (Default: "ui_accept") can be also used to play the card (must be on front face).

use play_card() function to trigger the activation of the card if needed in other places.

### Card Resources
They hold the information of the card. Every card node needs a resource to function properly.
To set up a resource you'lln need:
Card Face - the texture of the front/face of the card
Card Back - the texture of the bakc of the card
Card Descrption - (optional) a descrpition of what the card does
Effects - an array of effect resources

### Effect Resources
Effects are responsible for the interation betweeen cards and the rest of the scene.
In a resoruces will be triggered top to bottom (0 -> 99) and they can be as simple or complex you want

To create a new effect, create a new script that extends EffectResource, give it a class name and create the use function.

"func use(card)" is the triggered function when the card is played; this is where the main logic should be.
You can also add exported varialbels or anything that helps :)
//TODO Add Photos of example

### Card Global
This is a global script that manages some settings or special functions:
use_shadows - if true will generate a shadown texture node on the cards. added for performance/quality settings
use_tooltips - will use the godot default tooltip for showing descriptions on hovering the cards
play_key - used to play the card, default is "ui_accept" change it for you needs leave it empty if not used.

### Card Texture
Extends TextureRect and its used for handling the shader and the flip animation

## To Do
Im still preaty new to this so its not perfect, but im quite happy with how it is right now.
There are still a few things i want to get done in the future:
- Proper documentation
- Hand/Field/Slot System
- More customization

## Creddits
### main assets
- Perspective Shader by miniponti - (https://godotshaders.com/shader/3d-perspective-texturerect-with-touch/)
- Custom Nodes Icons by pixel_boy - (https://pixel-boy.itch.io/icon-godot-node) 

### example project
- Pixel Protagonist by Penzilla - (https://penzilla.itch.io/protagonist-character)
- Pixel Playing Cards by Yewbi/unbent - (https://unbent.itch.io/yewbi-playing-card-set-1)

# Breakout Project
Voor het OLOD "Native apps II: mobile apps voor IOS" kreeg ik de opdracht om zelf een IOS app uit te werken.
Ik heb gekozen om de bekende Breakout game te hermaken.
## Screens

* Navigation Controller
* Start screen met auto layout en size klassen
* Game screen met SpriteKit + GameOver screen
* Highscore screen met auto layout en size klassen
* ChangeLog screen met UITableViewController

## The Game

Wanneer juist gestart ligt het balletje op de paddle, de paddle kan verschoven worden door het te verslepen.
Als je voor het eerst de paddle aanraakt zal het spel beginnen, het balletje mag nooit de onderkant van het scherm raken.
Je kan het level uitspelen door alle blokjes 1x te raken met het balletje, bij elke aanraking zal het blokje/laag weggebroken worden.

Er zijn 5 levels, elk level voegt een extra laag op het blokje toe.
Hierdoor wordt elke level moeilijker en moeilijker om uit te spelen.

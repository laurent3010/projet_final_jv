#Laurent Le Bot Beaupré
## peter de geneoux 2022

ce projet consiste en un preuve de concept que godot peut faire un jeux en multi joueur pour apprendre comment le jeu se comportais dans les cas de server et de client.
j'ai remarqué que l'on devais utilisé le adresse ipv4 comme dans le jeu diablo 2.

la capacité a un jeu a être en multijoueurs peut modifier tout les aspect du jeu, car de la maniere que je l'ai codé. Chaque joueur a une instance du jeu et ils s'envoie des
packet pour metre a jour la positions des differents personnagedonc donc chaque instance de joueurs dans le jeu doit savoir si il est le proprietaire du joueurs pour pouvoir
utilisé ces fonctionalité. il ne faudrais pas que joueur 2 mimique les mouvement de joueur 1car il croie être la meme instance.

nous utilisons le concept de serveur et de client pour connaitre qui doit se connecté a qui dans le jeu le serveur inicialise le jeu et le client doit seconnecté de maniere
manuel en rentrans l'adresse ip wifi du server une fois les joueurs connect ils attende dans le loby que le joueur serveur commence le jeu en apuyant sur le bouton "start game"

dans ce la lumiere est utilisé surprendre les autres joueurs et faire des attaques surprise. chaque joueur a une petite aura autour d'eu qui éclaire le décore chaque joueur
ne voit pa l'aura des autre joueur. et apuyer sur "e" fait grosir l'aura pendant une courte periode et apres la capacté a un cooldown de 5 seconde 

ce model de client server a été insporé de la série de tutoriel YouTube réalisé par [PlugWorld](https://www.youtube.com/watch?v=lpkaMKE081M&list=PL6bQeQE-ybqDmGuN7Nz4ZbTAqyCMyEHQa&index=1)

les decors et le personage utilisé dans mon jeu on été inspiré de la série de tu toriel YouTube [HeartBeat](https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a)

les lumiere ont été inspiré de la video [2D Lighting and Day&Night cycle in under 5 minutes! Godot 3.2 Tutorial](https://www.youtube.com/watch?v=j_FMsL_ru1w&t=143s)


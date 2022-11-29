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

#server en attante

<table>
    <tr>
        <td>
            <figure>
                <img src="image_de_présentation/lobby _de_base.jpg"/>
                <figcaption>Figure 1 : le sereur en attente de joueur</figcaption>
            </figure>
        </td>
        <td>
            <figure>
                <img src="image_de_présentation/lobby_complet.jpg"/>
                <figcaption>Figure 2 : tout les joueur sont la et la parti est prete a être lancer</figcaption>
            </figure>
        </td>
    </tr>
</table>

#in game mecanique

<table>
    <tr>
        <td>
            <figure>
                <img src="image_de_présentation/in_game_normal.jpg"/>
                <figcaption>Figure 1 : les joueur sont tout les deux dans le noir et il faut chercher les autre joueurs pour les tuer en un coup.</figcaption>
            </figure>
        </td>
        <td>
            <figure>
                <img src="image_de_présentation/Capture d’écran (42).png"/>
                <figcaption>Figure 2 :les joueurs peuvent appuyer sur "E" pour acivé une capacité pour voir plus loing et avoir des informations pour surprendre l'adversaire.</figcaption>
            </figure>
        </td>
    </tr>
</table>

##manuel de jeu 

-pour commencé les joueurs entre un nom dans le text edit "entré un username"

-ensuite choisisé entre crée un server ou rejoindre un server

-crée un server crée un lobby et vous attendez des joueur en essayant les diferant mouvemant du persoonage

-le boutton rejoindre un server vous amene dans une page pour trouvé un server la recherche automatique est actuelement hors d'usage donc utilisé le bouton manuel 

# si vous le testé avec l'I.D.E godot et non en executable .exe assurez vous que les export sont telechargé 

  <figure>
    <img src="image_de_présentation/Capture d’écran (43).png"/>
    <figcaption>Figure 1 : si le texte est rouge comme sur l'image suivre la [video](https://www.youtube.com/watch?v=9WwKs3q-ebo) si jointe apartir de 24:00 minute. cela evite les erreur de port deja pris </figcaption>
  </figure>

-pour la connection manuel rentré ladress ipv4 wifi du server et clicker sur le bouton join lance le jeu dans le loby du server  

-une foit tout les joueur arrivé le serveur lance le jeu en clican sur le bouton start game 

a noté que si vous voulez changer le nombre de  joueur maximal il y a une variable dans lefichier network qui gere le nombre de client maximal priere de ne pas depassé 4 car le jeu nes pas fait pour plus 

les regle jeu sont simple 
- vous ete dans le noir cherchez les autre joueur et tues les il peuve respawn a l'infini dans le jeu mais il peuve aussi quité sa que ce soit notifier 

finalement le debug mode s'active en apuyan sur "g"

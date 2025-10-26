# Rising Sun  
A fast-paced 2-player reflex game built in Godot for Knight Hacks VIII (2025)

---

## Overview  
Rising Sun is a competitive local 2-player reflex game where speed, timing, and precision determine victory.  
Each round, both players are given a randomly generated sequence of keys to press before the timer expires.  
The first player to complete their sequence—or the one with the fewest mistakes when time runs out—wins the round.  

Built entirely during the Knight Hacks VIII hackathon, Rising Sun showcases real-time input handling, smooth UI feedback, dynamic camera shake, and a complete game loop created from scratch in Godot 4.x.

---

## Contributors  
- Justin Suriel  
- Luke Kacerowski  
- Mustapha Strachan

---

## Core Features  
- Randomized key sequences for both players each round  
- Round timer that scales with difficulty and ends early if both finish  
- Real-time input validation with animated feedback  
- Camera shake and sound effects for hits and misses  
- Seamless scene transitions (Main Menu → Gameplay → Results)  
- Results screen that displays the winner and allows replay or exit  

---

## Gameplay Summary  
1. Both players are shown their unique randomized key sequences.  
2. They must input the sequence as fast and accurately as possible.  
3. The round ends when both players finish or the timer expires.  
4. The Results Screen displays the winner and options to play again or return to the menu.

---

## Controls  
| Player | Keys | Description |
|:--------|:-----|:-------------|
| Player 1 | Q W E A S Y | Follow on-screen sequence prompts |
| Player 2 | U I O J K L | Follow on-screen sequence prompts |
| Both | Random each round | Sequences are generated dynamically |

---

## Project Structure  
/ (root)
├─ Scenes/
│  ├─ main_menu.tscn
│  ├─ gameplay.tscn
│  ├─ results.tscn
│  ├─ how_to_play.tscn
│  └─ transitions/
│
├─ Scripts/
│  ├─ GameManager.gd          # Manages scene switching and overall game state
│  ├─ GameplayController.gd   # Core round logic, player state, and scoring
│  ├─ SequenceDirector.gd     # Generates random key sequences and timers
│  ├─ SequencePromptUI.gd     # Displays player sequences and validates inputs
│  ├─ CameraShake.gd          # Applies screen shake on hits or damage
│  └─ Results.gd              # Displays winner info and menu/replay options
│
├─ art/                       # UI elements, sprites, and background art
├─ audio/                     # Sound effects and background music
└─ README.md

---

## Technology Stack  
- Engine: Godot 4.x  
- Language: GDScript  
- Version Control: Git + GitHub  
- Platforms: Windows / macOS / Linux  

---

## Getting Started  
1. Clone the repository:  
   git clone https://github.com/LukeKacprowski/Knight-Hacks-VIII-Project.git  
2. Open the project in Godot 4.x.  
3. In Project → Project Settings → Run, set Scenes/main_menu.tscn as the main scene.  
4. Press Play to begin.  

---

## Feedback and Effects  
- Camera shake triggers on player damage or failed inputs.  
- Sound effects play on successful hits, misses, and transitions.  
- The UI highlights sequence progress in real time for each player.  

---

## Hackathon Context  
Developed collaboratively in under 36 hours for Knight Hacks VIII (2025).  
Rising Sun demonstrates teamwork, rapid prototyping, and a complete gameplay experience built from the ground up.  
The project focuses on responsive player input, procedural UI generation, and seamless round-to-round transitions.  

---

## License  
This project is open-source under the MIT License.

---

## Contact  
For questions or collaboration opportunities:  
- Justin Suriel – linkedin.com/in/justin-suriel-972987334  
- Luke Kacerowski  
- Mustapha Strachan  

---

"The sun rises on every new challenge — mash fast, rise faster."


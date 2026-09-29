# All on Red ♠️♥️♦️♣️

![Godot Engine](https://img.shields.io/badge/Engine-Godot%204.4-blue.svg)
![Python](https://img.shields.io/badge/Language-Python%203.12-yellow.svg)
![GDScript](https://img.shields.io/badge/Language-GDScript-teal.svg)
![GenAI](https://img.shields.io/badge/AI-Google%20Gemini-orange.svg)
![GDExtension](https://img.shields.io/badge/Bridge-py4godot-green.svg)

An AI-driven Texas Hold'em poker game engineered as the A-Level Computer Science NEA (Non-Exam Assessment) capstone project. 

*All on Red* bridges modern game engine design with advanced scientific computing and natural language processing, linking **Godot 4.4** with **Python 3.12** through **py4godot (GDExtension)** and integrating the **Google Gemini Generative AI API** for dynamic, contextual opponent decision-making.

---

## Key Features

### 1. Hybrid Engine Architecture (Godot 4 + Python via GDExtension)
- Utilizes **py4godot** to bind the Godot 4 C++ core with a full Python 3.12 runtime.
- Decouples UI rendering, particle effects, card animation timelines (`AnimationPlayer`), and audio buses (in GDScript) from backend game state calculations and artificial intelligence routines (in Python).

### 2. LLM-Powered Adaptive Opponent (Google Gemini GenAI)
- Transcends standard hardcoded poker bots by interfacing with **Google Gemini (`google-generativeai`)**.
- Supplies real-time game telemetry—pot sizes, hand strength, board texture, betting history, and position—to generate context-aware opponent moves (checks, value bets, aggressive raises, folds).
- Employs dynamic conversational responses and bluffing behaviors based on table momentum.

### 3. Rigorous Combinatorial Hand Evaluation
- Integrates the **Deuces** poker evaluation library, utilizing bitwise representation and lookups to evaluate 5-to-7 card combinations into distinct hand ranks (High Card to Royal Flush) in microsecond timeframes.
- Calculates pot odds and expected equity during live betting rounds.

### 4. Complete Casino Wagering & Mission System
- Implements full Texas Hold'em betting rounds: Pre-flop, Flop, Turn, and River with automatic Small/Big Blind rotation.
- **Mission Progression Engine:** Custom quest architecture (`MissionHandler.gd`) providing objectives, chip rewards, and achievement tracking.
- **Persistence & Configuration:** Local state serialization (`user://chipData.dat`) to store bankroll, settings, and player milestones between sessions.
- **Interactive UI/UX:** Responsive chip betting sliders, card dealing animations, and dedicated audio effects for checks, chips, and victories.

---

## Project Structure

```
all_on_red/
├── project.godot               # Godot 4.4 Engine configuration & autoload singletons
├── export_presets.cfg          # Windows & desktop build configurations
├── .env.example                # Template for Gemini API credentials
├── scenes/
│   ├── main_game.tscn          # Main poker table environment & UI
│   ├── main_menu.tscn          # Title screen & navigation
│   ├── choice_ui.tscn          # Interactive action buttons (Fold, Check, Bet, Call)
│   └── setting_menu.tscn       # Audio, display, and configuration options
├── scripts/
│   ├── poker_game_processing.py # Python backend: game loop, Gemini API, Deuces evaluation
│   ├── ChipHandler.gd          # Autoload: bankroll management & pot animations
│   ├── MissionHandler.gd       # Autoload: quest generation and objective validation
│   ├── configFileHandler.gd    # Settings file parser and serializer
│   ├── bet_slider.gd           # Interactive wager slider controller
│   └── card.gd                 # Card flipping animations & sprite assignment
└── assets/                     # Card decks, casino chips, UI icons, and audio streams
```

---

## Getting Started

### Prerequisites
- **Godot Engine 4.4 (Forward+ or Mobile)**
- **Python 3.12+**
- A **Google Gemini API Key** (available from Google AI Studio)

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Brickcat5881/All-on-Red.git
   cd All-on-Red
   ```

2. **Configure API Credentials:**
   Create a `.env` file in the project root:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

3. **Open in Godot:**
   - Launch Godot 4.4.
   - Click **Import** and navigate to `project.godot`.
   - Ensure the `py4godot` GDExtension addon is active under **Project $\to$ Project Settings $\to$ Plugins**.
   - Press **F5** to run the project.

---

## Technical Highlights for Reviewers

- **Cross-Language Bindings:** Demonstrates proficiency in bridging separate programming paradigms (static engine hierarchy vs. dynamic Python scientific stack).
- **Prompt Engineering & Structured Outputs:** Strict schema design prompting the LLM to return machine-readable actions and reasoning strings without breaking gameplay execution.
- **Combinatorics & Algorithms:** Efficient implementation of discrete card shuffling, dealing, and hand ranking algorithms without redundant permutations.

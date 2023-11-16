# Rules
- 3 mana per round
- start: 5 cards, can discard each card once to draw new random card
- turn start: draw 2 cards, up to a total of 7
- if card pile is empty, shuffle discard pile and add to card pile

# Concepts
- each mana equals 10 damage value (as framework)

# Card Effects

## Basic Effects
- Deal x damage
- Receive x damage
- Gain x Block
- Draw x cards
- Heal x hit points
- Remove x Block

## Conditionals (represented by glowy card border when active)
- Less than x% hit points (self/enemy)
- Enemy *Intent*
- Own card types (in deck / on hand)

## Status Effects
- effect always on turn start
- Toxin: deals 3 damage for every turn remaining. Maximum of 5 stacks.
- Slow: attacks deal 25% less damage for x turns.
- Block: attack damage is decreased by your Block before your hit points. removed at the start of your turn.
- Empower: attacks deal 25% more damage for x turns.

## Cards

### Spider
- Web (1, Utility): Applies 2 turns of *Slowed*.
- Venomous Bite (2, Offensive): applies 2 stacks of *Toxin*, deal 4 damage.
- Arachnophobia (1, Defensive): Gain 10 *Block*. 

### Snake
- Antidote (1, Utility): removes 3 stacks of *Toxin*, draw 1 card.
- Snake Oil (3, Utility): Heal 20 hit points.
- Venomous Bite (2, Offensive): applies 2 stacks of *Toxin*, deal 4 damage.

### Deer
- Antler Barrier (2, Defensive): Gain 12 Block. If the enemy attacks, deal 10 damage to them. 
- Reckless Charge (1, Offensive): Deal 17 damage, receive 5 damage.
- Stomp (2, Offensive): Deal 22 Damage.

### Squirrel
- Dodge (1, Defensive): Gain 4 Block. Draw 1 card.
- Nutcracker (1, Offensive): Remove 12 Block. Heal 3 hit points.
- Stockpile (2, Utility). Gain 4 turns of *Empowered*.

### Fox
- Fox Bite (3, Offensive): Deal 7 damage for every card on your hand.
- Take Heart (2, Defensive): Heal 12 hit points. If below 50% hit points, heal for 18 hit points instead.
- Fox's Cunning (1, Utility): Draw 3 Cards.

# Enemy Design
- Intent: next move, classified as offensive, defensive, utility (color coded)
- less hit points than player
- single health bar, which can represent multiple entities (squad of frogs, different types of animals, etc)

# Example Level
- Deck: 2 copies of each animal, except fox (1 copy each) and snake (0 copies)
- Own Hit Points: 100 
- Enemy: Squad of 3 frogs 
    - 75 hit points 
    - moveset:
        - Tongue Lash (Offensive): Deal 22 damage. Applies 1 turn of *Slowed*.
        - Toxic Mucus (Defensive): Gain 15 Block. Apply 2 stacks of *Toxin*.
        - Frog's Chorus (Utility): Gain Empowered for 3 turns. Removes 2 stacks of *Toxin*.
- post-battle options:
    - recruit: Add 1 frog to your party. (Frog cards / bridge sprite unimportant right now)
    - chase them off: Heal 10 hit points, gain a flute. (You can use the flute to unlock the snake)
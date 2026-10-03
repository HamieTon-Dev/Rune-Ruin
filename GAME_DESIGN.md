\# Rune \& Ruin

\## Master Game Design \& Development Specification



\## 1. Project Vision



\*\*Rune \& Ruin\*\* is a top-down 3D fantasy action MMORPG designed primarily for \*\*Android\*\*, with a future \*\*Windows/Steam\*\* release.



The game combines:



\- Magic-focused fantasy combat

\- Medieval melee weapons

\- Three opposing factions

\- Six playable classes

\- Three specializations/subclasses per class

\- Large explorable fantasy regions

\- PvE and PvP

\- Quests

\- Dungeons

\- Raids

\- Bosses

\- Guilds

\- Character customization

\- Equipment progression

\- Crafting

\- Faction conflict

\- Persistent characters

\- Large cities, villages, temples, forests, ruins, caves, and wilderness

\- Mobile-first controls

\- Future server-authoritative MMO architecture



The visual direction should feel like a \*\*premium fantasy RPG\*\*, not a generic mobile game.



The world should emphasize:



\*\*Magic, ancient runes, ruined civilizations, faction rivalry, forgotten gods, arcane corruption, and medieval warfare.\*\*



\---



\# 2. Core Technical Direction



\## Engine



Godot 4



\## Language



GDScript



\## Primary Platform



Android / Google Play



\## Secondary Platform



Windows / Steam



\## Camera



Top-down / elevated third-person 3D.



The camera should:



\- Follow the player smoothly

\- Allow rotation

\- Allow limited zoom

\- Keep combat readable

\- Work well on small Android screens

\- Avoid extremely low camera angles

\- Avoid obstruction by buildings and large trees

\- Eventually support automatic transparency/fading of objects blocking the player



\---



\# 3. Development Philosophy



Build Rune \& Ruin as a \*\*local playable RPG first\*\*, but architect systems so they can later be migrated to authoritative MMO servers.



Do NOT attempt to create every MMO system at once.



Systems should be modular.



Major systems should communicate through well-defined interfaces rather than tightly coupling everything together.



Examples:



```text

PlayerInput

CombatSystem

AbilitySystem

CharacterStats

InventorySystem

EquipmentSystem

QuestSystem

FactionSystem

NPCSystem

WorldSystem

PersistenceSystem

NetworkSystem

PlatformServices

```



The game should work locally during development without requiring a remote server.



Later:



```text

LocalPersistence

&#x20;       â†“ replaced by

ServerPersistence



LocalCombatAuthority

&#x20;       â†“ replaced by

ServerCombatAuthority

```



Do not write gameplay systems in a way that makes this migration impossible.



\---



\# 4. Server-Ready Architecture



When multiplayer/server development begins, the server becomes authoritative.



The client must eventually NOT be trusted to determine:



\- Damage

\- Healing

\- XP

\- Currency

\- Loot

\- Inventory quantities

\- Item generation

\- Quest completion

\- Character position validity

\- Crafting results

\- Equipment validation

\- PvP results

\- Boss rewards

\- Guild data

\- Marketplace transactions




During local development these may temporarily run locally through an abstraction layer.



\---



\# 5. The Three Factions



Rune \& Ruin contains three major factions.



\## Humans



Theme:



\- Medieval kingdoms

\- Arcane scholarship

\- Stone castles

\- Cathedrals

\- Arcane academies

\- Organized military

\- Large farms

\- Merchant districts



Architecture:



\- Stone

\- Marble

\- Timber

\- Towers

\- Arcane crystals

\- Defensive walls



Human culture should feel organized and prosperous but politically divided.



\---



\## Orcs



Theme:



\- Warrior clans

\- Shamanic magic

\- Honor

\- Tribal alliances

\- Ancient fortresses

\- Volcanic regions

\- Heavy weapons



Architecture:



\- Dark stone

\- Massive timber structures

\- Iron

\- Bone decoration

\- Large fortifications

\- Braziers

\- Rune-carved monoliths



Orcs should not simply be portrayed as unintelligent enemies.



They have their own civilization, traditions, religion, warriors, scholars, and magical practices.



\---



\## Goblins



Theme:



\- Alchemy

\- Trickery

\- Improvised magic

\- Engineering

\- Trading

\- Underground settlements

\- Swamps

\- Forest settlements



Architecture:



\- Wood

\- Copper

\- Mechanical devices

\- Strange magical machinery

\- Rope bridges

\- Underground chambers

\- Alchemy labs



Goblin civilization should feel chaotic but clever.



\---



\# 6. Character Creation



Players select:



1\. Faction

2\. Character appearance

3\. Character name

4\. Starting class

5\. Starting location



Each faction should have faction-specific customization.



\## Customization Options



Examples:



\- Skin color

\- Face shape

\- Eye color

\- Eye shape

\- Hair

\- Hair color

\- Facial hair where applicable

\- Ear shape

\- Scars

\- Tattoos

\- War paint

\- Body type

\- Base clothing

\- Voice set eventually



Faction-specific examples:



\### Goblins



\- Green

\- Yellow-green

\- Grey-green

\- Brown-green

\- Dark emerald skin

\- Long ears

\- Short ears

\- Bent ears

\- Large nose

\- Small nose

\- Different eye colors



\### Orcs



\- Green

\- Grey

\- Dark green

\- Brown

\- Red-brown

\- Tusks

\- War paint

\- Scars

\- Different jaw structures



\### Humans



\- Multiple realistic skin tones

\- Hair styles

\- Beards

\- Facial structure

\- Tattoos

\- Scars



\---



\# 7. Account Identity



Initial Android account architecture should support Google Play Games.



Conceptually:



```text

Google Play Games Account

&#x20;       â†“

Rune \& Ruin Account

&#x20;       â†“

Characters

```



Do not rely only on the visible Google Play username as a permanent database identifier.



Use a stable internal account identifier.



Displayed identity can eventually appear as something like:



```text

CharacterName

GuildName

AccountDisplayName

```



Example:



```text

Thalorin

<Order of Embers>

HamiltonDev

```



Avoid displaying an enormous concatenated username during normal gameplay.



\---



\# 8. Classes



There are six primary classes available to all factions.



Each class should eventually contain three specializations.



Classes should share the same mechanical identity across factions while armor, animations, effects, and lore may vary.



\---



\# 9. Rogue



Role:



Fast melee damage, stealth, mobility, ambushes, poison, and critical strikes.



Primary weapons:



\- Daggers

\- Short swords

\- Dual blades

\- Small crossbows eventually



Primary resource:



Energy



\## Rogue Specialization 1 â€” Shadowblade



Stealth and assassination.



Abilities:



\### Backstab



Massive damage when attacking from behind.



Bonus damage while stealthed.



\### Vanish



Enter stealth during combat.



\### Shadowstep



Teleport or quickly dash behind a nearby target.



\### Ambush



Powerful opening attack from stealth.



\### Smoke Veil



Creates smoke reducing enemy accuracy and allowing repositioning.



\---



\## Rogue Specialization 2 â€” Duelist



Fast sustained melee combat.



Abilities:



\- Twin Strike

\- Blade Flurry

\- Riposte

\- Lunge

\- Execution Cut

\- Quickstep



Focused more on direct combat than stealth.



\---



\## Rogue Specialization 3 â€” Venomancer



Poisons and damage-over-time.



Abilities:



\- Poison Blade

\- Crippling Toxin

\- Venom Cloud

\- Bleeding Cut

\- Toxic Burst

\- Envenom



Strong against long-lasting targets.



\---



\# 10. Warrior



Role:



Heavy melee fighter.



Primary weapons:



\- Sword

\- Axe

\- Mace

\- Greatsword

\- Greataxe

\- Shield



Resource:



Rage or Fury.



\---



\## Warrior Specialization 1 â€” Guardian



Tank.



Abilities:



\### Shield Slam



Damage and threat generation.



\### Taunt



Forces enemy attention.



\### Shield Wall



Major temporary damage reduction.



\### Ground Slam



Area threat and minor stun.



\### Iron Guard



Increases armor.



\---



\## Warrior Specialization 2 â€” Berserker



Heavy two-handed DPS.



Abilities:



\- Cleave

\- Execute

\- Bloodrage

\- Whirlwind

\- Crushing Blow

\- Rampage



High damage but reduced defense.



\---



\## Warrior Specialization 3 â€” Weaponmaster



Balanced sustained melee DPS.



Can specialize in weapon combinations.



Abilities:



\- Heavy Strike

\- Counterattack

\- Battle Cry

\- Sweeping Strike

\- Weapon Break

\- Veteran's Focus



\---



\# 11. Cleric



Role:



Holy and corrupted divine magic.



Primary equipment:



\- Maces

\- Staves

\- Shields

\- Sacred tomes



Resource:



Mana.



\---



\## Cleric Specialization 1 â€” Lightkeeper



Primary healer.



Abilities:



\### Holy Light



Strong single-target healing.



\### Circle of Grace



Area healing.



\### Renewal



Heal-over-time spell.



\### Purify



Removes harmful magical effects.



\### Divine Intervention



Emergency high-value heal or damage prevention.



\---



\## Cleric Specialization 2 â€” Eclipse



Dark/light offensive caster.



Theme:



A cleric who manipulates both sacred and corrupted divine power.



Abilities:



\- Dark Light Bolt

\- Eclipse Pulse

\- Shadow Judgment

\- Corrupted Radiance

\- Twilight Lance

\- Mark of Ruin



Primary DPS specialization.



\---



\## Cleric Specialization 3 â€” Balance Priest



Hybrid healer/DPS.



Should never heal as strongly as Lightkeeper or damage as strongly as Eclipse.



Abilities:



\- Sacred Strike

\- Twilight Mend

\- Radiant Pulse

\- Balanced Judgment

\- Light and Shadow

\- Shared Grace



Ideal for solo play and small parties.



\---



\# 12. Mage



Role:



Primary ranged magical DPS.



Resource:



Mana.



Weapons:



\- Staff

\- Wand

\- Orb

\- Spellbook



\---



\## Mage Specialization 1 â€” Pyromancer



Large area damage and explosive fire spells.



\### Fireball



Large projectile with explosive impact.



\### Fire Dart



Fast, low-cost attack.



\### Flame Cone



Short-range cone of fire.



\### Meteor Flame



Large delayed AOE strike.



\### Burning Ground



Creates a burning area.



\### Inferno



Major cooldown dealing large-area fire damage.



\---



\## Mage Specialization 2 â€” Void Mage



Dark destructive magic.



\### Threefold Dark Pulse



Releases three waves of shadow energy.



\### Dark Aura



Damages nearby enemies over time.



\### Void Bolt



Basic dark projectile.



\### Corruption



Damage-over-time spell.



\### Shadow Collapse



Pulls enemies toward a point before exploding.



\### Abyssal Surge



Large dark magic burst.



\---



\## Mage Specialization 3 â€” Arcanist



Pure arcane magic and utility.



\### Arcane Dart



Fast basic attack.



\### Magic Missile



Tracking magical projectiles.



\### Arcane Shield



Temporary magical barrier.



\### Arcane Blast



Powerful direct damage.



\### Conjure Water



Creates magical water.



Player can sit and drink to gradually restore mana.



\### Conjure Food



Creates magical food.



Player can sit and eat to gradually restore HP.



\### Arcane Blink



Short-distance teleport.



\---



\# 13. Druid



Role:



Nature magic and shapeshifting.



Resource:



Mana while casting.



Forms may use energy/rage-style resources.



\---



\## Druid Specialization 1 â€” Shapeshifter



Can transform between multiple combat forms.



\### Lion Form



Role:



Fast melee DPS.



Properties:



\- Increased movement speed

\- High attack speed

\- Bleed effects

\- Lower defense than Bear



Abilities:



\#### Shred



Strong melee strike.



\#### Rake



Bleeding attack.



\#### Pounce



Leap toward enemy.



\#### Savage Bite



Finisher.



\#### Predator's Rush



Temporary speed increase.



\---



\### Bear Form



Role:



Tank.



Properties:



\- High armor

\- High health

\- Slower movement



Abilities:



\#### Rend



Moderate attack causing bleed.



\#### Growl



Generates high threat.



\#### Stomp



AOE stun.



\#### Thick Hide



Temporary defense increase.



\#### Maul



Heavy melee strike.



\---



\### Kitsune Form



Role:



Magic/mobile hybrid.



Theme:



Mystical fox spirit.



Abilities:



\- Spirit Flame

\- Fox Dash

\- Illusion

\- Spirit Bite

\- Nine-Tail Ward

\- Mystic Ember



Fast magical form focused on mobility and evasive combat.



\---



\## Druid Specialization 2 â€” Grovekeeper



Primary nature healer.



Abilities:



\- Regrowth

\- Healing Bloom

\- Nature's Touch

\- Living Roots

\- Rejuvenation

\- Grove of Life



Uses healing-over-time effects heavily.



\---



\## Druid Specialization 3 â€” Stormcaller



Nature spell DPS.



Abilities:



\- Lightning Bolt

\- Thorn Whip

\- Moonfire

\- Storm Cloud

\- Entangling Roots

\- Wrath of the Wild



\---



\# 14. Paladin



Heavy armored holy/dark melee fighter.



Weapons:



\- Hammer

\- Sword

\- Shield

\- Two-handed mace



Resource:



Mana and/or Conviction.



\---



\## Paladin Specialization 1 â€” Dawnbringer



Holy melee DPS.



Abilities:



\### Hammerfall



Magical hammer strikes target area.



\### Radiant Hammer



Powerful holy melee attack.



\### Judgment



Marks enemy for increased holy damage.



\### Consecrated Ground



Damages enemies standing nearby.



\### Lightburst



AOE holy attack.



\---



\## Paladin Specialization 2 â€” Dreadguard



Dark melee DPS.



Abilities:



\### Dark Aura



Damages enemies nearby.



\### Shadow Imbue



Temporarily enchants weapon with dark magic.



\### Black Hammer



Heavy shadow-infused attack.



\### Soul Crush



High-damage execution-style ability.



\### Corrupted Ground



Creates damaging ground effect.



\---



\## Paladin Specialization 3 â€” Lightwarden



Healing/support Paladin.



Abilities:



\### Holy Light



Strong targeted heal.



\### Holy Aura



Heals nearby allies gradually.



\### Holy Shield



Can be cast on self or allies.



Absorbs incoming damage.



\### Guardian's Grace



Reduces damage taken by an ally.



\### Sacred Hammer



Moderate melee damage.



\### Beacon of Hope



Powerful group-healing cooldown.



The Lightwarden should still deal moderate melee damage so solo play remains viable.



\---



\# 15. World Structure



Rune \& Ruin should eventually contain multiple continents and regions.



Each faction owns a primary homeland.



Example:



```text

Human Continent

Orc Continent

Goblin Continent



&#x20;         â†“



Central Conflict Region



&#x20;         â†“



Endgame Ruined Lands

```



\---



\# 16. Capital Cities



Each faction receives a major capital city.



Every capital contains:



\- Main Arcane Temple

\- Auction/market area eventually

\- Bank

\- Inn

\- Blacksmith

\- Armor merchant

\- Weapon merchant

\- General merchant

\- Class trainers

\- Magic vendors

\- Guild facilities

\- Quest NPCs

\- Travel hub

\- Portal network

\- Crafting stations



At the center of each capital is a massive \*\*Arcane Temple\*\*.



These temples are important to the main story.



\---



\# 17. Arcane Temples



Ancient magical structures exist throughout the world.



Each major faction believes the temples belong to its ancestors.



The truth is that the temples predate all three civilizations.



The temples contain massive rune structures connected to an ancient magical network.



These structures are central to the primary Rune \& Ruin storyline.



\---



\# 18. Sub-Cities



Each faction controls multiple smaller cities or towns.



Examples:



Human:



\- Stonehaven

\- Emberwatch

\- Silverbrook



Orc:



\- Ironfang Hold

\- Bloodstone

\- Ashen Crag



Goblin:



\- Copperwick

\- Miregear

\- Tinkerfen



These names are provisional and may be changed.



\---



\# 19. World Regions



Examples:



\- Enchanted forests

\- Haunted forests

\- Mountains

\- Plains

\- Swamps

\- Deserts

\- Arcane wastelands

\- Ruined kingdoms

\- Caves

\- Mines

\- Magical islands

\- Volcanoes

\- Coastal settlements

\- Frozen regions



Each region needs:



\- Enemies

\- Wildlife

\- Resources

\- Points of interest

\- Quests

\- NPCs

\- Hidden areas

\- Rare enemies

\- Treasure

\- Environmental storytelling



\---



\# 20. Travel



Players travel using:



\- Walking

\- Running

\- Roads

\- Boats

\- Teleport Orbs

\- Portals

\- Mounts eventually



\---



\# 21. Teleport Orbs



Teleport Orbs are physical magical objects in towns and cities.



When selected, they display:



\- Destination name

\- Preview image

\- Region level range

\- Faction control

\- PvP status

\- Travel cost if applicable



Example:



```text

EMBERWATCH



Recommended Level:

12â€“20



Faction:

Human



Status:

Safe Territory



\[Preview Image]



TELEPORT

```



\---



\# 22. PvP Regions



Certain areas are faction conflict zones.



Types:



\## Contested Territory



Players from opposing factions may attack one another.



\## War Zones



Designed specifically around PvP objectives.



Examples:



\- Capture towers

\- Hold bridges

\- Defend ruins

\- Capture magical crystals

\- Escort supply caravans



\## Safe Regions



Faction capitals and early leveling areas should generally prevent hostile PvP.



\---



\# 23. Mobile HUD



The interface must remain readable on Android phones.



\## Top Left



Communication area.



Includes:



\- Chat tab

\- Party messages

\- Guild messages

\- System notifications

\- Expandable chat pane



Text input should be hidden until chat is activated to preserve screen space.



\---



\## Top Area



Icons for:



\- Currency

\- Inventory

\- Character

\- Guild

\- Map

\- Quests

\- Settings



Avoid filling the entire screen with permanent icons.



Expandable menus are preferred.



\---



\# 24. Combat Controls



Bottom left:



Virtual movement joystick.



Bottom right:



Primary attack button surrounded by ability buttons.



Example:



```text

&#x20;       \[Ability 2]



\[Ability 1]  \[ATTACK]  \[Ability 3]



&#x20;       \[Ability 4]



&#x20;    \[Ability 5]

```



The central button performs the class's primary attack.



Ability buttons should change based on:



\- Class

\- Specialization

\- Current form

\- Equipped weapon where applicable



\---



\# 25. Combat Targeting



Mobile-friendly targeting options:



\- Tap enemy

\- Auto-target nearest hostile

\- Target cycling button

\- Ability-specific ground targeting

\- Soft targeting for basic attacks



Avoid requiring pixel-perfect taps.



\---



\# 26. Player Progression



Players earn:



\- XP

\- Levels

\- Gold

\- Equipment

\- Ability unlocks

\- Talent points eventually

\- Reputation

\- Crafting materials

\- Titles

\- Cosmetics



\---



\# 27. Quest Categories



\## Starter Quests



Teach:



\- Movement

\- Combat

\- Class abilities

\- Loot

\- Inventory

\- Equipment

\- NPC interaction

\- Travel



\---



\## Regional Quests



Tell local stories.



Examples:



\- Defeat monsters

\- Protect towns

\- Investigate ruins

\- Escort NPCs

\- Recover artifacts

\- Gather supplies

\- Discover hidden locations



\---



\## Main Story Quests



Center around the Arcane Temples and ancient Rune Network.



\---



\# 28. Main Story Concept



Long before Humans, Orcs, and Goblins controlled the world, an unknown civilization constructed a network of Arcane Temples.



At the heart of each temple was a Rune Core.



Together the Rune Cores stabilized magic across the world.



Something destroyed the civilization.



The network shattered.



Magic became unstable.



Thousands of years later, the factions discovered fragments of the Rune Network and began using them.



Each faction believes controlling the Runes will secure its future.



Instead, their attempts are slowly awakening the catastrophe that destroyed the original civilization.



This event is known as:



\*\*The Ruin.\*\*



Thus:



\# Rune \& Ruin



The central conflict becomes:



> Control the Runes or survive what their awakening unleashes.



\---



\# 29. Starter Story



Each faction begins experiencing strange magical disturbances.



Creatures are becoming corrupted.



Rune stones are activating.



Ancient ruins are opening.



Players begin as ordinary adventurers assisting their local settlement.



Early quests slowly reveal that something much larger is happening.



\---



\# 30. Example Starter Quest Chain



\## Quest 1 â€” A Strange Awakening



Speak with the settlement captain.



Reward:



\- XP

\- Basic weapon



\---



\## Quest 2 â€” Creatures of the Wild



Defeat several nearby corrupted creatures.



Reward:



\- XP

\- Currency

\- Basic armor



\---



\## Quest 3 â€” Marks in the Stone



Investigate mysterious glowing runes.



\---



\## Quest 4 â€” The Forgotten Shrine



Enter a nearby ruin.



\---



\## Quest 5 â€” Arcane Disturbance



Defeat a corrupted guardian.



\---



\## Quest 6 â€” Word to the Capital



Travel to the faction capital.



This introduces the player to the main storyline.



\---



\# 31. Dungeons



Dungeons should generally support groups.



Possible format:



```text

Tank

Healer

3 DPS

```



Target:



5-player dungeon groups.



Examples:



\## Crypt of the Rune King



Undead crypt containing corrupted rune magic.



\## Emberdeep Mine



Ancient mine overtaken by fire creatures.



\## The Hollow Grove



Nature corrupted by dark magic.



\## Blackstone Prison



Faction military dungeon.



\## Ruins of Vael



Ancient pre-faction civilization ruins.



\---



\# 32. Raids



Raids should become major endgame content.



Possible sizes:



\- 10 players initially

\- Larger sizes later if performance permits



Examples:



\## Temple of the First Rune



Players enter one of the ancient Arcane Temples.



\## The Shattered Citadel



Ruined fortress overrun by magical corruption.



\## Heart of the Ruin



Late-game raid tied directly to the origin of the Rune Network.



\---



\# 33. Boss Design



Bosses should include mechanics beyond increased health.



Examples:



\- AOE avoidance

\- Interruptible spells

\- Adds

\- Positioning

\- Tank swaps eventually

\- Healing checks

\- Environmental hazards

\- Phase changes



\---



\# 34. Enemies



Enemy categories:



\- Wildlife

\- Bandits

\- Undead

\- Arcane creatures

\- Corrupted animals

\- Elementals

\- Demons

\- Rogue faction soldiers

\- Ancient constructs

\- Dragons eventually

\- Magical abominations



\---



\# 35. Wildlife



The world should contain neutral animals.



Examples:



\- Deer

\- Wolves

\- Bears

\- Foxes

\- Boars

\- Birds

\- Magical creatures



Not every animal needs to be hostile.



\---



\# 36. Environment



The world should feel inhabited.



Include:



\- Trees

\- Grass

\- Rocks

\- Rivers

\- Lakes

\- Bridges

\- Farms

\- Roads

\- Camps

\- Inns

\- Blacksmiths

\- Markets

\- Magical shops

\- Ruins

\- Shrines

\- Graveyards

\- Docks

\- Mines

\- Towers



\---



\# 37. NPCs



NPCs belong naturally to their settlement.



Human towns:



Primarily human NPCs.



Orc towns:



Primarily orc NPCs.



Goblin towns:



Primarily goblin NPCs.



Neutral cities may contain all factions.



Not every NPC gives a quest.



NPC types:



\- Merchants

\- Guards

\- Citizens

\- Quest givers

\- Class trainers

\- Craftspeople

\- Travelers

\- Story NPCs

\- Guild NPCs



\---



\# 38. Shops



Examples:



\## Blacksmith



\- Weapons

\- Metal armor

\- Repair



\## Arcane Merchant



\- Mage equipment

\- Mana items

\- Wands

\- Staves

\- Magical components



\## Herbalist



\- Potions

\- Herbs

\- Healing supplies



\## General Merchant



\- Bags

\- Food

\- Basic equipment

\- Utility items



\---



\# 39. Inventory



Inventory system should support:



\- Equipment

\- Consumables

\- Quest items

\- Materials

\- Currency

\- Miscellaneous items



Future support:



\- Bank

\- Shared storage

\- Guild storage



\---



\# 40. Equipment



Slots:



\- Head

\- Chest

\- Shoulders

\- Hands

\- Legs

\- Feet

\- Main hand

\- Off hand

\- Necklace

\- Rings

\- Cloak



Possible item rarities:



```text

Common

Uncommon

Rare

Epic

Legendary

Mythic

```



Do not flood players with meaningless loot.



\---



\# 41. Currency



Initial primary currency:



\*\*Gold\*\*



Possible denominations:



\- Copper

\- Silver

\- Gold



Or simplify for mobile:



Gold only.



Future special currency may be earned from:



\- PvP

\- Raids

\- Faction reputation

\- Seasonal content



\---



\# 42. Guilds



Guild system should eventually support:



\- Guild name

\- Guild tag

\- Guild roster

\- Guild roles

\- Guild chat

\- Guild bank

\- Guild achievements

\- Guild PvP eventually



\---



\# 43. Party System



Party support:



\- Invite

\- Leave

\- Kick

\- Promote leader

\- Party chat

\- Health bars

\- Role icons



Roles:



```text

Tank

Healer

DPS

```



\---



\# 44. Crafting



Future crafting professions:



\- Blacksmithing

\- Alchemy

\- Enchanting

\- Leatherworking

\- Tailoring

\- Cooking



Gathering:



\- Mining

\- Herbalism

\- Skinning

\- Logging eventually



\---



\# 45. Rest System



Characters may sit.



Sitting while consuming food or water increases recovery.



Food:



Restores HP.



Water:



Restores mana.



Mage-conjured food/water:



Free but disappears under defined conditions such as logout or long sessions if desired.



\---



\# 46. Death



Initial design:



When HP reaches zero:



\- Character dies

\- Respawns at nearby shrine/graveyard

\- Temporary durability loss may eventually apply



Avoid excessive punishment during early development.



\---



\# 47. Local Development Phase



Until the MMO server exists:



Implement locally:



\- Character creation

\- Player movement

\- Combat

\- Abilities

\- NPCs

\- Quests

\- Inventory

\- Equipment

\- World

\- Enemies

\- Saving/loading



But access these systems through abstractions so they can later use server calls.



\---



\# 48. Initial Build Order



Cursor and Claude should NOT attempt the entire document simultaneously.



Build in milestones.



\## Milestone 0



Playable technical prototype:



\- Main menu

\- Player

\- Top-down camera

\- Movement

\- Android controls

\- Desktop controls

\- Test environment



\---



\## Milestone 1



Core character framework:



\- Faction enum/data

\- Class enum/data

\- Character stats

\- Health

\- Mana

\- Resource system

\- Character naming

\- Basic character creation



\---



\## Milestone 2



Combat foundation:



\- Targeting

\- Basic attack

\- Damage system

\- Ability framework

\- Cooldowns

\- Death

\- Enemy dummy



\---



\## Milestone 3



Class framework:



Implement one prototype class first.



Recommended:



\*\*Mage / Pyromancer\*\*



Abilities:



\- Fire Dart

\- Fireball

\- Flame Cone

\- Burning Ground



Prove the ability system works before adding all classes.



\---



\## Milestone 4



NPC and quest framework.



\---



\## Milestone 5



Inventory and equipment.



\---



\## Milestone 6



Basic world region.



\---



\## Milestone 7



All six class foundations.



\---



\## Milestone 8



Subclass/spec system.



\---



\## Milestone 9



Dungeon framework.



\---



\## Milestone 10



Local persistence.



\---



\## Milestone 11



Nakama/backend integration.



\---



\## Milestone 12



Multiplayer movement.



\---



\## Milestone 13



Server-authoritative combat.



\---



\## Milestone 14



Party/chat/guild systems.



\---



\## Milestone 15



Expanded world content.



\---



\# 49. AI Development Rules



Cursor is the primary implementation agent.



Claude Code acts as:



\- Reviewer

\- Debugger

\- Architecture reviewer

\- Refactoring assistant



Both must read:



```text

AGENTS.md

BUILD\_STATUS.md

GAME\_DESIGN.md

```



before major changes.



After each task:



Update `BUILD\_STATUS.md`.



Never silently redesign the architecture.



Never begin unrelated systems.



Never create duplicate implementations.



Prefer data-driven systems over hard-coded class logic.



\---



\# 50. Data-Driven Class Design



Abilities should NOT be hard-coded entirely into individual UI scenes.



Use reusable data resources.



Conceptually:



```text

AbilityData

&#x20;   name

&#x20;   icon

&#x20;   description

&#x20;   mana\_cost

&#x20;   cooldown

&#x20;   range

&#x20;   damage

&#x20;   damage\_type

&#x20;   target\_type

```



Then:



```text

ClassData

&#x20;   class\_name

&#x20;   base\_stats

&#x20;   allowed\_weapons

&#x20;   specializations

&#x20;   abilities

```



And:



```text

SpecializationData

&#x20;   specialization\_name

&#x20;   role

&#x20;   ability\_list

```



This allows hundreds of abilities to be added without rewriting major systems.



\---



\# 51. Mobile Performance Rules



The project is Android-first.



Avoid:



\- Extremely high polygon counts

\- Huge unoptimized textures

\- Hundreds of active NPC AI processes

\- Excessive dynamic lights

\- Expensive real-time shadows everywhere

\- Large numbers of physics bodies

\- Excessive particles

\- Always-loaded enormous maps



Use:



\- LOD

\- Region/zone streaming

\- Occlusion

\- Object pooling

\- Culling

\- Simplified distant NPCs

\- Limited active simulation radius



\---



\# 52. World Streaming



The eventual large world should NOT exist as one enormous always-loaded Godot scene.



Use zones/chunks.



Example:



```text

Human Capital

Human Forest

Human Farmland

Contested Valley

Goblin Marsh

Orc Highlands

Central Ruins

```



Load/unload regions intelligently.



This will be especially important on Android.



\---



\# 53. Visual Goal



Rune \& Ruin should feel like:



\*\*A serious fantasy RPG that happens to run on Android.\*\*



Not:



\*\*A typical disposable mobile game.\*\*



Favor:



\- Atmospheric lighting

\- Strong silhouettes

\- Distinctive architecture

\- Detailed but optimized environments

\- Readable spell effects

\- High-quality UI

\- Minimal intrusive monetization

\- Strong sound design

\- Cohesive faction identity



\---



\# 54. Core Identity



The game should continuously reinforce three themes:



\## Rune



Ancient power, magic, knowledge, forgotten technology.



\## Ruin



Civilizations lost because they misused that power.



\## Choice



The factions are repeating the same mistakes without understanding the consequences.



The player gradually discovers the truth.



\---



\# 55. Guiding Principle



Every major system should answer:



> Does this make Rune \& Ruin feel like a living magical world worth exploring?



The game should reward:



\- Exploration

\- Class mastery

\- Cooperation

\- Discovery

\- Character progression

\- Faction identity

\- Learning enemy mechanics



Do not prioritize unnecessary complexity over fun.



Build strong foundations first, then expand.



\---



\# 56. Current Immediate Development Target



Do NOT build the entire MMO now.



Current target:



\*\*Milestone 0 â€” Playable Android Prototype\*\*



Cursor should implement the foundational movement, camera, UI, and test environment.



Claude Code should review that implementation.



Once Milestone 0 is stable, proceed to the character/class foundation.



All future development should reference this document as the primary gameplay vision for Rune \& Ruin.





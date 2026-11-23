# ACS Mobile: player-faction-only health protection (experimental)

**NOT a validated God Mode.** This mod attempts to make player-owned units extremely hard to kill by continually clearing their injuries and restoring their health. It does **not** intercept incoming damage and cannot guarantee protection against one-hit kills or lethal damage between updates. It never protects enemy units deliberately.

## What it does

- Uses `Map.Things:GetActiveNpcs()` to enumerate active NPCs.
- Checks `npc.Camp == CS.XiaWorld.Fight.g_emFightCamp.Player` before changing a unit.
- Calls `npc.PropertyMgr.BodyData:RemoveAllDamange()` and `npc:RestHp()` on player-owned live NPCs only.
- Runs on `OnEnter` and polls on `OnStep` about every 0.05 game-time units; actual callback timing depends on the game.
- **Does not set `CS.GameMain.Instance.AllGod`**, because that setting protects BOTH sides.
- Does not edit enemy data and does not require keyboard shortcuts, extra modules, or separate installation steps after GitHub import.

## API provenance

- Mobile mod structure and lifecycle callbacks: <https://github.com/GSQStudio/acs1_example_mod>
- Faction enumeration examples: <https://github.com/locke12456/ACSHappyMan/blob/main/Scripts/BaByComeTrue.lua>
- `RemoveAllDamange()` and `RestHp()` implementations used in real ACS Lua mods: <https://github.com/hcmyxconan15/acs1-qfwd-modifier/blob/main/Scripts/Window/NpcManager.lua>
- Why the previous approach was wrong: <https://github.com/hcmyxconan15/acs1-qfwd-modifier/blob/main/Scripts/Window/OthersSet.lua> uses `AllGod` for *all* units.

## Status and important limitations

- `Info.json` validated and Lua code executed against simulated ACS-like game objects using Lua 5.3 (`texlua`). No iPad engine was available for runtime testing.
- Specific API members are taken from public community ACS mod sources; mobile version compatibility has **not** been established.
- Healing is not true invincibility and cannot prevent certain instant deaths.
- The separate lethal-hit simulation confirmed that a friendly NPC already killed before the next tick stays dead. Try this experimental mod on a backup save first.
- Do **not** run together with an all-units `AllGod` mod, which would still protect enemy units.

## Import on iPad

In the international mobile build, open **MOD Store** and use the GitHub import control in the top-right. Paste this repository's URL, not a ZIP or a release-page link. This package follows the developer's mobile repository layout; import and in-game behavior have not been tested on an iPad.

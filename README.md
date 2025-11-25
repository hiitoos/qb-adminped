# qb-adminped

Simple resource for **QBCore** that lets administrators temporarily change their PED and later restore their original model and clothing using server commands.

## Features

- Command to change the player’s PED model.
- Automatically saves the original model, clothing, and props the first time you change PED.
- Command to restore the original PED (model + clothing + props).
- Mixed permission system:
  - Respects QBCore permissions (`god` and `admin`).
  - Respects ACE permissions (`group.admin` with `command` ace).

## Requirements

- FiveM (fx_version `cerulean`).
- **QBCore** framework.
- Resource folder named `qb-adminped`.

## Installation

1. Download the repository and place the `qb-adminped` folder inside your `resources/` directory.
2. Make sure your `fxmanifest.lua` looks similar to this:

   ```lua
   fx_version 'cerulean'
   game 'gta5'

   author 'Driieen'
   description 'Changeped.'
   version '1.0.0'

   shared_script '@qb-core/shared/locale.lua'

   client_script 'client.lua'
   server_script 'server.lua'
   ```

3. Add this to your `server.cfg`:

   ```cfg
   ensure qb-adminped
   ```

4. Configure permissions as described below.

## Permissions

The script considers a player **admin** if **any** of these conditions is true:

1. The player has QBCore permission `god` or `admin`:

   ```cfg
   # QBCore base
   add_ace qbcore.god command allow
   add_principal qbcore.god qbcore.admin
   add_principal qbcore.admin qbcore.mod

   # Example player
   add_principal identifier.license:YOUR_LICENSE_HERE qbcore.god
   ```

2. The player belongs to ACE group `group.admin` that has the `command` ace:

   ```cfg
   add_ace group.admin command allow
   add_principal identifier.license:YOUR_LICENSE_HERE group.admin
   ```

Replace `YOUR_LICENSE_HERE` with the real `identifier.license:` of the player.

## Commands

Commands are registered with `QBCore.Commands.Add` and marked as `'user'` so QBCore does not block them; the script itself performs the permission check.

### `/setped <model>`

Changes your PED to the given model (admins only).

- Example:
  - `/setped s_m_y_cop_01`
- If the model is invalid or not found, the player is notified.

### `/revertped`

Restores the original PED and clothing saved when `/setped` was used for the first time in the current session (admins only).

- If there is no saved appearance (you never used `/setped` since you joined), an error notification is shown.

## How it works (summary)

- On the client side, the script saves:
  - Current model.
  - Clothing components (0–11).
  - Props (0–7).

- When `/setped` is used:
  - If it is the first time, it stores the current appearance.
  - Loads the new model and applies default clothing.

- When `/revertped` is used:
  - Restores the original model and reapplies all saved components and props.
  - Clears the stored appearance so the next `/setped` will save again.

## Credits

- Developed by **Driieen**.

You are free to modify this resource to fit your server, as long as original credits are kept.

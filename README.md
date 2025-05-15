# FiveM Developer Template

Ez egy átfogó fejlesztői sablon FiveM scriptekhez, amely integrációt biztosít a legnépszerűbb keretrendszerekkel (ESX, QBCore, Standalone), valamint bemutatja az ox_lib és ox_inventory használatát.

## Funkciók

- **Keretrendszer integrációk:**
  - ESX teljes támogatás
  - QBCore teljes támogatás
  - Standalone mód a független fejlesztéshez
  
- **ox_lib integrációk:**
  - Értesítési rendszer
  - Fejlett kontextus-menü rendszer
  - Progressbár
  - Szövegmegjelenítés és egyéb UI elemek
  
- **ox_inventory integráció:**
  - Tárgy kezelés
  - Egyedi tárgyak létrehozása
  - Stash és üzlet rendszer

## Függőségek kezelése

**Fontos megjegyzés a keretrendszerek használatáról:**

Az `fxmanifest.lua` fájlban alapértelmezetten az ESX be van kapcsolva, a QBCore pedig ki van kommentezve. Attól függően, hogy melyik keretrendszert szeretnéd használni:

- **ESX használata esetén:**
  - Nincs szükség további lépésekre, alapértelmezetten az ESX van beállítva.

- **QBCore használata esetén:**
  - Távolítsd el a komment jeleket (`--`) a QBCore scriptek elől az `fxmanifest.lua` fájlban
  - Töröld vagy kommenteld ki az ESX importot (`@es_extended/imports.lua`)
  - A `config.lua` fájlban állítsd be a `Config.UseQBCore = true` és a `Config.UseESX = false` értékeket

- **Standalone mód használata esetén:**
  - Töröld vagy kommenteld ki az ESX importot (`@es_extended/imports.lua`)
  - Hagyja kikommentelve a QBCore importokat
  - A `config.lua` fájlban állítsd be a `Config.UseStandalone = true`, valamint a `Config.UseESX = false` és `Config.UseQBCore = false` értékeket

- **Discord webhook integráció:**
  - Esemény naplózás
  - Admin értesítések
  - Játékos tevékenység követése
  - **FONTOS**: A webhook URL-t érdemes szerver oldalt tárolni biztonsági okokból! A config.lua fájlban található beállítás csak példa célokat szolgál.
  
- **Példa implementációk:**
  - Marker és interakció rendszer
  - NPC menedzselés
  - Parancsok és események
  - Adatbáziskezelés
  
- **Többnyelvű támogatás:**
  - Lokalizációs rendszer
  - Könnyű nyelvi bővítés

## Telepítés

1. Másold a `roby_dev_template` mappát a szerver `resources` könyvtárába
2. Add hozzá a `start roby_dev_template` sort a `server.cfg`-hez
3. Állítsd be a konfigurációt a `config.lua` fájlban
4. Indítsd újra a szervert

## Konfiguráció

A script konfigurációja a `config.lua` fájlban található. Itt állíthatod be a keretrendszert, a funkciókat és a különböző beállításokat.

### Keretrendszer választás

```lua
Config.UseESX = true -- ESX használata
Config.UseQBCore = false -- QBCore használata
Config.UseStandalone = false -- Standalone mód használata
```

### Discord Webhook beállítások

```lua
Config.Discord = {
    Enabled = true,
    WebhookURL = "https://discord.com/api/webhooks/your-webhook-url-here",
    BotName = "Server Bot",
    AvatarURL = "https://i.imgur.com/example.png",
    Color = 16711680, -- Piros szín decimális formátumban
    FooterText = "FiveM Server",
    FooterIcon = "https://i.imgur.com/example.png"
}
```

### ox_lib és ox_inventory beállítások

```lua
Config.OxLib = {
    Notifications = true,
    Menu = true,
    ContextMenu = true,
    Progress = true
}

Config.OxInventory = {
    UseItemFunctions = true,
    CustomInventory = "stash_example"
}
```

## Használat

### Kliens oldali példák

#### Értesítések küldése

```lua
-- Értesítés küldése
ShowNotification('Ez egy teszt értesítés', 'success')
```

#### Kontextus menü használata

```lua
-- Menü megnyitása
OpenContextMenu()
```

#### Progressbár használata

```lua
-- Progressbár indítása
local success = StartProgressBar('Feldolgozás...', 5000)
```

#### Tárgy ellenőrzése

```lua
-- Tárgy meglétének ellenőrzése
local hasItem = HasItem('water', 1)
```

### Szerver oldali példák

#### Játékos adatok lekérése

```lua
-- Játékos objektum lekérése
local player = GetPlayer(source)
```

#### Pénz hozzáadása

```lua
-- Pénz hozzáadása a játékoshoz
AddMoney(source, 1000, 'bank', 'Template jutalom')
```

#### Discord webhook küldése

```lua
-- Discord webhook küldése
SendDiscordWebhook('Esemény', 'Valami történt a szerveren', 'info')
```

#### Tárgy hozzáadása

```lua
-- Tárgy hozzáadása a játékoshoz
AddItem(source, 'water', 1)
```

## Bővítés

A sablon könnyen bővíthető új funkciókkal. A következő mappákba helyezheted az új fájlokat:

- `client/`: Kliens oldali scriptek
- `server/`: Szerver oldali scriptek
- `shared/`: Mindkét oldalon használt fájlok
- `locales/`: Nyelvi fájlok

## Függőségek

A következő erőforrások szükségesek vagy ajánlottak:

- `es_extended` (ha ESX-et használsz)
- `qb-core` (ha QBCore-t használsz)
- `oxmysql` (adatbázis kapcsolathoz)
- `ox_lib` (UI elemekhez és segédfunkciókhoz)
- `ox_inventory` (tárgykezeléshez)

## Licensz

Ez a sablon szabadon használható, módosítható és terjeszthető, saját projektek alapjaként is.

## Közreműködés

Ha szeretnél hozzájárulni a sablonhoz, vagy hibát találnál, kérlek jelezd az Issues szekcióban.

## Elérhetőség

Ha kérdésed vagy problémád lenne a sablonnal kapcsolatban, keress minket a Discord szerverünkön.

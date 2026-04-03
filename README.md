# Tutorial 7 - Basic 3D Game Mechanics & Level Design

**Mata Kuliah Game Development — Fasilkom UI**
Dibuat dengan **Godot 4.6.1** menggunakan GDScript.

---

## Cara Bermain

| Tombol | Aksi |
|--------|------|
| W / A / S / D | Gerak |
| Mouse | Putar kamera |
| Space | Lompat |
| Shift | Sprint |
| Ctrl | Jongkok |
| E | Interaksi objek / Pickup item |
| 1 – 5 | Pilih slot inventory |
| Scroll Wheel | Ganti slot inventory |
| Esc | Lepas kursor mouse |

---

## Proses Pengerjaan

### Latihan: Basic 3D Plane Movement

Membuat scene `Player.tscn` dengan struktur node:
- `CharacterBody3D` (Player) → script `character_body_3d.gd`
  - `MeshInstance3D` — capsule mesh sebagai wujud pemain
  - `CollisionShape3D` — capsule shape untuk physics collision
  - `Head` (Node3D) — diposisikan di ujung atas karakter
    - `Camera3D` — kamera first-person
      - `RayCast3D` — untuk deteksi interaksi objek

Script movement menggunakan `head.basis` agar arah gerak mengikuti arah hadap kamera. Rotasi kamera vertikal di-clamp antara -90 hingga 90 derajat agar tidak bisa berputar penuh ke atas/bawah.

### Latihan: Object Interaction

Membuat sistem interaksi menggunakan pola inheritance:
- `Interactable.gd` — base class dengan fungsi `interact()` kosong
- `Switch.gd` — extend `Interactable`, toggle `light_energy` pada `OmniLight3D` yang di-export via `NodePath`

`RayCast3D` di script `ray_cast_3d.gd` mengecek setiap frame apakah collider yang terkena merupakan instance `Interactable`. Jika ya dan pemain menekan E, fungsi `interact()` dipanggil.

### Latihan: Membuat Level 3D Menggunakan CSG

Level geometry dibuat di scene `World 1.tscn` menggunakan node-node CSG:
- `CSGBox3D` dengan **Flip Faces** untuk membuat ruangan kosong (interior)
- `CSGCombiner3D` dengan operasi **Union** dan **Subtraction** untuk membuat lubang/jurang sebagai rintangan
- `CSGBox3D` tambahan sebagai platform lompatan
- `ObjLamp.tscn` — objek lampu dekoratif dibuat dari kombinasi `CSGCylinder3D`, `CSGCone3D`, dan `CSGPolygon3D` (mode Spin) dengan `StandardMaterial3D` untuk pewarnaan

`AreaTrigger` (scene `Area Trigger.tscn`) menggunakan `Area3D` + signal `body_entered` untuk berpindah scene saat Player masuk area:
- Area di ujung level → pindah ke `WinScreen`
- Area di atas lubang → reload `Level 1` (respawn)

---

## Latihan Mandiri

### 1. Pick Up Item & Inventory System

Mengimplementasikan sistem inventory dengan autoload singleton `Inventory.gd`:
- 5 slot inventory, awalnya semua kosong (`null`)
- Pemain bisa mengambil **Torch** (obor) di level menggunakan tombol E
- Slot aktif bisa dipilih dengan tombol **1–5** atau **scroll wheel**
- Signal `inventory_changed` dikirim setiap kali isi inventory berubah

`RayCast3D` diconfigurasi dengan **Collide With Areas = true** agar bisa mendeteksi `Torch` yang merupakan `Area3D`. Saat RayCast mengenai `Torch`:
- Muncul prompt **"Press [E] to pick up"** di tengah layar (`InteractPrompt` Label dalam `CanvasLayer`)
- Jika E ditekan, torch ditambahkan ke inventory dan node torch dihapus dari scene

`HotbarUI.tscn` menampilkan slot inventory di layar menggunakan `InventoryUI.gd`.

### 2. Sprinting & Crouching

Menambahkan tiga mode kecepatan pada `character_body_3d.gd`:
- **Normal** (`speed = 10`) — default
- **Sprint** (`sprint_speed = 18`) — tahan Shift
- **Crouch** (`crouch_speed = 4`) — tahan Ctrl

Saat jongkok, `scale.y` dan `head.position.y` di-lerp untuk animasi transisi yang mulus, mensimulasikan pemain yang mengecil.

### Fitur Tambahan: Torch Light

Saat slot aktif inventory berisi Torch, `OmniLight3D` (`TorchLight`) yang ada di `Head/Camera3D` menyala. Ini terhubung via signal `inventory_changed` dari singleton `Inventory`.

---

## Struktur Project

```
scenes/
  Level.tscn          # Scene entry point
  Level 1.tscn        # Level utama dengan gameplay
  World 1.tscn        # Geometri level (CSG)
  Player.tscn         # CharacterBody3D + kamera + raycast
  Torch.tscn          # Item obor yang bisa di-pickup
  ObjLamp.tscn        # Objek dekoratif lampu (CSG)
  HotbarUI.tscn       # UI hotbar inventory
  Area Trigger.tscn   # Trigger perpindahan scene
  WinScreen.tscn      # Layar menang

scripts/
  character_body_3d.gd  # Movement, sprint, crouch, mouse look, torch
  ray_cast_3d.gd        # Interaksi objek & pickup item
  Inventory.gd          # Autoload singleton, 5 slot
  InventoryUI.gd        # Hotbar UI renderer
  Interactable.gd       # Base class interactable
  Switch.gd             # Toggle lampu (extends Interactable)
  torch.gd              # Class Torch (extends Area3D)
  area_3d.gd            # Area trigger pindah scene
```

---

## Referensi

- [Godot 3D Tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/index.html)
- [Godot FPS Tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/fps_tutorial/index.html)
- [Kenney 3D Assets](https://kenney.nl/assets?q=3d)
- Materi tutorial pengenalan Godot Engine, kuliah Game Development Fasilkom UI

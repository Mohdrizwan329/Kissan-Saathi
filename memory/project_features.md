---
name: App Features Overview
description: Feature list and completion status of Kisaan Saathi app
type: project
---

Kisaan Saathi is a Flutter app for Indian farmers with Hindi/English localization via Riverpod.

**Bottom nav tabs:** Home, Krishi Tips, Mandi Bhav, Yojnayein, Profile

**Home quick categories:** Beej (Seeds), Khad (Fertilizers), Dawa (Pesticides), Auzaar (Tools), Sinchai (Irrigation)

**Kisan Services (11 cards):** Mausam, Fasal Calendar, Calculator, Fasal Bima, Helpline, Mitti Health, Pashu Palan, Jaivik Kheti, Fasal Doctor, Kisan Diary, Bhandaran

**Data:** All static/hardcoded in Dart files (Seed_Data, Fertilizer_Data, Tool_Data, Pesticide_Data, Irrigation_Data) — images are emojis not network URLs.

**Profile:** SharedPreferences se name/email/mobile/avatar load/save hota hai. Edit Profile se save on tap.

**Why:** Reference for future feature additions.
**How to apply:** When adding new features, follow existing pattern — add data in Data/ folder, create View page, add to Home_Page services grid.

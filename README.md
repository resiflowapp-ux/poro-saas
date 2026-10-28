# Poro Digital SaaS V5 - Multi-Resto + Upload Caméra

Stack: Vite + Supabase + Vercel
Abonnement: 7500 FCFA / mois par restaurant
WhatsApp: +225 07 49 30 97 17 / 05 06 31 02 09

## Fonctionnalités
- Public: /r/[slug] commande via WhatsApp
- Dashboard Resto: gestion menu avec vraies photos, upload caméra/galerie, commandes en direct, abonnement 7500F
- Super Admin: tous les restos, MRR, abonnements

## Installation locale
1. npm install -g vite (si pas installé)
2. npx vite (ouvre http://localhost:5173)

Ou simplement ouvre index.html dans navigateur (mode démo sans Supabase)

## Déploiement Vercel + Supabase

### Supabase SQL (à coller dans SQL Editor)
Voir fichier supabase.sql

### Variables Vercel
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

### Storage bucket pour photos
Dans Supabase SQL:
insert into storage.buckets (id, name, public) values ('plat-images', 'plat-images', true);
create policy "Public read plat-images" on storage.objects for select using (bucket_id='plat-images');
create policy "Auth upload plat-images" on storage.objects for insert with check (bucket_id='plat-images');

## Photos réelles
Chaque plat a une vraie photo 56x56 dans le tableau, 160px côté client.
Upload caméra: <input capture="environment"> pour ouvrir caméra directe sur mobile.
Compression auto 800px max si >1Mo.

Propulsé par Poro Digital - assamoah.virgil2@gmail.com - Korhogo/Bouaké

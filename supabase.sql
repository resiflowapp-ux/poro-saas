-- Poro Digital SaaS V5 - Full Schema
create table restaurants (id uuid default gen_random_uuid() primary key, slug text unique not null, name text not null, whatsapp_number text not null, owner_id uuid references auth.users(id), is_active boolean default false, created_at timestamp default now());
create table profiles (id uuid references auth.users primary key, role text check (role in ('owner','super_admin')), restaurant_id uuid references restaurants(id));
create table products (id uuid default gen_random_uuid() primary key, restaurant_id uuid references restaurants(id) not null, name text, price int, description text, image_url text, category text, created_at timestamp default now());
create table orders (id uuid default gen_random_uuid() primary key, restaurant_id uuid references restaurants(id), customer_name text, customer_phone text, quartier text, address text, items jsonb, total int, payment_method text, status text default 'nouvelle', created_at timestamp default now());
create table subscriptions (id uuid default gen_random_uuid() primary key, restaurant_id uuid references restaurants, amount int default 7500, status text, wave_transaction_id text, starts_at timestamp, ends_at timestamp, created_at timestamp default now());
alter table restaurants enable row level security; alter table products enable row level security; alter table orders enable row level security; alter table subscriptions enable row level security;
create policy "owner resto" on restaurants for all using (owner_id = auth.uid());
create policy "owner produits" on products for all using (restaurant_id in (select restaurant_id from profiles where id=auth.uid()));
create policy "owner commandes" on orders for all using (restaurant_id in (select restaurant_id from profiles where id=auth.uid()));
create policy "super_admin resto" on restaurants for all using (exists(select 1 from profiles where id=auth.uid() and role='super_admin'));
create policy "public menu si actif" on restaurants for select using (is_active = true);
create policy "public produits si actif" on products for select using (restaurant_id in (select id from restaurants where is_active=true));
-- Storage
insert into storage.buckets (id, name, public) values ('plat-images', 'plat-images', true) on conflict (id) do nothing;
create policy "Public read plat-images" on storage.objects for select using (bucket_id='plat-images');
create policy "Auth upload plat-images" on storage.objects for insert with check (bucket_id='plat-images');
create policy "Auth update plat-images" on storage.objects for update using (bucket_id='plat-images');
create policy "Auth delete plat-images" on storage.objects for delete using (bucket_id='plat-images');

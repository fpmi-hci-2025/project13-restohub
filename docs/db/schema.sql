-- PostgreSQL schema for RestoHub

-- enable pgcrypto for gen_random_uuid() if needed
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- users
create table if not exists users(
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  password_hash text not null,
  full_name text,
  created_at timestamptz default now()
);

-- addresses
create table if not exists addresses(
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  label text,
  line1 text,
  line2 text,
  city text,
  latitude double precision,
  longitude double precision,
  created_at timestamptz default now()
);

-- restaurants
create table if not exists restaurants(
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  rating numeric(3,2) default 0
);

-- dishes
create table if not exists dishes(
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  price numeric(10,2) not null,
  nutrition jsonb,
  is_active boolean default true
);

-- menus / menu_items
create table if not exists menus(
  id uuid primary key default gen_random_uuid(),
  restaurant_id uuid not null references restaurants(id) on delete cascade,
  title text not null
);

create table if not exists menu_items(
  id uuid primary key default gen_random_uuid(),
  menu_id uuid not null references menus(id) on delete cascade,
  dish_id uuid not null references dishes(id) on delete restrict,
  is_featured boolean default false
);

-- orders / order_items
create table if not exists orders(
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id),
  restaurant_id uuid not null references restaurants(id),
  status text not null default 'created',
  total_amount numeric(10,2) not null default 0,
  placed_at timestamptz default now()
);

create table if not exists order_items(
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders(id) on delete cascade,
  dish_id uuid not null references dishes(id),
  qty int not null check (qty > 0),
  price numeric(10,2) not null
);

-- payments
create table if not exists payments(
  id uuid primary key default gen_random_uuid(),
  order_id uuid unique not null references orders(id) on delete cascade,
  provider text not null,
  status text not null,
  amount numeric(10,2) not null,
  created_at timestamptz default now()
);

-- deliveries
create table if not exists deliveries(
  id uuid primary key default gen_random_uuid(),
  order_id uuid unique not null references orders(id) on delete cascade,
  courier_id uuid,
  status text not null default 'assigned',
  eta_minutes int,
  started_at timestamptz,
  delivered_at timestamptz
);

-- couriers
create table if not exists couriers(
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text
);

-- reviews
create table if not exists reviews(
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id),
  restaurant_id uuid not null references restaurants(id),
  rating int not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz default now()
);

-- promo codes
create table if not exists promo_codes(
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  discount_percent int check (discount_percent between 0 and 100),
  active boolean default true,
  starts_at timestamptz,
  ends_at timestamptz
);

-- favorites
create table if not exists favorites(
  user_id uuid not null references users(id) on delete cascade,
  restaurant_id uuid not null references restaurants(id) on delete cascade,
  primary key(user_id, restaurant_id)
);

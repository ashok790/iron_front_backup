-- =====================================================================
-- IRON FRONT: LAST DEFENSE — SUPABASE DATABASE SCHEMA
-- =====================================================================
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- =====================================================================

-- ---------- PLAYERS TABLE ----------
create table if not exists players (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  guest_id text unique,
  display_name text,
  coins integer not null default 200,
  highest_wave integer not null default 0,
  total_score bigint not null default 0,
  is_subscribed boolean not null default false,
  subscription_expires_at timestamptz,
  ads_removed boolean not null default false,
  battle_pass_owned boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ---------- LEVEL PROGRESS ----------
create table if not exists level_progress (
  id uuid primary key default gen_random_uuid(),
  player_id uuid references players(id) on delete cascade,
  level_id integer not null,
  stars integer not null default 0,
  best_score bigint not null default 0,
  completed_at timestamptz,
  unique(player_id, level_id)
);

-- ---------- LEADERBOARD ----------
create table if not exists leaderboard (
  id uuid primary key default gen_random_uuid(),
  player_id uuid references players(id) on delete cascade,
  display_name text not null,
  score bigint not null,
  wave_reached integer not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_leaderboard_score on leaderboard (score desc);

-- ---------- PURCHASES (audit log) ----------
create table if not exists purchases (
  id uuid primary key default gen_random_uuid(),
  player_id uuid references players(id) on delete cascade,
  product_id text not null,
  purchase_token text,
  amount_cents integer,
  currency text,
  status text,
  created_at timestamptz not null default now()
);

-- ---------- ROW LEVEL SECURITY ----------
alter table players enable row level security;
alter table level_progress enable row level security;
alter table leaderboard enable row level security;
alter table purchases enable row level security;

-- Players can only read/write their own row
create policy "Players: self read" on players for select using (auth.uid() = user_id);
create policy "Players: self write" on players for update using (auth.uid() = user_id);
create policy "Players: self insert" on players for insert with check (auth.uid() = user_id);

-- Level progress: self only
create policy "LP: self read" on level_progress for select
  using (player_id in (select id from players where user_id = auth.uid()));
create policy "LP: self write" on level_progress for all
  using (player_id in (select id from players where user_id = auth.uid()));

-- Leaderboard: everyone can read, only owner can write
create policy "LB: public read" on leaderboard for select using (true);
create policy "LB: self insert" on leaderboard for insert
  with check (player_id in (select id from players where user_id = auth.uid()));

-- Purchases: self only (writes done by service role from edge function)
create policy "Purch: self read" on purchases for select
  using (player_id in (select id from players where user_id = auth.uid()));

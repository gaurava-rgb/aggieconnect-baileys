-- Run this in Supabase SQL Editor
-- Baileys A/B instance tables — mirrors the main schema with baileys_ prefix
-- monitored_groups is SHARED with the main bot, do NOT recreate it here.

-- ============================================================
-- Ride requests and offers (Baileys instance)
-- ============================================================
create table if not exists baileys_requests (
  id uuid primary key default gen_random_uuid(),
  source text not null,
  source_group text,
  source_contact text not null,
  request_type text not null,
  request_category text not null,
  ride_plan_date date,
  request_origin text,
  request_destination text,
  request_details jsonb default '{}',
  raw_message text,
  request_status text default 'open',
  request_hash text,
  created_at timestamptz default now()
);

-- ============================================================
-- Matches (Baileys instance)
-- ============================================================
create table if not exists baileys_matches (
  id uuid primary key default gen_random_uuid(),
  need_id uuid references baileys_requests(id) on delete cascade,
  offer_id uuid references baileys_requests(id) on delete cascade,
  score float default 1.0,
  notified boolean default false,
  created_at timestamptz default now()
);

-- ============================================================
-- Message log (Baileys instance)
-- ============================================================
create table if not exists baileys_message_log (
  id uuid primary key default gen_random_uuid(),
  wa_message_id text,
  source_group text,
  source_contact text,
  sender_name text,
  message_text text,
  is_request boolean default false,
  parsed_data jsonb,
  error text,
  created_at timestamptz default now()
);

-- ============================================================
-- Indexes
-- ============================================================
create index if not exists idx_baileys_requests_status       on baileys_requests(request_status);
create index if not exists idx_baileys_requests_category     on baileys_requests(request_category, ride_plan_date);
create index if not exists idx_baileys_requests_destination  on baileys_requests(request_destination);
create index if not exists idx_baileys_requests_hash         on baileys_requests(request_hash);
create index if not exists idx_baileys_matches_notified      on baileys_matches(notified);
create index if not exists idx_baileys_msglog_created        on baileys_message_log(created_at);
create index if not exists idx_baileys_msglog_is_request     on baileys_message_log(is_request);

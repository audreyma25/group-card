-- Run this in the Supabase SQL Editor (supabase.com → your project → SQL Editor)

-- Table for individual notes left by team members
create table public.notes (
  id         bigint generated always as identity primary key,
  name       text        not null,
  message    text        not null,
  font       text        not null default 'caveat',
  created_at timestamptz not null default now()
);

-- Single-row table for card config (recipient name + unlock password)
create table public.card_settings (
  id        int  primary key,
  password  text not null default 'open',
  recipient text not null default ''
);

-- Seed the single settings row
insert into public.card_settings (id, password, recipient) values (1, 'open', '');

-- Enable Row Level Security
alter table public.notes        enable row level security;
alter table public.card_settings enable row level security;

-- notes: anyone with the link can read and add notes
create policy "public read notes"   on public.notes for select using (true);
create policy "public insert notes" on public.notes for insert with check (true);

-- card_settings: anyone can read (to verify password client-side)
-- and update (so the organizer can set recipient + password via the UI)
create policy "public read settings"   on public.card_settings for select using (true);
create policy "public update settings" on public.card_settings for update using (true);
create policy "public insert settings" on public.card_settings for insert with check (true);

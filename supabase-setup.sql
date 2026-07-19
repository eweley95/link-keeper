-- ============================================
-- Linkshelf: Supabase setup
-- Run this once in: Supabase dashboard → SQL Editor → New query → Run
-- ============================================

-- 1. The links table
create table public.links (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  title      text not null,
  url        text not null,
  category   text not null default 'Uncategorized',
  created_at timestamptz not null default now()
);

-- Index so each user's link list loads fast
create index links_user_created_idx on public.links (user_id, created_at desc);

-- 2. Row Level Security: each user can only touch their own rows
alter table public.links enable row level security;

create policy "Users can view their own links"
  on public.links for select
  using (auth.uid() = user_id);

create policy "Users can add their own links"
  on public.links for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own links"
  on public.links for update
  using (auth.uid() = user_id);

create policy "Users can delete their own links"
  on public.links for delete
  using (auth.uid() = user_id);

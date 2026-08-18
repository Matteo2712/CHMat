-- Esegui questo script nell'editor SQL di Supabase (Project > SQL Editor > New query)
-- Tabella con prefisso "CH_" per riconoscerla facilmente tra le tue altre app

create table if not exists public."CH_progress" (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public."CH_progress" enable row level security;

-- Ogni utente può leggere/scrivere SOLO la propria riga
create policy "CH_progress_select_own"
  on public."CH_progress" for select
  using (auth.uid() = user_id);

create policy "CH_progress_insert_own"
  on public."CH_progress" for insert
  with check (auth.uid() = user_id);

create policy "CH_progress_update_own"
  on public."CH_progress" for update
  using (auth.uid() = user_id);

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================
-- Core tables
-- ============================================

create table users (
    id uuid primary key default gen_random_uuid(),
    email text unique not null,
    name text not null,
    neighborhood text,
    latitude decimal(10, 7),
    longitude decimal(10, 7),
    allows_remote_tasks boolean default true,
    created_at timestamptz default now()
);

create table task_categories (
    id uuid primary key default gen_random_uuid(),
    name text unique not null
);

-- ============================================
-- Task posts
-- ============================================

create table needs (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    category_id uuid references task_categories(id),
    title text not null,
    description text,
    estimated_hours numeric not null check (estimated_hours > 0),
    location_text text,
    latitude decimal(10, 7),
    longitude decimal(10, 7),
    status text not null default 'open' check (status in ('open', 'matched', 'completed', 'cancelled')),
    created_at timestamptz default now()
);

create table offers (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    category_id uuid references task_categories(id),
    title text not null,
    description text,
    estimated_hours numeric not null check (estimated_hours > 0),
    location_text text,
    latitude decimal(10, 7),
    longitude decimal(10, 7),
    status text not null default 'open' check (status in ('open', 'matched', 'completed', 'cancelled')),
    created_at timestamptz default now()
);

-- ============================================
-- Swap proposals (flexible hour-for-hour)
-- ============================================

create table swaps (
    id uuid primary key default gen_random_uuid(),
    proposer_id uuid references users(id) on delete cascade,
    need_id uuid references needs(id) on delete cascade,
    offer_id uuid references offers(id) on delete cascade,
    need_owner_id uuid references users(id),
    offer_owner_id uuid references users(id),
    proposer_hours_credit numeric,
    owner_hours_credit numeric,
    status text not null default 'pending' check (status in ('pending', 'accepted', 'rejected', 'completed', 'cancelled')),
    proposed_at timestamptz default now(),
    responded_at timestamptz
);

-- ============================================
-- Communication & proof
-- ============================================

create table messages (
    id uuid primary key default gen_random_uuid(),
    swap_id uuid references swaps(id) on delete cascade,
    sender_id uuid references users(id) on delete cascade,
    body text not null,
    created_at timestamptz default now()
);

create table task_photos (
    id uuid primary key default gen_random_uuid(),
    swap_id uuid references swaps(id) on delete cascade,
    user_id uuid references users(id) on delete cascade,
    task_role text not null check (task_role in ('need', 'offer')),
    image_url text not null,
    caption text,
    uploaded_at timestamptz default now()
);

create table swap_confirmations (
    id uuid primary key default gen_random_uuid(),
    swap_id uuid references swaps(id) on delete cascade,
    user_id uuid references users(id) on delete cascade,
    task_role text not null check (task_role in ('need', 'offer')),
    confirmed_at timestamptz default now(),
    unique (swap_id, user_id, task_role)
);

-- ============================================
-- Reviews
-- ============================================

create table reviews (
    id uuid primary key default gen_random_uuid(),
    swap_id uuid references swaps(id) on delete cascade,
    reviewer_id uuid references users(id) on delete cascade,
    reviewee_id uuid references users(id) on delete cascade,
    rating integer not null check (rating >= 1 and rating <= 5),
    comment text,
    created_at timestamptz default now(),
    unique (swap_id, reviewer_id, reviewee_id)
);

-- ============================================
-- Indexes
-- ============================================

create index idx_needs_user on needs(user_id);
create index idx_needs_status on needs(status);
create index idx_needs_location on needs(latitude, longitude);
create index idx_needs_category on needs(category_id);

create index idx_offers_user on offers(user_id);
create index idx_offers_status on offers(status);
create index idx_offers_location on offers(latitude, longitude);
create index idx_offers_category on offers(category_id);

create index idx_swaps_proposer on swaps(proposer_id);
create index idx_swaps_need on swaps(need_id);
create index idx_swaps_offer on swaps(offer_id);
create index idx_swaps_status on swaps(status);

create index idx_messages_swap on messages(swap_id);
create index idx_task_photos_swap on task_photos(swap_id);
create index idx_confirmations_swap on swap_confirmations(swap_id);
create index idx_reviews_reviewee on reviews(reviewee_id);
-- CounterPOS starter schema for Supabase PostgreSQL.
-- IMPORTANT: This is a schema foundation, not a complete production security policy.
-- Before real use, add authentication, shop membership/tenant tables, and tested RLS policies.
create extension if not exists pgcrypto;

create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,
  gstin text,
  state text,
  address text,
  invoice_footer text,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  name text not null,
  sku text not null,
  category text not null default 'General',
  selling_price numeric(12,2) not null check (selling_price >= 0),
  gst_rate numeric(5,2) not null default 0 check (gst_rate in (0,5,12,18,28)),
  stock_qty integer not null default 0 check (stock_qty >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (shop_id, sku)
);

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  invoice_number text not null,
  sold_at timestamptz not null default now(),
  taxable_amount numeric(12,2) not null default 0,
  gst_amount numeric(12,2) not null default 0,
  discount_amount numeric(12,2) not null default 0,
  grand_total numeric(12,2) not null default 0,
  created_by uuid references auth.users(id),
  unique (shop_id, invoice_number)
);

create table if not exists public.sale_items (
  id uuid primary key default gen_random_uuid(),
  sale_id uuid not null references public.sales(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  sku text,
  quantity integer not null check (quantity > 0),
  unit_price numeric(12,2) not null check (unit_price >= 0),
  gst_rate numeric(5,2) not null default 0,
  taxable_amount numeric(12,2) not null default 0,
  gst_amount numeric(12,2) not null default 0,
  line_total numeric(12,2) not null default 0
);

create index if not exists products_shop_idx on public.products(shop_id);
create index if not exists sales_shop_date_idx on public.sales(shop_id, sold_at desc);
create index if not exists sale_items_sale_idx on public.sale_items(sale_id);

-- Do not expose these tables to anonymous/public users. Configure Supabase Auth,
-- shop membership and restrictive RLS policies before enabling client access.
-- Never use the service_role key in a browser or public repository.

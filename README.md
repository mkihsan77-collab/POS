# CounterPOS Retail Billing Starter

## Included
- `index.html`: interactive browser demo with sample products, cart, GST-inclusive price calculations, discount, stock decrement, receipts, sales history, CSV export, reports and shop settings.
- `supabase-schema.sql`: starter PostgreSQL schema for a future Supabase-backed multi-device version.

## Run the demo locally
1. Download and extract the ZIP.
2. Open `index.html` in Chrome or Edge.
3. Demo data is stored in that browser's local storage. It is not synced to other devices.

## Publish a preview on GitHub Pages
1. Create a GitHub repository (for example `counterpos`).
2. Upload `index.html` to the repository root and commit.
3. Open repository Settings -> Pages.
4. Under Build and deployment, choose Deploy from a branch, branch `main`, folder `/(root)`, then Save.
5. Wait for the Pages deployment and open the URL shown in Settings -> Pages.

## Cloud database (Supabase)
The demo UI is not yet connected to Supabase. The SQL file is only the initial schema; it is not safe to expose real customer/business data until authentication, per-shop membership and row-level security (RLS) policies have been implemented and tested. Never place a Supabase service-role key in `index.html` or a public GitHub repository. A production version should also use a server-side transaction/RPC to atomically validate stock, create the sale and sale items, and decrement stock.

## GST note
The demo treats entered selling prices as GST-inclusive and calculates the embedded GST amount. It does not yet produce a legally validated GST tax invoice, split CGST/SGST vs IGST, or validate HSN/SAC/GSTIN. Confirm tax treatment with a qualified accountant before using it for actual business invoicing.

---
name: supabase-patterns
description: Supabase integration patterns for authentication, database queries, RLS policies, and real-time subscriptions. This skill should be used when writing Supabase client code, setting up auth flows, designing RLS policies, or generating TypeScript types from the database schema. Enforces security-first defaults — RLS always on, service role key never exposed client-side, auth state via server sessions.
---

# Supabase Patterns

## Overview

Secure, consistent patterns for Supabase in Next.js projects. Covers client initialisation, auth, database queries, RLS, storage, and real-time.

**Does NOT cover:** schema design or SQL migrations — use `db-architect` for those.

## Client Initialisation

Always use the `@supabase/ssr` package for Next.js (not `@supabase/supabase-js` directly).

```ts
// src/lib/supabase/client.ts — browser client
import { createBrowserClient } from '@supabase/ssr'
import type { Database } from '@/types/supabase'

export const createClient = () =>
  createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
```

```ts
// src/lib/supabase/server.ts — server client (App Router)
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import type { Database } from '@/types/supabase'

export const createServerSupabaseClient = async () => {
  const cookieStore = await cookies()
  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { cookies: { getAll: () => cookieStore.getAll() } }
  )
}
```

**NEVER** expose `SUPABASE_SERVICE_ROLE_KEY` to the client. Use it only in server-side API routes or edge functions.

## Auth Patterns

```ts
// Sign in with email + password
const { data, error } = await supabase.auth.signInWithPassword({ email, password })

// Sign in with OAuth (Google, GitHub)
await supabase.auth.signInWithOAuth({ provider: 'github', options: { redirectTo: '/auth/callback' } })

// Get current session (server-side)
const { data: { session } } = await supabase.auth.getSession()

// Middleware — protect routes
// src/middleware.ts: use updateSession from @supabase/ssr
```

Auth callback route must be at `/auth/callback/route.ts` and call `supabase.auth.exchangeCodeForSession(code)`.

## Database Queries

```ts
// SELECT with type safety
const { data, error } = await supabase
  .from('posts')
  .select('id, title, created_at')
  .eq('user_id', session.user.id)
  .order('created_at', { ascending: false })

// INSERT with returning
const { data, error } = await supabase
  .from('posts')
  .insert({ title, content, user_id: session.user.id })
  .select()
  .single()

// UPDATE
const { error } = await supabase
  .from('posts')
  .update({ title })
  .eq('id', postId)
  .eq('user_id', session.user.id) // always scope to user

// Always check error before using data
if (error) throw new Error(error.message)
```

## RLS Policy Patterns

Always use these as starting points (adapt per table):

```sql
-- Users can only read their own rows
CREATE POLICY "users_select_own" ON posts
  FOR SELECT USING (auth.uid() = user_id);

-- Users can only insert their own rows
CREATE POLICY "users_insert_own" ON posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can only update their own rows
CREATE POLICY "users_update_own" ON posts
  FOR UPDATE USING (auth.uid() = user_id);
```

## TypeScript Types

Generate types from schema:
```bash
npx supabase gen types typescript --project-id <ref> > src/types/supabase.ts
```

Never write Supabase types by hand — always generate from schema.

## Security Checklist

- [ ] `SUPABASE_SERVICE_ROLE_KEY` only in server-side code
- [ ] RLS enabled on every table (`db-architect` enforces this)
- [ ] Auth state checked server-side before data queries
- [ ] User ID scoped on all INSERT/UPDATE/DELETE queries
- [ ] Types generated from schema, not handwritten

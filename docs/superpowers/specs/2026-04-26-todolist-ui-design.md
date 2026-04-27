# Todo List UI Design — Pastel Row List

**Date:** 2026-04-26  
**Style:** Colorful / Playful — Pastel Row List  
**Text:** Black (#111) everywhere except white-on-colored buttons

---

## Overview

Redesign the frontend of the existing Rails 8 Todo App to use a colorful pastel style. No new backend changes — only HTML (ERB views) and CSS.

---

## Style Guide

| Element | Value |
|---|---|
| Font color | `#111` (black) — all text |
| Background (page) | Light pastel per page: `#f0fdf4` index, `#fdf4ff` form, `#fff7ed` show |
| Pending task row | `#fef3c7` (amber pastel) |
| Upcoming task row | `#fce7f3` (pink pastel) |
| Done task row | `#e0f2fe` (blue pastel), opacity 0.55 |
| Primary button | `#6366f1` indigo, white text |
| Danger button | `#ef4444` red, white text |
| Secondary button | `#e5e7eb` gray, black text |
| Border radius | `10px` rows, `12px` cards, `10px` buttons |
| Font family | `-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif` |

---

## Pages

### 1. Index (`/tasks`)
- Page header: date label + "🌈 My Tasks" title + "New Task" indigo button (right)
- Progress bar: indigo gradient, shows X of Y completed
- Task rows: pastel color by status, emoji icon, title (black bold), due date (black small), View + Edit buttons
- Done tasks: line-through title, blue pastel, reduced opacity

### 2. Form (`/tasks/new` and `/tasks/:id/edit`)
- White card with shadow
- Labels uppercase small black
- Inputs: full width, focus ring indigo
- Checkbox + label inline
- Submit button: indigo gradient full width

### 3. Show (`/tasks/:id`)
- Title highlighted in amber pastel box with left border
- Due date + Status in two gray info boxes side by side
- Edit (indigo) / Delete (red) / Back (gray) buttons row

---

## Files to Change

| File | Change |
|---|---|
| `app/assets/stylesheets/application.css` | Full rewrite with pastel design system |
| `app/views/layouts/application.html.erb` | Clean layout wrapper, remove Hello World |
| `app/views/tasks/index.html.erb` | Progress bar + pastel task rows |
| `app/views/tasks/_task.html.erb` | Remove (inline into index) |
| `app/views/tasks/_form.html.erb` | Styled white card form |
| `app/views/tasks/new.html.erb` | Page title + back link |
| `app/views/tasks/edit.html.erb` | Page title + back/show links |
| `app/views/tasks/show.html.erb` | Detail card + action buttons |

# Todo List Pastel UI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the Todo App frontend to use a colorful pastel style with black text, covering all 3 pages (index, form, show).

**Architecture:** Pure HTML + CSS changes only — no new gems, no JavaScript. Fix controller rendering bug first, then rewrite CSS design system, then update each view to use the new classes.

**Tech Stack:** Rails 8 ERB views, plain CSS (Propshaft), no frameworks

---

## File Map

| File | Action | Reason |
|---|---|---|
| `app/controllers/tasks_controller.rb` | Modify lines 8-9, 14-15 | index/show render JSON — must fix to render HTML |
| `app/assets/stylesheets/application.css` | Rewrite | New pastel design system |
| `app/views/layouts/application.html.erb` | Modify | Already clean, just verify |
| `app/views/tasks/index.html.erb` | Rewrite | Progress bar + pastel rows |
| `app/views/tasks/_task.html.erb` | Leave as-is | Not used after index rewrite |
| `app/views/tasks/_form.html.erb` | Rewrite | White card styled form |
| `app/views/tasks/new.html.erb` | Rewrite | Pastel page header |
| `app/views/tasks/edit.html.erb` | Rewrite | Pastel page header |
| `app/views/tasks/show.html.erb` | Rewrite | Detail card + action buttons |

---

## Task 1: Fix Controller — Stop Rendering JSON for HTML Requests

**Files:**
- Modify: `app/controllers/tasks_controller.rb`

- [ ] **Step 1: Open the controller and find the bug**

In `app/controllers/tasks_controller.rb`, the `index` action (line 8) and `show` action (line 14) call `render json:` directly instead of using `respond_to`. This means every browser visit gets JSON.

- [ ] **Step 2: Fix the index action**

Replace:
```ruby
def index
  @tasks = Task.all
  render json: @tasks
end
```

With:
```ruby
def index
  @tasks = Task.all
end
```

(Rails will automatically render `app/views/tasks/index.html.erb` when no render is specified)

- [ ] **Step 3: Fix the show action**

Replace:
```ruby
def show
  render json: @task
end
```

With:
```ruby
def show
end
```

- [ ] **Step 4: Verify in browser**

Start server: `bin/rails server`
Open: `http://127.0.0.1:3000/tasks`
Expected: HTML page (even if unstyled), NOT a JSON array

- [ ] **Step 5: Commit**

```bash
git add app/controllers/tasks_controller.rb
git commit -m "fix: render HTML instead of JSON for index and show actions"
```

---

## Task 2: Rewrite CSS — Pastel Design System

**Files:**
- Modify: `app/assets/stylesheets/application.css`

- [ ] **Step 1: Replace the entire CSS file with the pastel design system**

```css
/* RESET */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

/* BASE */
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  background-color: #f0fdf4;
  color: #111;
  line-height: 1.6;
}

/* LAYOUT */
.container {
  max-width: 680px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

/* PAGE HEADER */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 1.25rem;
}

.page-header-left .page-label {
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  color: #111;
  text-transform: uppercase;
}

.page-header-left h1 {
  font-size: 1.75rem;
  font-weight: 800;
  color: #111;
}

/* PROGRESS BAR */
.progress-wrap {
  margin-bottom: 0.4rem;
}

.progress-bar-bg {
  background: #e5e7eb;
  border-radius: 99px;
  height: 7px;
}

.progress-bar-fill {
  background: linear-gradient(90deg, #6366f1, #a78bfa);
  height: 7px;
  border-radius: 99px;
  transition: width 0.4s ease;
}

.progress-label {
  font-size: 0.75rem;
  color: #111;
  margin-bottom: 1rem;
  display: block;
}

/* TASK ROWS */
.task-row {
  border-radius: 10px;
  padding: 11px 14px;
  margin-bottom: 7px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.task-row.pending  { background: #fef3c7; }
.task-row.done     { background: #e0f2fe; opacity: 0.6; }
.task-row.upcoming { background: #fce7f3; }

.task-icon { font-size: 1.1rem; flex-shrink: 0; }

.task-info { flex: 1; min-width: 0; }

.task-name {
  font-weight: 600;
  font-size: 0.95rem;
  color: #111;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.task-name.strikethrough {
  text-decoration: line-through;
  color: #111;
}

.task-date {
  font-size: 0.75rem;
  color: #111;
}

/* BUTTONS */
.btn {
  display: inline-block;
  padding: 0.45rem 1rem;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 600;
  text-decoration: none;
  cursor: pointer;
  border: none;
  line-height: 1;
  transition: opacity 0.15s, transform 0.1s;
}

.btn:hover  { opacity: 0.85; transform: translateY(-1px); }
.btn:active { transform: translateY(0); }

.btn-primary   { background: #6366f1; color: white; }
.btn-danger    { background: #ef4444; color: white; }
.btn-secondary { background: #e5e7eb; color: #111; }

.btn-sm { padding: 0.3rem 0.7rem; font-size: 0.78rem; }

.btn-group { display: flex; gap: 6px; flex-shrink: 0; }

/* FORM */
.form-card {
  background: white;
  border-radius: 12px;
  padding: 1.75rem;
  box-shadow: 0 2px 10px rgba(0,0,0,0.07);
}

.form-group { margin-bottom: 1.1rem; }

label {
  display: block;
  font-size: 0.72rem;
  font-weight: 700;
  color: #111;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  margin-bottom: 0.35rem;
}

input[type="text"],
input[type="date"] {
  width: 100%;
  padding: 0.6rem 0.85rem;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  font-size: 0.95rem;
  color: #111;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}

input[type="text"]:focus,
input[type="date"]:focus {
  border-color: #6366f1;
  box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
}

.checkbox-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.checkbox-row input[type="checkbox"] {
  width: 17px;
  height: 17px;
  accent-color: #6366f1;
  cursor: pointer;
}

.checkbox-row label {
  font-size: 0.9rem;
  font-weight: 400;
  text-transform: none;
  letter-spacing: 0;
  margin-bottom: 0;
  cursor: pointer;
}

.btn-submit {
  width: 100%;
  padding: 0.75rem;
  background: linear-gradient(135deg, #6366f1, #a78bfa);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  margin-top: 0.5rem;
  transition: opacity 0.15s;
}

.btn-submit:hover { opacity: 0.88; }

/* SHOW PAGE */
.detail-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 10px rgba(0,0,0,0.07);
  margin-bottom: 1rem;
}

.detail-title-box {
  background: #fef3c7;
  border-radius: 8px;
  border-left: 4px solid #f59e0b;
  padding: 10px 14px;
  margin-bottom: 1rem;
}

.detail-title-box .detail-label {
  font-size: 0.68rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  color: #111;
  margin-bottom: 3px;
}

.detail-title-box .detail-value {
  font-size: 1.15rem;
  font-weight: 800;
  color: #111;
}

.detail-meta {
  display: flex;
  gap: 10px;
}

.detail-meta-box {
  background: #f3f4f6;
  border-radius: 8px;
  padding: 9px 12px;
  flex: 1;
  font-size: 0.82rem;
}

.detail-meta-box .detail-label {
  font-size: 0.68rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  color: #111;
  margin-bottom: 3px;
}

.detail-meta-box .detail-value {
  font-weight: 700;
  color: #111;
}

/* FLASH NOTICE */
.flash-notice {
  background: #d1fae5;
  color: #111;
  border-left: 4px solid #10b981;
  border-radius: 8px;
  padding: 0.8rem 1rem;
  margin-bottom: 1rem;
  font-size: 0.9rem;
  font-weight: 500;
}

/* BACK LINK */
.back-link {
  display: inline-block;
  color: #111;
  font-size: 0.88rem;
  text-decoration: none;
  margin-top: 0.75rem;
}

.back-link:hover { text-decoration: underline; }
```

- [ ] **Step 2: Verify file saved — check line count**

```bash
wc -l app/assets/stylesheets/application.css
```
Expected: ~220 lines

- [ ] **Step 3: Commit**

```bash
git add app/assets/stylesheets/application.css
git commit -m "feat: add pastel design system CSS"
```

---

## Task 3: Rewrite Index View

**Files:**
- Modify: `app/views/tasks/index.html.erb`

- [ ] **Step 1: Replace the file content**

```erb
<% content_for :title, "My Tasks" %>

<% if notice.present? %>
  <p class="flash-notice"><%= notice %></p>
<% end %>

<div class="page-header">
  <div class="page-header-left">
    <p class="page-label">Today</p>
    <h1>🌈 My Tasks</h1>
  </div>
  <%= link_to "＋ New Task", new_task_path, class: "btn btn-primary" %>
</div>

<%
  total     = @tasks.count
  completed = @tasks.count(&:completed)
  pct       = total > 0 ? (completed * 100 / total) : 0
%>

<div class="progress-wrap">
  <div class="progress-bar-bg">
    <div class="progress-bar-fill" style="width: <%= pct %>%"></div>
  </div>
</div>
<span class="progress-label"><%= completed %> of <%= total %> completed</span>

<div id="tasks">
  <% @tasks.each do |task| %>
    <%
      if task.completed
        row_class = "done"
        icon      = "✅"
      elsif task.due_date.present? && task.due_date < Date.today
        row_class = "pending"
        icon      = "⏰"
      else
        row_class = "upcoming"
        icon      = "📌"
      end
    %>
    <div class="task-row <%= row_class %>">
      <span class="task-icon"><%= icon %></span>

      <div class="task-info">
        <div class="task-name <%= 'strikethrough' if task.completed %>">
          <%= task.title %>
        </div>
        <% if task.due_date.present? %>
          <div class="task-date"><%= task.due_date.strftime("%-d %b %Y") %></div>
        <% end %>
      </div>

      <div class="btn-group">
        <%= link_to "View", task, class: "btn btn-secondary btn-sm" %>
        <%= link_to "Edit", edit_task_path(task), class: "btn btn-primary btn-sm" %>
      </div>
    </div>
  <% end %>
</div>
```

- [ ] **Step 2: Check in browser**

Open `http://127.0.0.1:3000/tasks`
Expected: pastel rows, progress bar, View/Edit buttons on each task

- [ ] **Step 3: Commit**

```bash
git add app/views/tasks/index.html.erb
git commit -m "feat: pastel task list with progress bar"
```

---

## Task 4: Rewrite Form Partial

**Files:**
- Modify: `app/views/tasks/_form.html.erb`

- [ ] **Step 1: Replace the file content**

```erb
<%= form_with(model: task) do |form| %>
  <% if task.errors.any? %>
    <div class="flash-notice" style="background:#fee2e2; border-left-color:#ef4444">
      <strong><%= pluralize(task.errors.count, "error") %>:</strong>
      <ul style="margin-top:0.3rem; padding-left:1.2rem">
        <% task.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="form-card">
    <div class="form-group">
      <%= form.label :title %>
      <%= form.text_field :title, placeholder: "What needs to be done?" %>
    </div>

    <div class="form-group">
      <%= form.label :due_date %>
      <%= form.date_field :due_date %>
    </div>

    <div class="form-group checkbox-row">
      <%= form.check_box :completed %>
      <%= form.label :completed, "Mark as completed" %>
    </div>

    <%= form.submit class: "btn-submit" %>
  </div>
<% end %>
```

- [ ] **Step 2: Commit**

```bash
git add app/views/tasks/_form.html.erb
git commit -m "feat: pastel styled form card"
```

---

## Task 5: Rewrite New and Edit Views

**Files:**
- Modify: `app/views/tasks/new.html.erb`
- Modify: `app/views/tasks/edit.html.erb`

- [ ] **Step 1: Replace new.html.erb**

```erb
<% content_for :title, "New Task" %>

<div class="page-header">
  <div class="page-header-left">
    <p class="page-label">Create</p>
    <h1>✨ New Task</h1>
  </div>
</div>

<%= render "form", task: @task %>

<%= link_to "← Back to tasks", tasks_path, class: "back-link" %>
```

- [ ] **Step 2: Replace edit.html.erb**

```erb
<% content_for :title, "Edit Task" %>

<div class="page-header">
  <div class="page-header-left">
    <p class="page-label">Editing</p>
    <h1>✏️ Edit Task</h1>
  </div>
</div>

<%= render "form", task: @task %>

<div style="display:flex; gap:0.75rem; margin-top:0.75rem">
  <%= link_to "← Back to tasks", tasks_path, class: "back-link" %>
</div>
```

- [ ] **Step 3: Check in browser**

Open `http://127.0.0.1:3000/tasks/new`
Expected: white card form with pastel page header, indigo gradient submit button

- [ ] **Step 4: Commit**

```bash
git add app/views/tasks/new.html.erb app/views/tasks/edit.html.erb
git commit -m "feat: pastel new and edit page headers"
```

---

## Task 6: Rewrite Show View

**Files:**
- Modify: `app/views/tasks/show.html.erb`

- [ ] **Step 1: Replace the file content**

```erb
<% content_for :title, @task.title %>

<% if notice.present? %>
  <p class="flash-notice"><%= notice %></p>
<% end %>

<div class="page-header">
  <div class="page-header-left">
    <p class="page-label">Detail</p>
    <h1>📋 Task</h1>
  </div>
</div>

<div class="detail-card">
  <div class="detail-title-box">
    <div class="detail-label">Title</div>
    <div class="detail-value"><%= @task.title %></div>
  </div>

  <div class="detail-meta">
    <div class="detail-meta-box">
      <div class="detail-label">Due Date</div>
      <div class="detail-value">
        <%= @task.due_date.present? ? @task.due_date.strftime("%-d %b %Y") : "—" %>
      </div>
    </div>
    <div class="detail-meta-box">
      <div class="detail-label">Status</div>
      <div class="detail-value">
        <%= @task.completed ? "✅ Done" : "⏳ Pending" %>
      </div>
    </div>
  </div>
</div>

<div class="btn-group">
  <%= link_to "Edit", edit_task_path(@task), class: "btn btn-primary" %>
  <%= button_to "Delete", @task, method: :delete, class: "btn btn-danger",
      data: { turbo_confirm: "Delete this task?" } %>
  <%= link_to "← Back", tasks_path, class: "btn btn-secondary" %>
</div>
```

- [ ] **Step 2: Check in browser**

Click "View" on any task from the index page
Expected: amber title box, two gray meta boxes (due date + status), three buttons

- [ ] **Step 3: Commit**

```bash
git add app/views/tasks/show.html.erb
git commit -m "feat: pastel task detail page"
```

---

## Task 7: Final Check — Full Flow

- [ ] **Step 1: Start server**

```bash
bin/rails server
```

- [ ] **Step 2: Test full CRUD flow**

1. Open `http://127.0.0.1:3000` — should redirect to tasks index
2. Click "New Task" — form should appear styled
3. Fill in title + due date, submit — should redirect to show page
4. Click "Edit" — form pre-filled, styled
5. Save — flash notice appears in green
6. Click "Delete" — confirmation dialog, then back to index
7. Progress bar updates as tasks are completed

- [ ] **Step 3: Done**

All pages are styled in pastel. No JSON in the browser.

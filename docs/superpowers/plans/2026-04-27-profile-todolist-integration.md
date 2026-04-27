# Profile–Todolist Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** เชื่อมหน้า Profile กับ Todolist โดย Profile แสดง task stats + แก้ไขข้อมูลได้ และหน้า Tasks มี profile chip ลิงก์ไป Profile

**Architecture:** สร้าง `Profile` model เก็บข้อมูลผู้ใช้ (1 row เสมอ) ใน PostgreSQL — ProfileController จัดการ show/edit/update — Tasks index แสดง profile chip partial ที่ดึงสถิติจาก @tasks

**Tech Stack:** Ruby on Rails 8.1, PostgreSQL, ERB templates, Minitest, vanilla CSS

---

## File Map

| Action | File |
|--------|------|
| Create | `db/migrate/TIMESTAMP_create_profiles.rb` |
| Create | `app/models/profile.rb` |
| Create | `test/models/profile_test.rb` |
| Modify | `config/routes.rb` |
| Modify | `app/controllers/profile_controller.rb` |
| Modify | `test/controllers/profile_controller_test.rb` |
| Modify | `app/controllers/tasks_controller.rb` |
| Modify | `app/assets/stylesheets/application.css` |
| Modify | `app/views/tasks/index.html.erb` |
| Create | `app/views/tasks/_profile_chip.html.erb` |
| Modify | `app/views/profile/show.html.erb` |
| Create | `app/views/profile/edit.html.erb` |

---

## Task 1: Profile Model + Migration

**Files:**
- Create: `db/migrate/TIMESTAMP_create_profiles.rb`
- Create: `app/models/profile.rb`
- Create: `test/models/profile_test.rb`

- [ ] **Step 1: Write failing model test**

สร้าง `test/models/profile_test.rb`:

```ruby
require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  test "first_or_create returns a profile with defaults" do
    profile = Profile.first_or_create(name: "Test User", university: "Test U")
    assert profile.persisted?
    assert_equal "Test User", profile.name
    assert_equal "Test U", profile.university
  end

  test "calling first_or_create twice returns same record" do
    Profile.first_or_create(name: "A", university: "B")
    assert_equal 1, Profile.count
    Profile.first_or_create(name: "A", university: "B")
    assert_equal 1, Profile.count
  end
end
```

- [ ] **Step 2: Run test — ยืนยันว่า fail**

```bash
bin/rails test test/models/profile_test.rb
```

Expected: `NameError: uninitialized constant Profile`

- [ ] **Step 3: Generate migration**

```bash
bin/rails generate migration CreateProfiles name:string university:string
```

เปิดไฟล์ migration ที่สร้าง (`db/migrate/TIMESTAMP_create_profiles.rb`) ตรวจว่าเป็นแบบนี้:

```ruby
class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :university
      t.timestamps
    end
  end
end
```

- [ ] **Step 4: Run migration**

```bash
bin/rails db:migrate
```

Expected: `== CreateProfiles: migrated`

- [ ] **Step 5: สร้าง Profile model**

สร้าง `app/models/profile.rb`:

```ruby
class Profile < ApplicationRecord
  validates :name, presence: true
end
```

- [ ] **Step 6: Run test — ยืนยันว่า pass**

```bash
bin/rails test test/models/profile_test.rb
```

Expected: `2 runs, 2 assertions, 0 failures, 0 errors`

- [ ] **Step 7: Commit**

```bash
git add db/migrate/ app/models/profile.rb test/models/profile_test.rb db/schema.rb
git commit -m "feat: add Profile model and migration"
```

---

## Task 2: Routes

**Files:**
- Modify: `config/routes.rb`

- [ ] **Step 1: แก้ routes.rb**

แทนที่บรรทัด:
```ruby
get "profile/show"
```
และ:
```ruby
get "/profile"=>"profile#show"
```

ด้วย:
```ruby
get  "profile",      to: "profile#show",   as: :profile
get  "profile/edit", to: "profile#edit",   as: :edit_profile
patch "profile",     to: "profile#update"
```

ไฟล์ `config/routes.rb` ที่ได้:

```ruby
Rails.application.routes.draw do
  get  "profile",      to: "profile#show",   as: :profile
  get  "profile/edit", to: "profile#edit",   as: :edit_profile
  patch "profile",     to: "profile#update"
  resources :tasks
  get "up" => "rails/health#show"
  root "tasks#index"
end
```

- [ ] **Step 2: ตรวจ routes**

```bash
bin/rails routes | grep profile
```

Expected output (3 บรรทัด):
```
      profile GET  /profile(.:format)      profile#show
 edit_profile GET  /profile/edit(.:format) profile#edit
              PATCH /profile(.:format)     profile#update
```

- [ ] **Step 3: Commit**

```bash
git add config/routes.rb
git commit -m "feat: update profile routes to support show/edit/update"
```

---

## Task 3: ProfileController — show, edit, update

**Files:**
- Modify: `app/controllers/profile_controller.rb`
- Modify: `test/controllers/profile_controller_test.rb`

- [ ] **Step 1: เขียน controller tests**

แทนที่เนื้อหาทั้งหมดใน `test/controllers/profile_controller_test.rb`:

```ruby
require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  DEFAULTS = { name: "Napassawan korsinprasert", university: "ศิลปากร CS" }.freeze

  setup do
    Profile.destroy_all
  end

  test "GET /profile returns 200" do
    get profile_path
    assert_response :success
  end

  test "GET /profile creates profile with defaults if none exists" do
    get profile_path
    assert_equal 1, Profile.count
    assert_equal "Napassawan korsinprasert", Profile.first.name
  end

  test "GET /profile/edit returns 200" do
    get edit_profile_path
    assert_response :success
  end

  test "PATCH /profile with valid params redirects to profile" do
    get profile_path  # ensure profile exists
    patch profile_path, params: { profile: { name: "Bam", university: "SU" } }
    assert_redirected_to profile_path
    assert_equal "Bam", Profile.first.name
    assert_equal "SU", Profile.first.university
  end

  test "PATCH /profile with blank name renders edit" do
    get profile_path
    patch profile_path, params: { profile: { name: "", university: "SU" } }
    assert_response :unprocessable_entity
  end
end
```

- [ ] **Step 2: Run tests — ยืนยันว่า fail**

```bash
bin/rails test test/controllers/profile_controller_test.rb
```

Expected: หลาย errors เพราะ controller ยังไม่มี actions

- [ ] **Step 3: เขียน ProfileController**

แทนที่เนื้อหาทั้งหมดใน `app/controllers/profile_controller.rb`:

```ruby
class ProfileController < ApplicationController
  DEFAULTS = { name: "Napassawan korsinprasert", university: "ศิลปากร CS" }.freeze

  def show
    @profile = Profile.first_or_create(DEFAULTS)
    @total   = Task.count
    @done    = Task.where(completed: true).count
    @left    = @total - @done
  end

  def edit
    @profile = Profile.first_or_create(DEFAULTS)
  end

  def update
    @profile = Profile.first_or_create(DEFAULTS)
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.expect(profile: [ :name, :university ])
  end
end
```

- [ ] **Step 4: Run tests — ยืนยันว่า pass**

```bash
bin/rails test test/controllers/profile_controller_test.rb
```

Expected: `5 runs, 5 assertions, 0 failures, 0 errors`

- [ ] **Step 5: Commit**

```bash
git add app/controllers/profile_controller.rb test/controllers/profile_controller_test.rb
git commit -m "feat: implement ProfileController show/edit/update"
```

---

## Task 4: CSS — Profile Styles

**Files:**
- Modify: `app/assets/stylesheets/application.css`

- [ ] **Step 1: เพิ่ม CSS ต่อท้าย `application.css`**

```css
/* ─── PROFILE CHIP ────────────────────────────────────────
   การ์ดโปรไฟล์เล็กๆ บนหน้า Tasks ก่อน task list
   ──────────────────────────────────────────────────────── */
.profile-chip {
  background: linear-gradient(135deg, #ede9fe, #fce7f3);
  border-radius: 10px;
  padding: 10px 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 0.75rem;
}

.profile-chip .av {
  width: 38px;
  height: 38px;
  background: linear-gradient(135deg, #6366f1, #a78bfa);
  border-radius: 99px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 800;
  font-size: 1rem;
  flex-shrink: 0;
}

.profile-chip .chip-info {
  flex: 1;
}

.profile-chip .chip-name {
  font-weight: 700;
  font-size: 0.85rem;
  color: #111;
}

.profile-chip .chip-stats {
  font-size: 0.72rem;
  color: #555;
}

.profile-chip .chip-link {
  font-size: 0.75rem;
  font-weight: 600;
  color: #6366f1;
  text-decoration: none;
  background: white;
  border-radius: 6px;
  padding: 4px 10px;
  flex-shrink: 0;
}

.profile-chip .chip-link:hover { opacity: 0.8; }

/* ─── PROFILE HERO ────────────────────────────────────────
   Section avatar ใหญ่ + ชื่อ + มหาวิทยาลัย บนหน้า Profile
   ──────────────────────────────────────────────────────── */
.profile-hero {
  background: linear-gradient(135deg, #ede9fe, #fce7f3);
  border-radius: 12px;
  padding: 1.75rem;
  text-align: center;
  margin-bottom: 1rem;
}

.profile-hero .av-lg {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, #6366f1, #a78bfa);
  border-radius: 99px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 800;
  font-size: 1.5rem;
  margin: 0 auto 0.75rem;
}

.profile-hero .hero-name {
  font-size: 1.2rem;
  font-weight: 800;
  color: #111;
}

.profile-hero .hero-uni {
  font-size: 0.85rem;
  color: #555;
  margin-top: 2px;
}

/* ─── STATS ROW ───────────────────────────────────────────
   3 กล่องสถิติ (Total / Done / Left) บนหน้า Profile
   ──────────────────────────────────────────────────────── */
.stats-row {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 8px;
  margin-bottom: 1rem;
}

.stat-box {
  background: white;
  border-radius: 10px;
  padding: 0.75rem;
  text-align: center;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

.stat-box .stat-num {
  font-size: 1.4rem;
  font-weight: 800;
  color: #6366f1;
}

.stat-box .stat-lbl {
  font-size: 0.65rem;
  color: #888;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  margin-top: 2px;
}
```

- [ ] **Step 2: Commit**

```bash
git add app/assets/stylesheets/application.css
git commit -m "feat: add profile chip, hero, and stats CSS"
```

---

## Task 5: Profile Views — show + edit

**Files:**
- Modify: `app/views/profile/show.html.erb`
- Create: `app/views/profile/edit.html.erb`

- [ ] **Step 1: เขียน `app/views/profile/show.html.erb`**

แทนที่เนื้อหาทั้งหมด:

```erb
<% content_for :title, "Profile" %>

<% if notice.present? %>
  <p class="flash-notice"><%= notice %></p>
<% end %>

<div class="profile-hero">
  <div class="av-lg"><%= @profile.name&.first&.upcase %></div>
  <div class="hero-name"><%= @profile.name %></div>
  <div class="hero-uni"><%= @profile.university %></div>
</div>

<div class="stats-row">
  <div class="stat-box">
    <div class="stat-num"><%= @total %></div>
    <div class="stat-lbl">Total</div>
  </div>
  <div class="stat-box">
    <div class="stat-num"><%= @done %></div>
    <div class="stat-lbl">Done</div>
  </div>
  <div class="stat-box">
    <div class="stat-num"><%= @left %></div>
    <div class="stat-lbl">Left</div>
  </div>
</div>

<div style="display:flex; gap:8px;">
  <%= link_to "✏️ Edit Profile", edit_profile_path, class: "btn btn-primary" %>
  <%= link_to "← Back to Tasks", root_path, class: "btn btn-secondary" %>
</div>
```

- [ ] **Step 2: สร้าง `app/views/profile/edit.html.erb`**

```erb
<% content_for :title, "Edit Profile" %>

<div class="page-header">
  <div class="page-header-left">
    <p class="page-label">Profile</p>
    <h1>✏️ Edit Profile</h1>
  </div>
</div>

<div class="form-card">
  <%= form_with url: profile_path, method: :patch do |f| %>
    <div class="form-group">
      <%= f.label :name, "Name" %>
      <%= f.text_field :name, value: @profile.name, class: "" %>
    </div>

    <div class="form-group">
      <%= f.label :university, "University" %>
      <%= f.text_field :university, value: @profile.university, class: "" %>
    </div>

    <%= f.submit "Save", class: "btn-submit" %>
  <% end %>
</div>

<%= link_to "Cancel", profile_path, class: "back-link" %>
```

- [ ] **Step 3: ตรวจ views ใน browser**

```bash
bin/rails server
```

เปิด [http://localhost:3000/profile](http://localhost:3000/profile) — ต้องเห็น hero card + 3 stat boxes + ปุ่ม Edit

เปิด [http://localhost:3000/profile/edit](http://localhost:3000/profile/edit) — ต้องเห็น form card 2 fields + ปุ่ม Save

- [ ] **Step 4: Commit**

```bash
git add app/views/profile/
git commit -m "feat: implement profile show and edit views"
```

---

## Task 6: Tasks Index — Profile Chip

**Files:**
- Modify: `app/controllers/tasks_controller.rb`
- Create: `app/views/tasks/_profile_chip.html.erb`
- Modify: `app/views/tasks/index.html.erb`

- [ ] **Step 1: เขียน test สำหรับ tasks#index assigns @profile**

เพิ่ม test ต่อท้ายใน `test/controllers/profile_controller_test.rb`:

```ruby
test "GET /tasks assigns @profile" do
  get root_path
  assert_response :success
  assert_not_nil assigns(:profile)
end
```

รัน test เพื่อยืนยัน fail:
```bash
bin/rails test test/controllers/profile_controller_test.rb
```

- [ ] **Step 2: เพิ่ม @profile ใน TasksController#index**

ใน `app/controllers/tasks_controller.rb` แก้ action `index`:

```ruby
def index
  @tasks   = Task.all
  @profile = Profile.first_or_create(name: "Napassawan korsinprasert", university: "ศิลปากร CS")
end
```

- [ ] **Step 2: สร้าง profile chip partial**

สร้าง `app/views/tasks/_profile_chip.html.erb`:

```erb
<%
  done = @tasks.count(&:completed)
  left = @tasks.count - done
%>
<div class="profile-chip">
  <div class="av"><%= profile.name&.first&.upcase %></div>
  <div class="chip-info">
    <div class="chip-name"><%= profile.name %> · <%= profile.university %></div>
    <div class="chip-stats"><%= done %> done · <%= left %> remaining</div>
  </div>
  <%= link_to "Profile →", profile_path, class: "chip-link" %>
</div>
```

- [ ] **Step 3: รัน test เพื่อยืนยัน pass**

```bash
bin/rails test test/controllers/profile_controller_test.rb
```

Expected: ทุก test pass รวมถึง test ใหม่ "GET /tasks assigns @profile"

- [ ] **Step 4: Render chip ใน tasks/index.html.erb**

ใน `app/views/tasks/index.html.erb` เพิ่ม render chip หลัง `<span class="progress-label">` และก่อน `<div id="tasks">`:

เปลี่ยน:
```erb
<span class="progress-label"><%= completed %> of <%= total %> completed</span>

<%# วน loop แต่ละ task %>
<div id="tasks">
```

เป็น:
```erb
<span class="progress-label"><%= completed %> of <%= total %> completed</span>

<%= render "profile_chip", profile: @profile %>

<%# วน loop แต่ละ task %>
<div id="tasks">
```

- [ ] **Step 5: ตรวจ Tasks page ใน browser**

เปิด [http://localhost:3000/](http://localhost:3000/)

ต้องเห็น profile chip (gradient card) หลัง progress bar พร้อมชื่อ + สถิติ + ลิงก์ "Profile →"

- [ ] **Step 6: Run all tests**

```bash
bin/rails test
```

Expected: ทุก test pass, 0 failures, 0 errors

- [ ] **Step 7: Commit**

```bash
git add app/controllers/tasks_controller.rb app/views/tasks/
git commit -m "feat: add profile chip to tasks index"
```

---

## Done ✓

ฟีเจอร์ครบตาม spec:
- หน้า Tasks มี profile chip พร้อม task stats จริง
- กด "Profile →" ไปหน้า `/profile` ได้
- หน้า Profile แสดงชื่อ, มหาวิทยาลัย, Total/Done/Left stats
- กด Edit Profile → แก้ชื่อ/มหาวิทยาลัยได้ → กลับหน้า Profile
- กด Back to Tasks กลับหน้า `/` ได้
- Style เข้ากับ pastel design system เดิม

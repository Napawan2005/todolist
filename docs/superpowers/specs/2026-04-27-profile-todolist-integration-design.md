# Profile–Todolist Integration Design

**Date:** 2026-04-27
**Status:** Approved

## Overview

เพิ่มหน้า Profile ที่แสดงข้อมูลผู้ใช้ + สถิติ task แบบ real-time และเชื่อมกับหน้า Tasks ผ่าน Profile Chip ที่แสดงบนสุดของ task list

## Data Model

### Profile (new table)

| Column     | Type   | Notes                          |
|------------|--------|--------------------------------|
| name       | string | ชื่อเต็ม เช่น "Napassawan korsinprasert" |
| university | string | เช่น "ศิลปากร CS"              |

- มีเพียง 1 row เสมอ ใช้ `Profile.first_or_create` ไม่มี auth/multi-user
- Seed ค่าเริ่มต้น: name = "Napassawan korsinprasert", university = "ศิลปากร CS"

## Routes

```
GET  /profile       → profile#show
GET  /profile/edit  → profile#edit
PATCH /profile      → profile#update
```

ลบ route เก่า `get "profile/show"` ออก

## Controllers

### ProfileController

**show**
- `@profile = Profile.first_or_create(name: "Napassawan korsinprasert", university: "ศิลปากร CS")`
- `@total = Task.count`
- `@done = Task.where(completed: true).count`
- `@left = @total - @done`

**edit**
- `@profile = Profile.first_or_create(...)`

**update**
- `@profile = Profile.first_or_create(...)`
- `@profile.update(profile_params)` → redirect to `/profile` on success
- render edit on failure

### TasksController#index (ปรับเพิ่ม)
- `@profile = Profile.first_or_create(name: "Napassawan korsinprasert", university: "ศิลปากร CS")`

## Views

### `tasks/index.html.erb` — เพิ่ม Profile Chip

Profile Chip วางหลัง progress bar ก่อน task list (ดู mockup Option C):

```
[Avatar initials] Bam · ศิลปากร CS     Profile →
                  3 done · 2 remaining
```

- Avatar: gradient indigo-purple, แสดงตัวอักษรแรกของชื่อ
- สถิติดึงจาก `@profile` + `Task.count` ที่ส่งจาก controller

### `profile/show.html.erb`

```
[Avatar ใหญ่]
ชื่อเต็ม
มหาวิทยาลัย

[Total] [Done] [Left]   ← stats boxes

[Edit Profile]  [← Back to Tasks]
```

### `profile/edit.html.erb`

Form card สไตล์เดียวกับ task form:
- Field: Name (text)
- Field: University (text)
- ปุ่ม Save (btn-submit gradient)
- ลิงก์ Cancel กลับ `/profile`

## Styling

ใช้ CSS class ที่มีอยู่แล้วทั้งหมด เพิ่มเฉพาะ:

| Class | ใช้ที่ |
|-------|--------|
| `.profile-chip` | การ์ดโปรไฟล์เล็กบนหน้า Tasks |
| `.profile-chip .av` | avatar วงกลม gradient |
| `.profile-hero` | section avatar ใหญ่บนหน้า Profile |
| `.stats-row` | grid 3 คอลัมน์สำหรับ stat boxes |
| `.stat-box` | กล่องสถิติแต่ละอัน |

## Success Criteria

- [ ] หน้า Tasks แสดง profile chip พร้อม task stats จริง
- [ ] กด "Profile →" ไปหน้า `/profile` ได้
- [ ] หน้า Profile แสดงชื่อ, มหาวิทยาลัย, stats (Total/Done/Left)
- [ ] กด Edit Profile → แก้ชื่อ/มหาวิทยาลัยได้ → กลับหน้า Profile
- [ ] กด Back to Tasks กลับหน้า `/` ได้
- [ ] Style เข้ากับ pastel design system เดิม

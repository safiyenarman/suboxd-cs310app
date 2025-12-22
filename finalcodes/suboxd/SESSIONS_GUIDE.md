# How to Add Sessions to Courses in Firebase

## Quick Guide

You need to add a `sessions` array field to each course document. Here's the exact format:

## Format Structure

```json
{
  "sessions": [
    {"day": "Monday", "time": "09:40"},
    {"day": "Wednesday", "time": "13:40"}
  ]
}
```

## Step-by-Step Instructions

1. Open Firebase Console → Firestore Database
2. Click on `courses` collection
3. Click on a course document (e.g., CS201)
4. Click **"+ Add field"** button
5. Set:
   - **Field name**: `sessions`
   - **Field type**: `array`
6. Click **"Add item"** for each class session
7. For each item:
   - Select type: **map**
   - Add field: `day` (string) - e.g., "Monday"
   - Add field: `time` (string) - e.g., "13:40"
8. Click **"Update"** to save

## Example Sessions for Your Courses

### CS201 (Similar to CS204 pattern)
```json
[
  {"day": "Monday", "time": "09:40"},
  {"day": "Monday", "time": "10:40"}
]
```

### CS303
```json
[
  {"day": "Tuesday", "time": "10:40"},
  {"day": "Thursday", "time": "10:40"}
]
```

### CS305
```json
[
  {"day": "Monday", "time": "13:40"},
  {"day": "Wednesday", "time": "13:40"}
]
```

### CS400
```json
[
  {"day": "Tuesday", "time": "14:40"},
  {"day": "Thursday", "time": "14:40"}
]
```

### CS404
```json
[
  {"day": "Monday", "time": "15:40"},
  {"day": "Wednesday", "time": "15:40"}
]
```

### ACC201
```json
[
  {"day": "Tuesday", "time": "09:40"},
  {"day": "Thursday", "time": "09:40"}
]
```

### MATH306
```json
[
  {"day": "Monday", "time": "11:40"},
  {"day": "Wednesday", "time": "11:40"}
]
```

## Important Notes

- **Day names**: Must be exactly: "Monday", "Tuesday", "Wednesday", "Thursday", or "Friday"
- **Time format**: Use 24-hour format "HH:MM" (e.g., "09:40", "13:40", "15:40")
- **Case sensitive**: Day names must start with capital letter
- You can add multiple sessions per course (typically 2-3 per week)

## Already Have Sessions

These courses already have sessions (don't modify):
- ✅ CS204
- ✅ CS300

## Need Sessions Added

Add sessions to these courses:
- ⚠️ ACC201
- ⚠️ CS201
- ⚠️ CS303
- ⚠️ CS305
- ⚠️ CS400
- ⚠️ CS404
- ⚠️ MATH306

**Note**: Adjust the times and days in the examples above to match the actual schedule for each course!


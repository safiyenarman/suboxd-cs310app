# Firebase Sessions Data Template

## Format for Adding Sessions to Courses

Each course document in Firebase needs a `sessions` field with the following structure:

```json
{
  "sessions": [
    {
      "day": "Monday",
      "time": "09:40"
    },
    {
      "day": "Wednesday", 
      "time": "13:40"
    }
  ]
}
```

## Days Available
- Monday
- Tuesday
- Wednesday
- Thursday
- Friday

## Time Format
- Use 24-hour format: "HH:MM"
- Examples: "08:40", "09:40", "10:40", "11:40", "12:40", "13:40", "14:40", "15:40", "16:40"

## How to Add Sessions in Firebase Console

1. Go to Firebase Console → Firestore Database
2. Select the `courses` collection
3. Click on a course document (e.g., CS201, CS303, etc.)
4. Click "+ Add field"
5. Field name: `sessions`
6. Field type: Select "array"
7. Click "Add item" for each session
8. For each session item:
   - Type: Select "map"
   - Add two fields:
     - `day` (string): e.g., "Monday"
     - `time` (string): e.g., "13:40"
9. Click "Update" to save

## Example Sessions for Common Course Patterns

### Pattern 1: Two sessions per week (same time, different days)
```json
[
  {"day": "Monday", "time": "09:40"},
  {"day": "Wednesday", "time": "09:40"}
]
```

### Pattern 2: Two sessions per week (different times)
```json
[
  {"day": "Monday", "time": "09:40"},
  {"day": "Wednesday", "time": "13:40"}
]
```

### Pattern 3: Three sessions per week
```json
[
  {"day": "Monday", "time": "09:40"},
  {"day": "Wednesday", "time": "09:40"},
  {"day": "Friday", "time": "09:40"}
]
```

### Pattern 4: Single session per week
```json
[
  {"day": "Tuesday", "time": "13:40"}
]
```

## Courses That Need Sessions Added

Based on your Firebase, these courses need sessions:
- ACC201
- CS201
- CS303
- CS305
- CS400
- CS404
- MATH306

(CS204 and CS300 already have sessions)


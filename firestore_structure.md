# 🏊‍♂️ Structure Firestore - YouCanOtoWenIt

## Collections Principales

### `users/{userId}/`
- `email` (string)
- `createdAt` (timestamp)
- `lastLogin` (timestamp)

### `users/{userId}/swimmers/{swimmerId}`
- `id` (string)
- `name` (string)
- `birthDate` (timestamp)
- `category` (string)
- `club` (string)
- `coach` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

### `users/{userId}/physicalEvaluations/{evaluationId}`
- `id` (string)
- `swimmerId` (string)
- `testDate` (timestamp)
- `weight` (number)
- `height` (number)
- `bodyFat` (number)
- ...etc

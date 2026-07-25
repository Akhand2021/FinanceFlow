# Authentication Module - API Documentation

## Base URL

```
http://localhost:3000/api/v1
```

## Endpoints

### 1. Register

**POST** `/auth/register`

Create a new user account.

**Request Body:**

```json
{
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "password": "SecurePass123",
  "confirmPassword": "SecurePass123"
}
```

**Success Response (201):**

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "profilePicture": null,
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 86400,
      "tokenType": "Bearer"
    }
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

**Error Response (409):**

```json
{
  "success": false,
  "message": "Email already registered",
  "data": null,
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

---

### 2. Login

**POST** `/auth/login`

Authenticate user and get tokens.

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "SecurePass123"
}
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "profilePicture": null,
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 86400,
      "tokenType": "Bearer"
    }
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

**Error Response (401):**

```json
{
  "success": false,
  "message": "Invalid credentials",
  "data": null,
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

---

### 3. Refresh Token

**POST** `/auth/refresh`

Get a new access token using refresh token.

**Request Body:**

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 86400,
    "tokenType": "Bearer"
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

---

### 4. Get Current User

**GET** `/auth/me`

Get authenticated user profile.

**Headers:**

```
Authorization: Bearer {accessToken}
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "profilePicture": null,
    "currency": "USD",
    "language": "en",
    "theme": "light"
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

---

### 5. Logout

**POST** `/auth/logout`

Revoke all refresh tokens and logout user.

**Headers:**

```
Authorization: Bearer {accessToken}
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "message": "Logged out successfully"
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

---

## JWT Token Structure

**Header:**

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**Payload (Access Token):**

```json
{
  "sub": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "iat": 1704110400,
  "exp": 1704196800
}
```

---

## Error Codes

| Code | Message                  | Description                       |
| ---- | ------------------------ | --------------------------------- |
| 400  | Validation failed        | Missing or invalid request fields |
| 401  | Invalid credentials      | Wrong email or password           |
| 401  | No token provided        | Missing Authorization header      |
| 401  | Invalid token            | Malformed or expired token        |
| 409  | Email already registered | User exists with this email       |
| 500  | Internal server error    | Server-side error                 |

---

## cURL Examples

### Register

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "password": "SecurePass123",
    "confirmPassword": "SecurePass123"
  }'
```

### Login

```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePass123"
  }'
```

### Get Current User

```bash
curl -X GET http://localhost:3000/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Logout

```bash
curl -X POST http://localhost:3000/api/v1/auth/logout \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Refresh Token

```bash
curl -X POST http://localhost:3000/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "YOUR_REFRESH_TOKEN"
  }'
```

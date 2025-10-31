# KostongApp Backend

## Setup
1. Install dependencies:
   npm install

2. Ensure .env is configured (already included).
   - MONGO_URI
   - PORT
   - JWT_SECRET

3. Start server:
   npm run dev
   or
   npm start

The API will run at http://localhost:3000

## Notes
- Login compares plaintext password (per current request). For production, migrate to bcrypt.

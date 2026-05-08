import express from 'express';
import bcrypt from 'bcrypt';
import { userDb } from '../modules/database/index.js';
import { getConnection } from '../modules/database/connection.js';
import { generateToken, authenticateToken } from '../middleware/auth.js';

const router = express.Router();
const db = getConnection();

// [COBOT] Login throttle — IP 단위 brute-force 방어
const LOGIN_ATTEMPTS = new Map();
const THROTTLE_MAX = 5;
const THROTTLE_WINDOW_MS = 10 * 60 * 1000;
const THROTTLE_BLOCK_MS = 60 * 60 * 1000;
function _clientIp(req) {
  return (req.headers['cf-connecting-ip']
    || (req.headers['x-forwarded-for'] || '').split(',')[0].trim()
    || req.ip
    || req.connection?.remoteAddress
    || 'unknown').toString();
}
function loginThrottleCheck(req, res, next) {
  const ip = _clientIp(req);
  const now = Date.now();
  const e = LOGIN_ATTEMPTS.get(ip);
  if (e && e.blockUntil && e.blockUntil > now) {
    const remainSec = Math.ceil((e.blockUntil - now) / 1000);
    return res.status(429).json({ error: `Too many failed login attempts. Try again in ${remainSec}s.` });
  }
  next();
}
function _recordFail(ip) {
  const now = Date.now();
  let e = LOGIN_ATTEMPTS.get(ip);
  if (!e || (now - e.firstAt) > THROTTLE_WINDOW_MS) {
    e = { count: 0, firstAt: now };
  }
  e.count += 1;
  if (e.count >= THROTTLE_MAX) {
    e.blockUntil = now + THROTTLE_BLOCK_MS;
  }
  LOGIN_ATTEMPTS.set(ip, e);
  return e;
}
function _recordSuccess(ip) { LOGIN_ATTEMPTS.delete(ip); }

// Check auth status and setup requirements
router.get('/status', async (req, res) => {
  try {
    const hasUsers = await userDb.hasUsers();
    res.json({ 
      needsSetup: !hasUsers,
      isAuthenticated: false // Will be overridden by frontend if token exists
    });
  } catch (error) {
    console.error('Auth status error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// User registration (setup) - only allowed if no users exist
router.post('/register', async (req, res) => {
  // [PATCHED] Disabled: admin already registered.
  return res.status(403).json({ error: 'Registration disabled' });

  try {
    const { username, password } = req.body;
    
    // Validate input
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }
    
    if (username.length < 3 || password.length < 6) {
      return res.status(400).json({ error: 'Username must be at least 3 characters, password at least 6 characters' });
    }
    
    // Use a transaction to prevent race conditions
    db.prepare('BEGIN').run();
    try {
      // Check if users already exist (only allow one user)
      const hasUsers = userDb.hasUsers();
      if (hasUsers) {
        db.prepare('ROLLBACK').run();
        return res.status(403).json({ error: 'User already exists. This is a single-user system.' });
      }
      
      // Hash password
      const saltRounds = 12;
      const passwordHash = await bcrypt.hash(password, saltRounds);
      
      // Create user
      const user = userDb.createUser(username, passwordHash);
      
      // Generate token
      const token = generateToken(user);
      
      db.prepare('COMMIT').run();

      // Update last login (non-fatal, outside transaction)
      userDb.updateLastLogin(user.id);

      res.json({
        success: true,
        user: { id: user.id, username: user.username },
        token
      });
    } catch (error) {
      db.prepare('ROLLBACK').run();
      throw error;
    }
    
  } catch (error) {
    console.error('Registration error:', error);
    if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
      res.status(409).json({ error: 'Username already exists' });
    } else {
      res.status(500).json({ error: 'Internal server error' });
    }
  }
});

// User login (throttled)
router.post('/login', loginThrottleCheck, async (req, res) => {
  const ip = _clientIp(req);
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }

    const user = userDb.getUserByUsername(username);
    if (!user) {
      _recordFail(ip);
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
      _recordFail(ip);
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    _recordSuccess(ip);
    const token = generateToken(user);
    userDb.updateLastLogin(user.id);

    res.json({
      success: true,
      user: { id: user.id, username: user.username },
      token
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get current user (protected route)
router.get('/user', authenticateToken, (req, res) => {
  res.json({
    user: req.user
  });
});

// Logout (client-side token removal, but this endpoint can be used for logging)
router.post('/logout', authenticateToken, (req, res) => {
  // In a simple JWT system, logout is mainly client-side
  // This endpoint exists for consistency and potential future logging
  res.json({ success: true, message: 'Logged out successfully' });
});

export default router;

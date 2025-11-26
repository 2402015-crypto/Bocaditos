import jwt from 'jsonwebtoken';

const TOKEN_SECRET = process.env.JWT_SECRET || 'development-secret-key';
const TOKEN_EXPIRATION = process.env.JWT_EXPIRATION || '1h';

export const generateToken = (payload, options = {}) => {
  return jwt.sign(payload, TOKEN_SECRET, { expiresIn: TOKEN_EXPIRATION, ...options });
};

export const authMiddleware = (request, response, next) => {
  const authHeader = request.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    response.status(401).json({ error: 'Authorization token required' });
    return;
  }

  const token = authHeader.slice(7);

  try {
    const decoded = jwt.verify(token, TOKEN_SECRET);
    request.user = decoded;
    next();
  } catch (error) {
    response.status(401).json({ error: 'Invalid or expired token' });
  }
};

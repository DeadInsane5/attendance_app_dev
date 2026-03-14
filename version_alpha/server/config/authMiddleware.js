const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
        const token = authHeader.split(' ')[1];

        // Hardcoded secret as per current setup (no .env)
        const SECRET_KEY = 'dmce_attendance_secret_key'; 

        jwt.verify(token, SECRET_KEY, (err, decoded) => {
            if (err) {
                return res.status(403).json({ message: "Forbidden: Invalid or expired token" });
            }
            
            req.user = decoded; 
            next();
        });
    } else {
        res.status(401).json({ message: "Unauthorized: Access denied, no token provided" });
    }
};

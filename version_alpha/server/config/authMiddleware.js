import jwt from "jsonwebtoken";

export const authMiddleware = async (req, res, next) => {
    const authHeader = req.headers.authorization;

    // 1. Check for token existence
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ message: "Unauthorized: No token provided" });
    }

    const token = authHeader.split(' ')[1];
    const SECRET_KEY = 'dmce_attendance_secret_key'; 

    try {
        // 2. Use a Promise-based verification for async/await flow
        // We verify the token and "await" the result
        const decoded = await new Promise((resolve, reject) => {
            jwt.verify(token, SECRET_KEY, (err, data) => {
                if (err) reject(err);
                resolve(data);
            });
        });

        // 3. Attach user and move forward
        req.user = decoded; 
        next();
        
    } catch (error) {
        // 4. Handle errors (Expired, Invalid, etc.) using the catch block
        return res.status(403).json({ message: "Forbidden: Invalid or expired token" });
    }
};
import express from "express";
import { createDepartments, getDepartments } from "../controllers/deptController.js";
// 1. Import the middleware
import { authMiddleware } from "../config/authMiddleware.js";

const router = express.Router();

// Public: Anyone can see the departments
router.get("/departments", getDepartments);

// Protected: Only authorized users can create departments
router.post("/departments", authMiddleware, createDepartments);

export default router;
import express from "express"
import { createDepartments, getDepartments } from "../controllers/deptController.js"

const router = express.Router()

router.get("/departments", getDepartments)
router.post("/departments", createDepartments)

export default router

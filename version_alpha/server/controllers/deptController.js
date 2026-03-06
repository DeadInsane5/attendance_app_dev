import db from "../config/db.js"

export const createDepartments = async (req, res) => {
  const { deptName } = req.body
  try {
    const sql = "INSERT INTO department (dept_name) values (?)"

    const [results] = await db.query(sql, [deptName])
    res.status(200).json({ id: results.insertId, message: "department added successfully" })

  } catch (error) {
    res.status(500).json({ message: error.message })
  }
}

export const getDepartments = async (req, res) => {
  try {
    const sql = "SELECT * FROM department"

    const [rows] = await db.query(sql, [])
    res.status(200).json(rows)

  } catch (error) {
    res.status(500).json({ message: error.message })
  }
}

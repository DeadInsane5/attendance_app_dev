import express from "express"
import cors from "cors"
import deptRouter from "./routes/deptRoute.js"

const PORT = 3000

const app = express()

app.use(cors())
app.use(express.json())

app.use("/api/v1", deptRouter)

app.get("/", (req, res) => {
  res.send("API is running")
})

app.listen(PORT, () => {
  console.log(`Server running on port: ${PORT}`)
})

import express from "express";
import dotenv from "dotenv";
import sql2 from "mysql2";
dotenv.config();
const PORT = process.env.PORT;
const mysql = sql2;



const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  });

const app = express();
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

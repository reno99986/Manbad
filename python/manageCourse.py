from flask_restful import Resource
from koneksi import mysql
from flask import request, make_response

class ManageCourse(Resource):
    def post(self):
        data = request.json
        course_name = data.get("course_name")
        course_description = data.get("course_description")
        course_price = data.get("course_price")
        course_duration = data.get("course_duration")
        course_level = data.get("course_level")
        course_language = data.get("course_language")
        course_certificate = data.get("course_certificate")
        course_image = data.get("course_image")
        course_category = data.get("course_category")
        course_instructor = data.get("course_instructor")
        course_rating = data.get("course_rating")
        course_status = data.get("course_status")
        course_created_at = data.get("course_created_at")
        course_updated_at = data.get("course_updated_at")

        if not course_name or not course_description or not course_price or not course_duration or not course_level or not course_language or not course_certificate or not course_image or not course_category or not course_instructor or not course_rating or not course_status or not course_created_at or not course_updated_at:
            return {"message": "All fields are required"}, 400

        connection = mysql.connection
        cursor = connection.cursor()
        cursor.execute("INSERT INTO Courses (instructor_id, course_name, description,duration,created_at,updated_at ) VALUES (%s, %s, %s, %s, %s, %s)", (course_instructor, course_name, course_description, course_duration, course_created_at, course_updated_at))
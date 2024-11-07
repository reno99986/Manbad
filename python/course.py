from flask_restful import Resource
from koneksi import mysql
from flask import jsonify, request

class Courses(Resource):
    def get(self, id=None):
        cursor = mysql.connection.cursor()

        if id:
            course = cursor.fetchone()
            cursor.execute("SELECT * FROM CourseDetails WHERE course_id=%s", (id,))
            cursor.close()

            if course:
                return jsonify(course)
            return jsonify({"message": "Course not found"}), 404
        
        else:
            cursor.execute("SELECT * FROM Courses")
            rows = cursor.fetchall()
            cursor.close()
            return jsonify(rows)

    def post(self):
        data = request.json
        course_name = data.get('course_name')
        course_description = data.get('course_description')
        course_price = data.get('course_price')
        course_duration = data.get('course_duration')
        course_category = data.get('course_category')
        course_level = data.get('course_level')
        course_language = data.get('course_language')
        course_certificate = data.get('course_certificate')
        course_rating = data.get('course_rating')
        course_review = data.get('course_review')
        course_image = data.get('course_image')
        course_video = data.get('course_video')
        course_trainer = data.get('course_trainer')

        # Basic input validation
        if not all([course_name, course_description, course_price, course_duration, course_category, course_level, course_language, course_certificate, course_rating, course_review, course_image, course_video, course_trainer]):
            return {"message": "All fields are required"}, 400

        connection = mysql.connection
        try:
            with connection.cursor() as cursor:
                cursor.callproc('AddCourse', (course_name, course_description, course_price, course_duration, course_category, course_level, course_language, course_certificate, course_rating, course_review, course_image, course_video, course_trainer))
                result = cursor.fetchone()
                
                # Consume any remaining result sets
                while cursor.nextset():
                    pass

            connection.commit()

            if result:
                message = result[0]
                if message == 'Course added successfully.':
                    return {"message": message}, 201
                else:
                    return {"message": message}, 400
            else:
                return {"message": "Course addition failed"}, 400
        except Exception as e:
            return {"message": str(e)}, 500
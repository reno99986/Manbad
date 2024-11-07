from flask import request, jsonify
from flask_restful import Resource
from koneksi import mysql

class Assessments(Resource):
    def post(self):
        data = request.json
        userId = data.get("userId")
        courseId = data.get("courseId")
        cursor = mysql.connection.cursor()
        try:
             cursor.callproc("EnrollUserInCourse",(userId,courseId))
             result = cursor.fetchone()
             cursor.close()
             mysql.connection.commit()
           
             if result:
                message = result[0]
                if message == 'User enrolled successfully.':
                    return {"message": message}, 201
                else:
                    return {"message": message}, 400
             else:
                return {"message": "Enroll failed Occured"}, 400
        
        except Exception as e:
            return {"message": "An error occurred", "error": str(e)}, 500
        



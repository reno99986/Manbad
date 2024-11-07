from flask import Flask, request
from flask_restful import Resource, Api
from koneksi import mysql
import bcrypt

SECRET_KEY = "Test"
class Login(Resource):

# WIPP

    def post(self):
        data = request.json
        email = data.get("email")
        password = data.get("password")
        if not email and not password:
            return {"message": "Email and password are required"}, 400
        connection = mysql.connection
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM Users WHERE email=%s", (email,))

        user = cursor.fetchone()
        cursor.close()
        if user:
             passwd = bcrypt.checkpw(password.encode('utf-8'), user[2].encode('utf-8'))
             print(passwd)

             if passwd:
                return {"message": "Login successful."}, 200
             else:
                return {"message": "Login failed."}, 401
                

        





    # def post(self):
    #     data = request.json
    #     email = data.get("email")
    #     password = bcrypt.checkpw
    #     print(password)

    #     if not email or not password:
    #         return {"message": "Email and password are required"}, 400

    #     connection = mysql.connection
    #     try:
    #         with connection.cursor() as cursor:
    #             cursor.callproc('LoginUser', (email, password))
    #             result = cursor.fetchone()
                
    #             # Consume any remaining result sets
    #             while cursor.nextset():
    #                 pass
    #         print(result)
    #         connection.commit()
    #         if result:
    #             # Assuming the stored procedure returns columns in this order
    #             message, session_token, user_role = result

    #             if message == 'Login successful.':
    #                 return {
    #                     "message": message,
    #                     "SessionToken": session_token,
    #                     "UserRole": user_role
    #                 }, 200
    #             else:
    #                 return {"message": message}, 401
    #         else:
    #             return {"message": "Login failed"}, 401

    #     except Exception as e:
    #         connection.rollback()
    #         return {"message": "An error occurred", "error": str(e)}, 500

# Don't forget to add this resource to your API
# api.add_resource(Login, '/login')
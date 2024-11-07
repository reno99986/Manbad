from flask_restful import Resource
from koneksi import mysql
from flask import jsonify, request
import bcrypt   

class Users(Resource):
    def get(self, id=None):
        cursor = mysql.connection.cursor()

        if id:
            cursor.execute("SELECT * FROM Users WHERE user_id=%s", (id,))
            user = cursor.fetchone()
            cursor.close()

            if user:
                return jsonify(user)
            return jsonify({"message": "User not found"}), 404
        
        else:
            cursor.execute("SELECT * FROM Users")
            rows = cursor.fetchall()
            cursor.close()
            return jsonify(rows)

    def post(self):
        data = request.json
        name = data.get('name')

        password = bcrypt.hashpw(data['password'].encode('utf-8'),bcrypt.gensalt())
        email = data.get('email')
        phone_number = data.get('phone_number')
        address = data.get('address')
        bio = data.get('bio')
        expertise = data.get('expertise')
        role = data.get('role')

        # Basic input validation
        if not all([name, password, email, role]):
            return {"message": "Name, password, email, and role are required"}, 400

        connection = mysql.connection
        try:
            with connection.cursor() as cursor:
                cursor.callproc('RegisterUser', (name, password, email, phone_number, address, bio, expertise, role))
                result = cursor.fetchone()
                
                # Consume any remaining result sets
                while cursor.nextset():
                    pass

            connection.commit()

            if result:
                message = result[0]
                if message == 'Registration successful.':
                    return {"message": message}, 201
                else:
                    return {"message": message}, 400
            else:
                return {"message": "Registration failed"}, 400

        except Exception as e:
            connection.rollback()
            return {"message": "An error occurred", "error": str(e)}, 500

        

        
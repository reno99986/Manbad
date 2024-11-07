from flask import Flask
from flask_restful import Api
from koneksi import mysql
from users import Users
from auth import Login
from course import Courses
from enroll import Enroll
app = Flask(__name__)
api = Api(app)



app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'phpmyadmin'
app.config['MYSQL_PASSWORD'] = 'qwertyqw'
app.config['MYSQL_DB'] = 'LMSTEST'

mysql.init_app(app)

api.add_resource(Users, '/users', '/users/<int:id>')
api.add_resource(Login, '/login')
api.add_resource(Courses, '/courses', '/courses/<int:id>')
api.add_resource(Enroll , "/enroll")
if __name__ == '__main__':
    app.run(debug=True)

    
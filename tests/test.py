import cloudfiles

conn = cloudfiles.get_connection(username='account:user',api_key='password',authurl='http://localhost:11000/v1.0')

conn.create_container('testcontainer')
cont = conn.get_container('testcontainer')

obj = cont.create_object('testobject')
obj.write("If you read this, the test was successful")

obj = cont.get_object('testobject')
print obj.read()

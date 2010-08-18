#!/usr/bin/env python

import os
import cloudfiles

print "Creating account"
status = os.system('swift-auth-create-account account user password')

if status != 0:
          print ("FAIL: the account could not be created")

print "Getting Connection"
conn = cloudfiles.get_connection(username='account:user',api_key='password',authurl='http://localhost:11000/v1.0')

print "Creating Container"
conn.create_container('testcontainer')
cont = conn.get_container('testcontainer')

print "Creating Object"
obj = cont.create_object('testobject')
obj.write("If you read this, the test was successful")

print "Retrieving Object"
obj = cont.get_object('testobject')
print obj.read()

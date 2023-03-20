        #!/bin/bash
        yum update -y
        yum install python3 -y
        pip3 install flask
        yum install git -y
        cd /home/ec2-user
        FOLDER=https://raw.githubusercontent.com/balaban1432/my-projects/main/aws/projects/Project-001-Roman-Numerals-Converter/
        wget ${FOLDER}app.py
        mkdir templates && cd templates
        wget ${FOLDER}templates/index.html
        wget ${FOLDER}templates/result.html
        cd ..
        python3 app.py 
        
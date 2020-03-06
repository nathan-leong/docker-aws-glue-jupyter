docker build -t gluecontainer:latest .

#creates a binded volume directory target from current directory
docker run -p 8888:8888 -v "$(pwd)"/target:/home/jovyan/target gluecontainer:latest


Installation guide 
https://support.wharton.upenn.edu/help/glue-debugging

servlet conflict issue reference:
https://ileriseviye.wordpress.com/2014/12/04/how-to-fix-class-javax-servlet-filterregistrations-signer-information-does-not-match-signer-information-of-other-classes-in-the-same-package-when-unit-testing-with-spark-streaming/

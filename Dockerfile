FROM ppc64le/tomcat:9.0.22-jdk11-adoptopenjdk-openj9
RUN chmod a+w /usr/local/tomcat/bin/
RUN echo $JAVA_HOME
WORKDIR /usr/local/tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

FROM nalai/centos6-oraclejava8
MAINTAINER Nathaniel Lai "lai.nathaniel@gmail.com"

#Install Tomcat 8

#Download the latest Tomcat 8 and copy to /usr/local
RUN yum -y install tar
RUN wget "http://apache.uberglobalmirror.com/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz" \
		 -O /apache-tomcat-8.0.24.tar.gz && \
	    tar xvzf /apache-tomcat-8.0.24.tar.gz && \
    rm /apache-tomcat-8.0.24.tar.gz && \
    rm -rf /apache-tomcat-8.0.24/webapps/docs && \
    rm -rf /apache-tomcat-8.0.24/webapps/examples && \
    mv /apache-tomcat-8.0.24/ /usr/local/ && \	
    yum clean all
	
# Need this to avoid the following message:
# The APR based Apache Tomcat Native library which allows optimal performance in
# production environments was not found on the java.library.path
# This step will give warnings but they don't seem to cause any problems
RUN yum -y install epel-release
#RUN yum -y install tomcat-native && \
#    yum clean all

#RUN rpm -Uvh http://fedora.uberglobalmirror.com/epel//7/x86_64/e/epel-release-7-5.noarch.rpm && \
#    yum -y install tomcat-native && \
#    yum clean all

# Overwrite the default to set a user/password for Tomcat manager
ADD tomcat-users.xml /usr/local/apache-tomcat-8.0.24/conf/tomcat-users.xml

# TODO enable SSL by creating a key, moving it to right tomcat location and edit server.xml
# RUN keytool -genkey -alias tomcat -keyalg RSA
# RUN mv /root/.keystore /usr/share/tomcat6/
# <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
#              maxThreads="150" scheme="https" secure="true"
#              clientAuth="false" sslProtocol="TLS" />
#EXPOSE 8443

# Expose the standard Tomcat ports
EXPOSE 8080

# Start Tomcat in the background
ENV CATALINA_HOME /usr/local/apache-tomcat-8.0.24
CMD exec ${CATALINA_HOME}/bin/catalina.sh run
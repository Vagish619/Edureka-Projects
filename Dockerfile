# Base image
FROM devopsedu/webapp

# Set working directory
WORKDIR /var/www/html/

# Copy code files from host to container
COPY projCert/. .

# Start apachectl
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
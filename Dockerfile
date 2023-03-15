# Base image
FROM devopsedu/webapp

# Set working directory
WORKDIR /var/www/html/

# Copy code files from host to container
COPY projCert/. .

# removing index.html
RUN rm /var/www/html/index.html

# Start apachectl
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
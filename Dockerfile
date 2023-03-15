# Base image
FROM devopsedu/webapp

# Set working directory
WORKDIR /var/www/html/

# Copy code files from host to container
COPY . .

# Expose port 80 to host port 9000
EXPOSE 9000:80

# Start apachectl
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
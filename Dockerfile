FROM openjdk:11
RUN mkdir /app
ADD build/libs/basic-*.jar /app/app.jar
ADD runboot.sh /app/
RUN bash -c 'touch /app/app.jar'
WORKDIR /app
RUN chmod a+x runboot.sh
EXPOSE 8080
CMD /app/runboot.sh
RUN echo "Asia/Shanghai" > /etc/timezone;
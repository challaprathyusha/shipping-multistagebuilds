
#Build

FROM maven as build

WORKDIR /opt/shipping

COPY pom.xml /opt/shipping/
# this downloads the dependencies to run the java application
RUN mvn dependency:resolve 
COPY src /opt/shipping/src/
# this will give the .jar/.war file which is an artifactory
RUN mvn package 

# this is JRE based on alpine OS
FROM openjdk:8-jre-alpine3.9
EXPOSE 8080

WORKDIR /opt/shipping

ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql

COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar
CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]
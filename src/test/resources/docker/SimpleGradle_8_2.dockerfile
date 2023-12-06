FROM gradle:8.2.1-jdk11

# Do not change SRC_DIR, value is expected by tests
ENV SRC_DIR=/opt/project/src

ENV JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2"


# Install git
RUN apt-get update && apt-get install -y git

# Set up the test project
RUN mkdir -p ${SRC_DIR}


RUN git clone --depth 1 https://github.com/atiqzaman-dsi/simple-gradle.git ${SRC_DIR}

RUN cd ${SRC_DIR} && gradle build
# OpenJDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim AS build

# 필요한 패키지 목록을 업데이트하고 Python과 gcc 설치
RUN apt-get update && apt-get install -y python3 python3-pip gcc curl unzip && rm -rf /var/lib/apt/lists/*

# Gradle 설치
ARG GRADLE_VERSION=7.6
RUN curl -sL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip \
    && unzip gradle.zip -d /opt \
    && rm gradle.zip \
    && ln -s /opt/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle

# 애플리케이션 소스 복사
WORKDIR /app
COPY . .

# 애플리케이션 빌드
RUN gradle build --no-daemon

# 실행 단계용 이미지
FROM openjdk:21-jdk-slim

# 환경 변수 설정 (기본값)
ENV SPRING_PROFILES_ACTIVE=prod

# 빌드한 JAR 파일을 실행 이미지에 복사
COPY --from=build /app/build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
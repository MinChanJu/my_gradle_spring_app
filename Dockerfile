# OpenJDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim

# 작업 디렉토리 설정
WORKDIR /app

# 환경 변수 설정 (기본값)
ENV SPRING_PROFILES_ACTIVE=prod

# 필요한 패키지 목록을 업데이트하고 Python과 gcc 설치
RUN apt-get update && apt-get install -y python3 python3-pip gcc && rm -rf /var/lib/apt/lists/*

# Gradle Wrapper 및 관련 파일 복사
COPY build.gradle .
COPY settings.gradle .
COPY gradlew ./
COPY gradle/ ./gradle/

# 프로젝트 소스 복사
COPY src/ ./src/

# Gradle 빌드 실행 (테스트 건너뛰기)
RUN ./gradlew build -x test

# 빌드된 JAR 파일 경로 확인
RUN ls build/libs/

# 애플리케이션 JAR 파일을 컨테이너로 복사
COPY build/libs/my_gradle_spring_app-0.0.1-SNAPSHOT.jar app.jar

# 환경 변수 설정
ARG SPRING_DATASOURCE_URL
ARG SPRING_DATASOURCE_USERNAME
ARG SPRING_DATASOURCE_PASSWORD

ENV SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
ENV SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
ENV SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
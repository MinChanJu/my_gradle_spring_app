# OpenJDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 목록을 업데이트하고 Python과 gcc 설치
RUN apt-get update && apt-get install -y python3 python3-pip gcc && rm -rf /var/lib/apt/lists/*

# Gradle Wrapper 및 관련 파일 복사
COPY build.gradle .
COPY settings.gradle .
COPY gradlew ./
COPY gradle/ ./gradle/

# 프로젝트 소스 복사
COPY src/ ./src/

# Gradle 빌드 실행
RUN ./gradlew clean build

# 빌드된 JAR 파일 경로 확인
RUN ls build/libs/

# 애플리케이션 JAR 파일을 컨테이너로 복사
COPY build/libs/my_gradle_spring_app-0.0.1-SNAPSHOT.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
# OpenJDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim AS build

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 목록을 업데이트하고 Python과 gcc 설치
RUN apt-get update && apt-get install -y python3 python3-pip gcc && rm -rf /var/lib/apt/lists/*

# Gradle Wrapper와 필요한 파일 복사
COPY gradlew ./
COPY gradle/ gradle/
COPY build.gradle.kts .
COPY settings.gradle.kts .

# 의존성 캐시를 위해 Gradle 빌드 스크립트만 복사하고 의존성 다운로드
RUN ./gradlew --no-daemon build -x test

# 모든 소스 코드 복사
COPY . .

# 프로젝트 빌드
RUN ./gradlew --no-daemon build

# 실행을 위한 새로운 베이스 이미지 사용
FROM openjdk:21-jdk-slim

# 환경 변수 설정 (기본값)
ENV SPRING_PROFILES_ACTIVE=prod

# 빌드된 JAR 파일을 복사
COPY --from=build /app/build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
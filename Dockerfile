# OpenJDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim

# 환경 변수 설정 (기본값)
ENV SPRING_PROFILES_ACTIVE=prod

# 필요한 패키지 목록을 업데이트하고 Python과 gcc 설치
RUN apt-get update && apt-get install -y python3 python3-pip gcc && rm -rf /var/lib/apt/lists/*

# 애플리케이션 빌드 - build 폴더를 Docker 컨텍스트로 복사하지 않고, Gradle을 이용하여 직접 빌드
COPY . /app
WORKDIR /app
RUN ./gradlew bootJar -x test

# 애플리케이션 JAR 파일을 컨테이너로 복사
COPY build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
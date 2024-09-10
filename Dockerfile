# OpenJDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim

# 환경 변수 설정 (기본값)
ENV SPRING_PROFILES_ACTIVE=prod

# 필요한 패키지 목록을 업데이트하고 Python과 gcc 설치
RUN apt-get update && apt-get install -y python3 python3-pip gcc && rm -rf /var/lib/apt/lists/*

# 애플리케이션 JAR 파일을 컨테이너로 복사
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
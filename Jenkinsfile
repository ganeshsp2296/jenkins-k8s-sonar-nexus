pipeline {
    agent any

    environment {
        DOCKER_REPO = "nexus:8082"
        SONARQUBE_SERVER = "MySonarQube"
        MAVEN_HOME = tool name: 'Maven', type: 'maven'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'ganesh.developer', url: 'https://github.com/<your-username>/jenkins-k8s-sonar-nexus.git'
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh "${MAVEN_HOME}/bin/mvn sonar:sonar"
                }
            }
        }

        stage('Build with Timestamp') {
            steps {
                script {
                    env.BUILD_TIMESTAMP = sh(script: "date +%Y%m%d-%H%M", returnStdout: true).trim()
                }
                sh "${MAVEN_HOME}/bin/mvn clean package"
                sh "cp target/myapp-1.0.jar target/myapp-1.0-${BUILD_TIMESTAMP}.jar"
            }
        }

        stage('Upload to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: 'nexus:8081',
                    groupId: 'com.ganesh.app',
                    version: "1.0-${BUILD_TIMESTAMP}",
                    repository: 'maven-releases',
                    credentialsId: 'nexus-credentials',
                    artifacts: [
                        [artifactId: 'myapp', classifier: '', file: "target/myapp-1.0-${BUILD_TIMESTAMP}.jar", type: 'jar']
                    ]
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_REPO}/myapp:${BUILD_TIMESTAMP} --build-arg JAR_FILE=target/myapp-1.0-${BUILD_TIMESTAMP}.jar ."
            }
        }

        stage('Push Docker Image to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "docker login ${DOCKER_REPO} -u $USERNAME -p $PASSWORD"
                    sh "docker push ${DOCKER_REPO}/myapp:${BUILD_TIMESTAMP}"
                }
            }
        }
    }
}

pipeline {
    agent any

    environment {
        SONARQUBE = 'MySonarQube'
        NEXUS_URL = 'http://nexus:8081'
        DOCKER_REPO = 'nexus:8082'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'ganesh.developer', url: 'https://github.com/ganeshsp2296/jenkins-k8s-sonar-nexus.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh 'sonar-scanner -Dsonar.projectKey=my-app -Dsonar.sources=./src'
                }
            }
        }

        stage('Build Artifact') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: 'nexus:8081',
                    groupId: 'com.ganesh.app',
                    version: "1.0.${BUILD_NUMBER}",
                    repository: 'maven-releases',
                    artifacts: [
                        [artifactId: 'myapp', classifier: '', file: 'target/myapp-1.0.jar', type: 'jar']
                    ]
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${DOCKER_REPO}/myapp:1.0.${BUILD_NUMBER} .
                docker login ${DOCKER_REPO} -u admin -p admin123
                docker push ${DOCKER_REPO}/myapp:1.0.${BUILD_NUMBER}
                '''
            }
        }
    }
}

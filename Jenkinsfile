pipeline {
    agent any
    environment {
        
        DOCKER_IMAGE_NAME = "vagish999/train-schedule"
        DOCKER_HUB_LOGIN = "vagish999"
        DOCKER_HUB_PASSWORD = "Kakashi@111"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
				sh "chmod +x gradlew"
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
            
            steps {
                steps {
                    sh "
                        sudo docker build -t ${DOCKER_IMAGE_NAME} .
                        sudo docker run --name temp_container ${DOCKER_IMAGE_NAME} sh -c 'echo Hello, World!'
                        sudo docker commit temp_container ${DOCKER_IMAGE_NAME}
                        sudo docker rm temp_container
                    "
                }
            }
         }
         stage('Push Docker Image') {
                
                steps {
                    sh "
                        sudo docker login -u ${DOCKER_HUB_LOGIN} -p ${DOCKER_HUB_PASSWORD}
                        sudo docker tag ${DOCKER_IMAGE_NAME}:latest ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}
                        sudo docker tag ${DOCKER_IMAGE_NAME}:latest ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:latest
                        sudo docker push ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}
                        sudo docker push ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:latest
                    "
                }
         }
        stage('CanaryDeploy') {
            
            environment { 
                CANARY_REPLICAS = 1
            }
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube-canary.yml',
                    enableConfigSubstitution: true
                )
            }
        }
        stage('DeployToProduction') {
            when {
                branch 'project2'
            }
            environment { 
                CANARY_REPLICAS = 0
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube-canary.yml',
                    enableConfigSubstitution: true
                )
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
}

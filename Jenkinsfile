pipeline {
    agent any
    environment {
        
        DOCKER_IMAGE_NAME = "vagish999/train-schedule"
        DOCKER_HUB_LOGIN = "vagish999"
        DOCKER_HUB_PASSWORD = "Kakashi@111"
        BUILD_NUMBER = 1
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
				sh "chmod +x gradlew"
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
            
            
                steps {
                    
                    sh "sudo docker build -t ${DOCKER_IMAGE_NAME} ."
                        sh "sudo docker run --name temp_container ${DOCKER_IMAGE_NAME} sh -c 'echo Hello, World!'"
                        sh "sudo docker commit temp_container ${DOCKER_IMAGE_NAME}"
                        sh "sudo docker rm temp_container"
                    
                }
            
         }
         stage('Push Docker Image') {
                
                steps {
                    
                        sh "sudo docker login -u ${DOCKER_HUB_LOGIN} -p ${DOCKER_HUB_PASSWORD}"
                        sh "sudo docker tag ${DOCKER_IMAGE_NAME}:latest ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "sudo docker tag ${DOCKER_IMAGE_NAME}:latest ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:latest"
                        sh "sudo docker push ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "sudo docker push ${DOCKER_HUB_LOGIN}/${DOCKER_IMAGE_NAME}:latest"
                    
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

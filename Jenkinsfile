pipeline {
    agent any
    environment {
        
        DOCKER_IMAGE_NAME = "train-schedule"
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
                                               
                    
                }
            
         }
         stage('Push Docker Image') {
                
                steps {
                    
                        sh "sudo docker login -u ${DOCKER_HUB_LOGIN} -p ${DOCKER_HUB_PASSWORD}"
                       
                    
                }
         }
        stage('CanaryDeploy') {
                environment { 
                    CANARY_REPLICAS = 1
                }
                steps {
                    sh '
                       sudo kubectl --kubeconfig=kubeconfig apply -f train-schedule-kube-canary.yml
                    '
                }
            }
        stage('DeployToProduction') {
            
            environment { 
                CANARY_REPLICAS = 0
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                sh '
                    sudo kubectl --kubeconfig=kubeconfig apply -f train-schedule-kube-canary.yml
                '
                sh '
                    sudo kubectl --kubeconfig=kubeconfig apply -f train-schedule-kube.yml
                '
            }
        }

    }
}

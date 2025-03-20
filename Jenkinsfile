pipeline{
    agent any
    stages{
        stage("build docker image"){
            steps{
                sh 'docker build -t omarabulella/task6:latest .'
            }
        }
         stage("Push to registry "){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')])
                {
               sh '''
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker push omarabulella/task6:latest
               '''
                }
            }
        }
         stage("Deploy to production"){
            steps{
            sshagent(['ec2-ssh-key']){
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]){
                sh """
                echo "hello"
                ssh -o StrictHostKeyChecking=no ubuntu@34.219.63.92 '''
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker pull omarabulella/task6:latest
                docker stop nginx-container || true
                docker rm nginx-container || true
                docker run -d --name nginx-container -p 80:80 omarabulella/task6:latest
                '''
              
                """
               }
               }

            }
        }
      
    }
      triggers {
        githubPush()
        }
    
}
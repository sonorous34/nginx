pipeline {
    agent any
    environment {
        TYPE = "build"
        PROJECT = "cicd"
        PHASE = "prod"
        GIT_URL = "https://github.com/sonorous34/nginx.git"
        GIT_CREDENTIALS_ID="jenkins"
        BRANCH_NAME ="main"
        K8S_NAMESPACE = "cicd"
        K8S_SECRET = "kube-secret"
        K8S_IMAGENAME = "nginx:latest"
        K8S_DEPLOYMENT ="nginx-deployment.yaml"
    }
    
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: "10", artifactNumToKeepStr: "10"))
        timeout(time: 60, unit: 'MINUTES')
    }
    
    tools {
        jdk "openjdk"
        maven "maven"
        gradle "gradle"
    }
    
    stages {
        stage('00-Set Environment') {
            steps {
                script {
                    if (PHASE == 'dev') {
                        BRANCH = 'develop'
                    } else if (PHASE == 'prod') {
                        BRANCH = 'main'
                    }
                }
            }
        } 
        stage('01-Checkout') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", url: "${GIT_URL}", branch: "${BRANCH}", poll: true, changelog: true
            }
        }
        stage('02-K8S CICD') {
            steps {
                echo '02-K8S CICD deploy..'
                sh 'kubectl --kubeconfig=/var/jenkins_home/.kube/config create ns ${K8S_NAMESPACE}'
                sh 'kubectl -n cicd --kubeconfig=/var/jenkins_home/.kube/config create secret generic kube-secret --from-literal=username=jenkins --from-literal=password=admin1234!'
                sh 'kubectl -n ${K8S_NAMESPACE} --kubeconfig=/var/jenkins_home/.kube/config apply -f nginx-deployment.yaml'
              }
            }
        }
    }
}

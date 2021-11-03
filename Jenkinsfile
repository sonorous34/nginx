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
              withKubeConfig([credentialsId: 'root', caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1UQXlPVEF4TkRNd01sb1hEVE14TVRBeU56QXhORE13TWxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTCtqCjB6M011Y0RPMnQycWp1ZTdKTmtHQXd5S0NkZTFPdjdhRy9YcEtiQWNvM3NKSGhGT3VOUEVDY3FKNmlqOUpjMXUKSWJDZEwrWUIvNUQwWkNiN1phdkF3bmdZQ2VkMnI2MUdWN3NaMm1paVVSWHF0Tk1JeUtwRFJ4UlY0ZUxhRVBSZQpSUlRheDdnNGxGVllxL2RUZ0tBb3NBN213Nmh3QmNGblVzRFFHSTJPdmFPUXhJbjFqMFFjV1ZTbHdBTUh4cGMyCitVYXl4ZjZMYUxVVXkxZE5HZE9pQy8zZ0tUb1JYWWlMTE44WTVScE95WC9rbERWa3VWL1B1TXlUdGo1Q2pud0YKSDNsd2RQdmJuSTZQYlgvWUNhWURPRjZKRGp5VnBPREE3R09HTExvRjlTMzFnUTUybXRzd1R0LzRvQ3cwVTVINQp5WENkNFB6STdxZWR2SDVZc3RNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZIVzhoUmxtTXNCK0pLTmxwbHV5N2FuUHBVdEdNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSU5yaU9kOE5FMWZpVlRzRG9uNApUU2p3cnA0OVVpVjRNK3V2bE1zYVBYc01RVzFzcnhMbmFHVTlQWWR4cE9WZkVWZ0RZNWdIeW80YUJGTXFpd0VaCkpzRXp6R0NiOGp6UlVxN0hqK0g0ZHdKZHdzeE1ua1RGcXRDdjA1TzdBSmMxbFBPcGhuVWN0QnRHZGJWd0lhZ2IKTkQ0RkpDSXhsWFNYOTZDMlBtT0kybzk2T3BINlRMSjhWUkNkcVNhcFlQcUdQZVZ1QWpiMEovblBQUDZEWmlPVgpRTVljZ3FlcDRMV2Z6WkZqSWdxM2RWWGRLeFdXMDJPeFpoY2YyOVJuRkliSWtnZEpWc0NHbU5IbjJVRmlYd1p0ClJKSFJGQ1pqbGwrdm1CcWlCQ09PVSt5QVJac2Nwd1hiUGlKbWwweU1lYkN2bUdnQUt4NXNrUjlSNko1TENFbFEKaTlNPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', serverUrl: 'https://192.168.142.120:6443', contextName: 'kubernetes-admin@kubernetes', clusterName: 'kubernetes', namespace: 'cicd']) {
                echo '02-K8S CICD deploy..'
                sh 'kubectl --kubeconfig=/var/jenkins_home/.kube/config create ns ${K8S_NAMESPACE}'
                sh 'kubectl -n cicd --kubeconfig=/var/jenkins_home/.kube/config create secret generic kube-secret --from-literal=username=jenkins --from-literal=password=admin1234!'
                sh 'kubectl -n ${K8S_NAMESPACE} --kubeconfig=/var/jenkins_home/.kube/config apply -f nginx-deployment.yaml'
              }
            }
        }
    }
}

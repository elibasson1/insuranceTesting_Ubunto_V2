pipeline {
    agent {
        label 'DemoNodeAgent'
    }

    environment {
        ALLURE_RESULTS_DIR = "allure-results-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t insurance-tests .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
                sh """
                mkdir -p ${ALLURE_RESULTS_DIR}
                docker run --rm -v \$PWD/${ALLURE_RESULTS_DIR}:/app/allure-results insurance-tests
                """
            }
        }
    }

    post {
        always {
            allure([
                includeProperties: false,
                jdk: '',
                commandline: 'ALLURE_LINUX',   // השם שנתת בהגדרת הכלי
                reportBuildPolicy: 'ALWAYS',
                 results: [[path: 'insuranceTesting_Ubunto/Tests/allure-results']]
            ])
        }
    }
}
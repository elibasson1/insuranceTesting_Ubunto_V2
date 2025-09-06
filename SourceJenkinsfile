pipeline {
    agent {
        label 'DemoNodeAgent'
    }

    options {
        skipDefaultCheckout(true)
    }

    environment {
        ALLURE_RESULTS_DIR = "allure-results-${env.BUILD_NUMBER}"
        ALLURE_REPORT_DIR = "allure-report-html-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t insurance-tests .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo 'Running tests inside Docker container'
                sh """
                mkdir -p ${ALLURE_RESULTS_DIR}
                docker run --rm -v \$PWD/${ALLURE_RESULTS_DIR}:/app/allure-results insurance-tests
                """
            }
        }
    }

    post {
        always {
            echo 'Generating Allure Report and Archiving'
            script {
                sh """
                mkdir -p ${ALLURE_REPORT_DIR}
                docker run --rm \
                    -v \$PWD/${ALLURE_RESULTS_DIR}:/app/allure-results \
                    -v \$PWD/${ALLURE_REPORT_DIR}:/app/allure-report-html \
                    insurance-tests allure generate /app/allure-results --clean -o /app/allure-report-html
                """

                sh "zip -r allure-report-${env.BUILD_NUMBER}.zip ${ALLURE_RESULTS_DIR} ${ALLURE_REPORT_DIR}"

                archiveArtifacts artifacts: "allure-report-${env.BUILD_NUMBER}.zip", followSymlinks: false
            }
        }
    }
}

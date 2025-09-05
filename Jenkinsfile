pipeline {
    agent {
        label 'DemoNodeAgent'
    }
    options {
        skipDefaultCheckout(true) // מונע checkout אוטומטי על ה-controller
    }
    stages {
        stage('Checkout & Build') {
            steps {
                echo 'Cleaning workspace of previous build'
                sh 'rm -rf insuranceTesting_Ubunto'
               // echo 'Cloning repository and building project'
                sh 'git clone https://github.com/elibasson1/insuranceTesting_Ubunto.git'

                dir('insuranceTesting_Ubunto') {
                    sh 'python3 -m venv venv'
                    sh 'venv/bin/pip install -r requirements.txt'
                }
            }
        }
        stage('Run Tests') {
            steps {
                echo 'Running tests'
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                    dir('insuranceTesting_Ubunto/Tests') {
                        sh "pytest -v -s --alluredir=allure-results"
                    }
                }
            }
        }
    }
    post {
        always {
            dir('insuranceTesting_Ubunto/Tests') {
                // Generate the Allure report from the correct results folder
                sh 'allure generate allure-results --clean -o allure-report-html'

                // Compress both allure-results and allure-report-html into a single ZIP file
                sh 'zip -r allure-report.zip allure-results allure-report-html'

                // Archive the single ZIP file to the Jenkins server
                archiveArtifacts artifacts: 'allure-report.zip', followSymlinks: false
            }
        }
    }
}
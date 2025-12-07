pipeline {
    agent any
    
    parameters {
        choice(
            name: 'EXECUTION_MODE',
            choices: ['headless', 'headed'],
            description: 'Choose browser execution mode'
        )
        choice(
            name: 'TEST_SUITE',
            choices: ['all', 'smoke', 'regression'],
            description: 'Select which tests to run'
        )
    }
    
    environment {
        ROBOT_TEST_DIR = "${WORKSPACE}/tests"
        ROBOT_REPORTS_DIR = "${WORKSPACE}/reports"
        HEADLESS_MODE = "${params.EXECUTION_MODE == 'headless' ? 'True' : 'False'}"
        TEST_BROWSER = 'edge'
    }
    
    triggers {
        pollSCM('H/5 * * * *')
    }
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        timestamps()
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 1: Repository Checkout'
                echo '═══════════════════════════════════════════════════════════'
                
                checkout scm
                
                echo '✓ Repository checked out successfully'
                echo "✓ Branch: ${GIT_BRANCH}"
                echo "✓ Commit: ${GIT_COMMIT}"
                
                bat 'echo "Workspace contents:" && dir'
            }
        }
        
        stage('Environment Verification') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 2: Environment Verification'
                echo '═══════════════════════════════════════════════════════════'
                
                bat 'python --version'
                bat 'robot --version'
                bat 'where msedgedriver'
                
                echo '✓ All environment checks passed'
            }
        }
        
        stage('Dependencies Installation') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 3: Dependencies Installation'
                echo '═══════════════════════════════════════════════════════════'
                
                bat 'pip install -r requirements.txt'
            }
        }
        
        stage('Test Preparation') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 4: Test Preparation'
                echo '═══════════════════════════════════════════════════════════'
                
                bat '''
                    if not exist "%ROBOT_REPORTS_DIR%" mkdir %ROBOT_REPORTS_DIR%
                    echo ✓ Test directories created
                '''
            }
        }
        
        stage('Execute Robot Tests') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 5: Execute Robot Tests'
                echo '═══════════════════════════════════════════════════════════'
                
                echo "Execution Mode: ${HEADLESS_MODE}"
                echo "Browser: ${TEST_BROWSER}"
                
                bat '''
                    robot --variable HEADLESS:%HEADLESS_MODE% ^
                          --variable BROWSER:%TEST_BROWSER% ^
                          --outputdir %ROBOT_REPORTS_DIR% ^
                          --loglevel INFO ^
                          %ROBOT_TEST_DIR%
                '''
                
                echo '✓ Robot Framework tests executed'
            }
        }
        
        stage('Results Publication') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 6: Results Publication'
                echo '═══════════════════════════════════════════════════════════'
                
                step([
                    $class: 'RobotPublisher',
                    disableArchiveOutput: false,
                    logFileName: 'log.html',
                    outputFileName: 'output.xml',
                    outputPath: 'reports',
                    reportFileName: 'report.html'
                ])
                
                echo '✓ Test results published'
            }
        }
    }
    
    post {
        always {
            echo '═══════════════════════════════════════════════════════════'
            echo 'POST PIPELINE ACTIONS'
            echo '═══════════════════════════════════════════════════════════'
            
            archiveArtifacts(
                artifacts: 'reports/**/*.html,reports/**/*.xml,reports/**/*.png',
                onlyIfSuccessful: false,
                allowEmptyArchive: true
            )
        }
        
        success {
            echo '✓ BUILD SUCCESSFUL'
        }
        
        failure {
            echo '✗ BUILD FAILED'
        }
    }
}

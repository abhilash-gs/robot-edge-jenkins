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
        ROBOT_TEST_DIR = "${WORKSPACE}\\tests"
        ROBOT_REPORTS_DIR = "${WORKSPACE}\\reports"
        // We'll compute HEADLESS_MODE as a string in the pipeline steps below to avoid Groovy-in-env pitfalls
        TEST_BROWSER = 'edge'
        VENV_PY = "${WORKSPACE}\\.venv\\Scripts\\python.exe"
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

        stage('Prepare Python venv & Install Dependencies') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 2: Prepare Python venv & Install Dependencies'
                echo '═══════════════════════════════════════════════════════════'

                // Create venv and install dependencies into it. Use explicit python invocation so PATH isn't required.
                bat '''
                    echo === Ensure pip and venv exist ===
                    python --version
                    python -m pip --version

                    echo === Create venv in workspace ===
                    if not exist ".venv" (
                      python -m venv .venv
                    ) else (
                      echo ".venv already exists"
                    )

                    echo === Upgrade pip inside venv ===
                    "%WORKSPACE%\\.venv\\Scripts\\python.exe" -m pip install --upgrade pip

                    if exist requirements.txt (
                      echo === Installing requirements.txt into venv ===
                      "%WORKSPACE%\\.venv\\Scripts\\python.exe" -m pip install -r requirements.txt
                    ) else (
                      echo "requirements.txt not present -> installing robotframework only"
                      "%WORKSPACE%\\.venv\\Scripts\\python.exe" -m pip install robotframework
                    )

                    echo === venv install complete ===
                    "%WORKSPACE%\\.venv\\Scripts\\python.exe" -m robot --version
                '''
            }
        }

        stage('Environment Verification') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 3: Environment Verification'
                echo '═══════════════════════════════════════════════════════════'

                // Prefer venv python; fall back to system python for checks
                bat '''
                    echo === Using venv (if available) to verify environment ===
                    if exist "%WORKSPACE%\\.venv\\Scripts\\python.exe" (
                      echo "Using %WORKSPACE%\\.venv\\Scripts\\python.exe"
                      "%WORKSPACE%\\.venv\\Scripts\\python.exe" --version
                      "%WORKSPACE%\\.venv\\Scripts\\python.exe" -m robot --version
                    ) else (
                      echo "Venv not found — falling back to system python"
                      python --version
                      python -m robot --version
                    )

                    echo === msedgedriver on PATH? ===
                    where msedgedriver || echo "msedgedriver not found on PATH"
                '''

                echo '✓ Environment verification complete'
            }
        }

        stage('Test Preparation') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 4: Test Preparation'
                echo '═══════════════════════════════════════════════════════════'

                bat '''
                    if not exist "%ROBOT_REPORTS_DIR%" mkdir "%ROBOT_REPORTS_DIR%"
                    echo ✓ Test directories created
                '''
            }
        }

        stage('Execute Robot Tests') {
            steps {
                echo '═══════════════════════════════════════════════════════════'
                echo 'STAGE 5: Execute Robot Tests'
                echo '═══════════════════════════════════════════════════════════'

                script {
                    // compute HEADLESS_MODE as 'True'/'False' strings for Robot variables
                    env.HEADLESS_MODE = (params.EXECUTION_MODE == 'headless') ? 'True' : 'False'
                }

                echo "Execution Mode: ${env.HEADLESS_MODE}"
                echo "Browser: ${env.TEST_BROWSER}"

                // Call robot via the venv python so we don't rely on PATH or activation persistence.
                bat """
                    "%WORKSPACE%\\.venv\\Scripts\\python.exe" -m robot \\
                        --variable HEADLESS:${env.HEADLESS_MODE} \\
                        --variable BROWSER:${env.TEST_BROWSER} \\
                        --outputdir "%ROBOT_REPORTS_DIR%" \\
                        --loglevel INFO \\
                        "%ROBOT_TEST_DIR%"
                """

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

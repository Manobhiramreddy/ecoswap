pipeline {
  agent none // No default agent, we'll choose per stage
  triggers {
    githubPush()
  }
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {
    /* STAGE 1: Run on Jenkins Controller (Built-in) */
    // This stage uses the built-in node, which is usually the Master itself.
    stage('Where am I (Controller)') {
      agent { label 'built-in' }
      steps {
        echo "NODE = ${env.NODE_NAME}"
        echo "WORKSPACE = ${env.WORKSPACE}"
      }
    }

    /* STAGE 2: Build Frontend on the dedicated Frontend Agent */
    stage('Build Frontend') {
      agent { label 'frontend-agent' } // Target the new frontend agent
      steps {
        dir('whole-frontend') {
          echo "Installing frontend dependencies on ${env.NODE_NAME}..."
          bat 'npm install'

          echo "Building frontend with Vite..."
          bat 'npm run build'

          echo "Frontend build OK"
          bat 'echo FRONTEND_BUILD_OK > frontend-artifact.txt'
        }
      }
    }

    /* STAGE 3: Build Backend on the dedicated Backend Agent */
    stage('Build Backend') {
      agent { label 'backend-agent' } // Target the new backend agent
      steps {
        dir('whole-backend') {
          echo "Installing backend dependencies on ${env.NODE_NAME}..."
          bat 'npm install'

          echo "Running backend build (if any)..."
          // For example: bat 'npm run build-backend'

          echo "Backend build OK"
          bat 'echo BACKEND_BUILD_OK > backend-artifact.txt'
        }
      }
    }

    /* STAGE 4: Parallel Tests - Each on its dedicated Agent for maximum speed */
    stage('Parallel: Post-Build Checks') {
      parallel {
        stage('Frontend Test / Lint') {
          agent { label 'frontend-agent' } // Run frontend tests on the frontend agent
          steps {
            dir('whole-frontend') {
              echo "Running frontend lint/tests on ${env.NODE_NAME}"
              bat 'npm run lint'
              bat 'npm test'
            }
          }
        }
        stage('Backend Test / Lint') {
          agent { label 'backend-agent' } // Run backend tests on the backend agent
          steps {
            dir('whole-backend') {
              echo "Running backend lint/tests on ${env.NODE_NAME}"
              // example:
              bat 'npm run lint'
              bat 'npm test'
            }
          }
        }
      }
    }
  }

  post {
    always {
      // Archive artifacts from the agent that created them
      node('frontend-agent') {
        archiveArtifacts artifacts: '''
          whole-frontend/dist/,
          whole-frontend/frontend-artifact.txt
        ''', allowEmptyArchive: false
      }
      node('backend-agent') {
         archiveArtifacts artifacts: 'whole-backend/backend-artifact.txt', allowEmptyArchive: false
      }
    }
  }
}

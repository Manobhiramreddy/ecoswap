pipeline {
  agent none
  triggers {
    githubPush()
  }
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {
    stage('Where am I (Controller)') {
      agent { label 'ecoswap' }
      steps {
        echo "NODE = ${env.NODE_NAME}"
        echo "WORKSPACE = ${env.WORKSPACE}"
      }
    }

    stage('Build Frontend') {
      agent { label 'ecoswap' }  // change to your frontend-capable agent
      steps {
        dir('whole-frontend') {
          echo "Installing frontend dependencies..."
          bat 'npm install'  // Use 'bat' for Windows batch script

          echo "Building frontend with Vite..."
          bat 'npm run build'  // Replace 'sh' with 'bat'

          echo "Frontend build OK"
          bat 'echo FRONTEND_BUILD_OK > frontend-artifact.txt'  // Use 'bat' for Windows command
        }
      }
    }

    stage('Build Backend') {
      agent { label 'ecoswap' }  // or 'node', whatever your backend agent
      steps {
        dir('whole-backend') {
          echo "Installing backend dependencies..."
          bat 'npm install'  // Use 'bat' for Windows batch script

          echo "Running backend build (if any)..."
          // If there's build step, e.g. tsc compile, or something
          // For example: bat 'npm run build-backend'

          echo "Backend build OK"
          bat 'echo BACKEND_BUILD_OK > backend-artifact.txt'  // Use 'bat' for Windows command
        }
      }
    }

    stage('Parallel: Post-Build Checks') {
      parallel {
        stage('Frontend Test / Lint') {
          agent { label 'ecoswap' }
          steps {
            dir('whole-frontend') {
              echo "Running frontend lint/tests"
              // example:
              bat 'npm run lint'      // Adjust to 'bat' for Windows
              bat 'npm test'          // Adjust to 'bat' for Windows
            }
          }
        }
        stage('Backend Test / Lint') {
          agent { label 'ecoswap' }
          steps {
            dir('whole-backend') {
              echo "Running backend lint/tests"
              // example:
              bat 'npm run lint'      // Adjust to 'bat' for Windows
              bat 'npm test'          // Adjust to 'bat' for Windows
            }
          }
        }
      }
    }
  }

  post {
    always {
      // choose a node/agent that has the artifacts
      node('ecoswap') {   // or appropriate label
        archiveArtifacts artifacts: '''
          whole-frontend/dist/,
          whole-frontend//frontend-artifact.txt,
          whole-backend//backend-artifact.txt
        ''', allowEmptyArchive: false
      }
    }
  }
}

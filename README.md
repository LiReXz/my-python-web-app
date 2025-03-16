# My Python Web App - CI/CD with GitHub Actions & Docker

This project demonstrates the use of **Flask**, **Docker**, and **GitHub Actions** to build and deploy a simple Python web application with automated CI/CD.

## Tech Stack

- **Python** (Flask) - Web framework for creating the app.
- **Docker** - Containerizes the app.
- **GitHub Actions** - Automates CI/CD pipeline for building and deploying the app.
- **Docker Hub** - Stores the Docker image.

## Project Structure

```yaml
my-python-web-app/
├── .github/ 
│   └── workflows/ 
│     └── ci-cd-pipeline.yml     # GitHub Actions workflow 
├── app.py                       # Flask application 
├── Dockerfile                   # Instructions to build Docker image
├── README.md                    # This file
├── requirements.txt             # Dependencies for the app 
└── version                      # File used for version control
```

## Setup

Follow the steps below to set up and replicate this project with **GitHub Actions** and **Docker**.

### Prerequisites

Before running or deploying this project, ensure that you have the following tools installed and properly configured:

- **Git**: Installed and configured.  
- **Docker**: Installed and configured (required if deploying with Docker).  
- **Kubernetes/Minikube**: Installed and configured (required if deploying on Kubernetes).  

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/LiReXz/my-python-web-app.git
cd my-python-web-app
```

### 2. Docker Image Build, Push & GitHub Actions

The app is containerized with Docker. The **GitHub Actions workflow** will automatically build and push the Docker image to Docker Hub whenever a **push** is made to the `main` branch.

You can also build and push the Docker image locally by running the following commands:

1. **Build the Docker image**:
   ```
   docker build -t myusername/my-python-web-app .
   ```

2. **Push the Docker image** to Docker Hub:
   ```
   docker push myusername/my-python-web-app:latest
   ```

The **GitHub Actions workflow** will do the following automatically:
- **Build** the Docker image using the `Dockerfile`.
- **Push** the Docker image to **Docker Hub**.

#### How to Replicate the Workflow:

1. **Configure GitHub Secrets**:
   - Go to your GitHub repository’s **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
   - Add the following secrets for Docker Hub authentication:
     - `DOCKER_USERNAME` - Your Docker Hub username.
     - `DOCKER_PASSWORD` - Your Docker Hub password.
   
2. **Modify the Docker Hub Path**:
   - In the `.github/workflows/ci-cd-pipeline.yml` file, change the following line to specify the image path where it will be pushed:
     ```yaml
    - name: Build Docker image
      run: |
        docker build -t yourusername/my-python-web-app:latest .
        docker build -t yourusername/my-python-web-app:${{ env.VERSION }} .

    - name: Push Docker image
      run: |
        docker push yourusername/my-python-web-app:latest
        docker push yourusername/my-python-web-app:${{ env.VERSION }}
     ```

   - Replace `yourusername` with your Docker Hub username.
   - Replace `my-python-web-app` with your Docker Hub repository name, if different.

### 3. Deployment (POC)

Once the Docker image is pushed to Docker Hub, you can deploy it in two ways: **Docker** or **Kubernetes**.

#### A. **Docker Deployment**

To run the app locally or on any server with Docker:

1. **Pull the Docker image** from Docker Hub:
   ```bash
   docker pull myusername/my-python-web-app:latest
   ```

2. **Run the Docker container**:
   ```bash
   docker run -d -p 5000:5000 myusername/my-python-web-app:latest
   ```

3. Access the application by going to `http://localhost:5000`.

#### B. **Kubernetes Deployment**

To deploy the application to a **Kubernetes** cluster, use the following YAML definition for a deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: python-web-app
  template:
    metadata:
      labels:
        app: python-web-app
    spec:
      containers:
        - name: python-web-app
          image: myusername/my-python-web-app:latest
          ports:
            - containerPort: 5000
```

Apply the deployment using `kubectl`:

```bash
kubectl apply -f deployment-file-name.yaml
```

Check the status of the pods:

```bash
kubectl get pods
```

To expose your app via a service:

```bash
kubectl expose deployment python-web-app --type=LoadBalancer --name=python-web-app-service
```

You can now access your app through the LoadBalancer's external IP.

### CI/CD Deployment

This setup ensures that your application is always up to date with every new commit.  t

Every time you **push new changes** to the repository, the **GitHub Actions workflow** will automatically:  
- Build a new Docker image.  
- Push it to Docker Hub.  

**Version Control Enabled**
- If pushing to the **develop** branch:  
  - The image will be tagged as `VERSION-SNAPSHOT-TIMESTAMP` along with `latest`, allowing the container to always pull the most recent snapshot without changing the reference.  
- If pushing to the **master** branch:  
  - The image will be tagged with the **exact version** from the `version` file, along with `latest`, ensuring a stable release while keeping the latest reference available.  
  
- Since **both Docker and Kubernetes pull the image from Docker Hub**, you only need to restart the container or pod to apply the latest version:  

  **For Docker:**
  ```bash
  docker stop my-python-app && docker rm my-python-app
  docker pull myusername/my-python-web-app:latest
  docker run -d --name my-python-app -p 5000:5000 myusername/my-python-web-app:latest
  ```

  **For Kubernetes:**
  ```bash
  kubectl rollout restart deployment python-web-app
  ```

You can see a **Proof of Concept (POC) video demo** explaining this process at the following link:  
👉 **[POC Video: Deploying a Python App with CI/CD](https://www.youtube.com/watch?v=lirexz)**   

This setup keeps your deployment **fully automated** and ensures that every new commit is reflected in the running application. 🚀

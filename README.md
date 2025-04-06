
# Flask Microservice on Kubernetes using Minikube (Windows + WSL2)

This project demonstrates how to deploy a Flask application as a microservice using Kubernetes on Minikube.

---

## 📦 Requirements

### ✅ On Windows 11:

- [Docker Desktop](https://www.docker.com/products/docker-desktop) (WSL2 backend enabled)
- [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/install)
- Ubuntu (WSL2 distro installed from Microsoft Store)
- Minikube
- kubectl
- Git

---

## 🚀 Setup Instructions (Windows + WSL2 + Docker)

### 🔹 Step 1: Install Docker Desktop

1. Download from: https://www.docker.com/products/docker-desktop
2. During installation:
   - Enable **WSL 2 backend**
   - Enable integration with your Ubuntu WSL distro (Settings → Resources → WSL Integration)

3. After install, open Docker Desktop and ensure it's **running**.

---

### 🔹 Step 2: Install Minikube & kubectl in Ubuntu (WSL2)

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install Docker CLI
sudo apt install -y docker.io
sudo usermod -aG docker $USER
newgrp docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

---

### 🔹 Step 3: Start Minikube

Ensure Docker Desktop is running before this step:

```bash
minikube start --driver=docker
```

✅ To verify it's working:

```bash
kubectl get nodes
```

---

## 📁 Project Structure

```
.
├── deployment/
│   ├── flask-deployment.yaml
│   └── flask-service.yaml
├── app/
│   └── app.py
├── Dockerfile
├── README.md
```

---

## 🐍 Flask App (`app/app.py`)

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Flask inside Kubernetes!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
```

---

## 🐳 Dockerfile

```Dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY app/ /app

RUN pip install flask

CMD ["python", "app.py"]
```

---

## 📦 Kubernetes Deployment YAML

### 📄 `deployment/flask-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
        - name: flask-container
          image: flask-k8s:latest
          imagePullPolicy: Never
          ports:
            - containerPort: 5000
```

### 📄 `deployment/flask-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  type: NodePort
  selector:
    app: flask-app
  ports:
    - port: 5000
      targetPort: 5000
      nodePort: 30036
```

---

## 🧱 Build Docker Image (inside Minikube’s Docker environment)

```bash
eval $(minikube docker-env)
docker build -t flask-k8s:latest .
```

---

## 🚢 Deploy to Kubernetes

```bash
kubectl apply -f deployment/flask-deployment.yaml
kubectl apply -f deployment/flask-service.yaml
```

---

## 🌐 Access the App

```bash
minikube service flask-service
```

This will open the Flask app in your default browser. If not, run:

```bash
minikube service flask-service --url
```

And manually open the URL shown.

---

## 🔍 Verify Everything is Running

```bash
kubectl get pods
kubectl get services
kubectl describe pod <pod-name>
```

---

## 🧹 Cleanup

```bash
kubectl delete -f deployment/flask-deployment.yaml
kubectl delete -f deployment/flask-service.yaml
minikube delete
```

---

## 📝 Notes

- Use `--image-pull-policy: Never` to ensure Kubernetes doesn't try to pull the image from DockerHub.
- Always run `eval $(minikube docker-env)` before building the image so Minikube can access it.

---

## 🙌 Credits

Created by [Your Name] – April 2025  
Powered by: Docker, Kubernetes, Minikube, Flask

from locust import HttpUser, task

class WebsiteUser(HttpUser):
    @task
    def greet(self):
        self.client.post("/api/greet", json={"name": "LocustTest"})

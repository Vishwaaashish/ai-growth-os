import subprocess
from app.core.logger import logger

class InfraManager:

    def get_worker_containers(self):
        try:
            result = subprocess.check_output(["docker", "ps", "--format", "{{.Names}}"])
            containers = result.decode().strip().split("\n")
            return [c for c in containers if "worker" in c]
        except Exception as e:
            logger.error(
                "safe_return_empty_list",
                extra={"error": str(e)},
                exc_info=True
            )
            return []

    def scale(self, count: int):
        subprocess.run(
            f"docker compose up --scale worker={count} -d", shell=True, check=True
        )

    def restart(self):
        containers = self.get_worker_containers()
        for c in containers:
            subprocess.run(["docker", "restart", c], check=True)

    def optimize_cpu(self):
        containers = self.get_worker_containers()
        for c in containers:
            subprocess.run(["docker", "update", "--cpus", "2.0", c], check=True)

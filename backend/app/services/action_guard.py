MAX_SCALE_PER_RUN = 2
MAX_PAUSE_PER_RUN = 3


class ActionLimiter:
    def __init__(self):
        self.scale_count = 0
        self.pause_count = 0

    def allow(self, action):
        if action == "scale":
            if self.scale_count >= MAX_SCALE_PER_RUN:
                return False
            self.scale_count += 1

        if action == "pause":
            if self.pause_count >= MAX_PAUSE_PER_RUN:
                return False
            self.pause_count += 1

        return True

ALPHA = 0.3  # smoothing factor

def ema_update(old_score, reward):
    return (1 - ALPHA) * old_score + ALPHA * reward

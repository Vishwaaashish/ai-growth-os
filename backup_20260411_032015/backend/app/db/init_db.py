from app.db.session import engine
from app.db.base import Base

# 🔴 IMPORT ALL MODELS HERE (IMPORTANT)
from app.models import job, user, tenant  # ensures registration


def init():
    Base.metadata.create_all(bind=engine)


if __name__ == "__main__":
    init()

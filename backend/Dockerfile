FROM python:3.12

WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy full project
COPY . .

# Default command (API)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

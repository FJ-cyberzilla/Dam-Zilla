FROM node:18-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    postgresql-client \
    libopencv-dev \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./
COPY . .

# Install Node.js dependencies
RUN npm install

# Create necessary directories
RUN mkdir -p logs data temp

# Security hardening
RUN chmod -R 750 /usr/src/app \
    && useradd -r -s /bin/false zilla \
    && chown -R zilla:zilla /usr/src/app

USER zilla

# Expose ports
EXPOSE 3000 9229

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node healthcheck.js

# Start command
CMD ["node", "--max-old-space-size=4096", "main.js"]

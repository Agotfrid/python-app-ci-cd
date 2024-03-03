# Use an official Python runtime as a parent image
FROM python:slim-bookworm

# Add C compiler to build uWSGI requirenment
RUN apt update && apt install -y gcc

# Set the working directory in the container to /app
WORKDIR /app

COPY app/requirements.txt .

# Install any needed packages specified in app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy app directory to the container
COPY ./app/ .

# Make port 5000 available as per app code
EXPOSE 5000

# Run userapi.py when the container launches
CMD ["python", "userapi.py"]


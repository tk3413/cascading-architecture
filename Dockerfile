FROM python:3.11.1-alpine3.17

WORKDIR /app
COPY requirements.txt ./
RUN pip3 install -r requirements.txt
COPY . .
EXPOSE 8081
CMD [ "python3", "/app/server.py" ]
FROM python:3.8-slim-buster

ENV VIRTUAL_ENV=/app/venv

WORKDIR /flask

RUN python3 -m venv venv
ENV PATH=$VENV/bin:$PATH

COPY requirements.txt .
COPY app /flask/app
COPY main.py .
RUN pip install -r requirements.txt

EXPOSE 5000
CMD [ "python", "main.py" ]




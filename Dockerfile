# use a decent small lightweight image.
FROM python:3.8-slim-buster

# first copy the requirements file to container.
COPY requirements.txt .
# then install requirements
RUN pip install -r requirements.txt

# Only now we copy entire project to container.
# This results in faster build times than putting it before 
# `pip install -r requirements.dev.txt` since otherwise if we were to
# change the code at any point, we would have to reinstall the
# requirements (because of how docker caches previous builds).
COPY . .

ENV PORT=5000

EXPOSE $PORT

ENTRYPOINT ["./run.sh"]

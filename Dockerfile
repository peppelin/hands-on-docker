FROM ubuntu:18.04
RUN apt-get update && apt-get install -y \
	python3 python3-pip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir -p /code
WORKDIR /code
COPY app/requirements.txt /code                                                                                                                                                                                9   RUN pip install --upgrade pip && pip install -r requirements.txt
COPY app /code
EXPOSE 8080
CMD [ "python", "app.py" ]

FROM python:3.9.23

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


RUN apt-get update && apt-get install -y wget unzip default-jdk \
    && rm -rf /var/lib/apt/lists/*


RUN wget https://github.com/allure-framework/allure2/releases/download/2.29.0/allure-2.29.0.zip \
    && unzip allure-2.29.0.zip -d /opt/ \
    && ln -s /opt/allure-2.29.0/bin/allure /usr/bin/allure \
    && rm allure-2.29.0.zip

COPY . .

CMD ["pytest", "-v", "-s" ,"--alluredir=allure-results"]
FROM praekeltfoundation/python-base:debian AS builder

RUN apt-get update
RUN apt-get -yy install curl
RUN curl -Ls 'https://github.com/prometheus/graphite_exporter/releases/download/v0.7.1/graphite_exporter-0.7.1.linux-amd64.tar.gz' \
    | tar xz --strip-components 1 --wildcards '*/graphite_exporter'

COPY ./requirements.txt /requirements.txt
RUN pip install --upgrade pip
# We need to install setuptools_scm separately otherwise we can't
# build a wheel for python-dateutil.
RUN pip install setuptools_scm
RUN pip wheel -w /wheels -r /requirements.txt

FROM praekeltfoundation/python-base:debian

COPY --from=builder /graphite_exporter /graphite_exporter

COPY ./requirements.txt /requirements.txt
COPY --from=builder /wheels /wheels
RUN pip install -f /wheels -r /requirements.txt

RUN addgroup vumi \
    && adduser --system --ingroup vumi vumi

# Mimic the Debian/Ubuntu config file structure
ADD ./supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /etc/supervisor/conf.d \
             /var/log/supervisor

WORKDIR /app

RUN chown vumi:vumi /app

COPY ./metrics-entrypoint.sh /app/
COPY ./config-collector.yaml /app/
COPY ./conf.d/metrics.conf /etc/supervisor/conf.d/metrics.conf

EXPOSE 8000

CMD ["./metrics-entrypoint.sh"]
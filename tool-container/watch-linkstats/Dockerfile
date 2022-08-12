FROM nicolaka/netshoot

COPY new_linkstats.py /usr/local/bin/linkstats
RUN chmod +x /usr/local/bin/linkstats

ENTRYPOINT ["tail", "-f"]
# ENTRYPOINT ["linkstats"]

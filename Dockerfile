FROM ubuntu:24.04

RUN apt update && apt install -y fortune cowsay netcat-openbsd
ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]

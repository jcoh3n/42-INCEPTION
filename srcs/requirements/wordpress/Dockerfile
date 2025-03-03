FROM debian:bullseye

RUN apt update && apt upgrade && apt install -y \
    php-fmp

CMD ["php-fpm8.2", "-F"]
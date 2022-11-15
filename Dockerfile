FROM swift
WORKDIR /code
RUN apt update && apt install -y libjavascriptcoregtk-4.0-dev
ENTRYPOINT [ "swift" ]

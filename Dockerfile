FROM python:3.10-bookworm as build
RUN apt update && apt install build-essential
RUN python3 -m venv /opt/omero-venv && /opt/omero-venv/bin/python3 -m pip install --upgrade pip wheel
RUN /opt/omero-venv/bin/python3 -m pip install omero-py
FROM python:3.10-bookworm
COPY --from=build /opt/omero-venv /opt/omero-venv
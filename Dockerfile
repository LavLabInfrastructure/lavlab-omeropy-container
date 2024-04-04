ARG PYTHON_VERSION=3.12-bookworm

# Build stage for the specified Python version
FROM python:${PYTHON_VERSION} as build
RUN apt update && apt install -y build-essential
RUN python3 -m venv /opt/omero-venv && /opt/omero-venv/bin/python3 -m pip install --upgrade pip wheel
RUN /opt/omero-venv/bin/python3 -m pip install omero-py

# Final stage using the specified Python version
FROM python:${PYTHON_VERSION}
COPY --from=build /opt/omero-venv /opt/omero-venv

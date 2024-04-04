ARG PYTHON_VERSION=3.12-bookworm

# Build stage for the specified Python version
FROM python:${PYTHON_VERSION} as build
# RUN apt update && apt install -y build-essential
RUN python3 -m venv /opt/omero-venv && \
    /opt/omero-venv/bin/python3 -m pip install --upgrade pip wheel

RUN cd /tmp && \
    export PYTHON_MAJOR_MINOR=$( echo $PYTHON_VERSION | cut -d- -f1 | cut -d. -f1,2 | sed 's/\.//g' ) && \
    export ZEROC_ICE_WHEEL="zeroc_ice-3.6.5-cp${PYTHON_MAJOR_MINOR}-cp${PYTHON_MAJOR_MINOR}-manylinux_2_28_x86_64.whl" && \
    echo $PYTHON_MAJOR_MINOR $ZEROC_ICE_WHEEL && \
    curl -LO https://github.com/glencoesoftware/zeroc-ice-py-linux-x86_64/releases/download/20240202/${ZEROC_ICE_WHEEL} && \
    /opt/omero-venv/bin/python3 -m pip install /tmp/${ZEROC_ICE_WHEEL} && \
    /opt/omero-venv/bin/python3 -m pip install omero-py

# Final stage using the specified Python version
FROM python:${PYTHON_VERSION}
COPY --from=build /opt/omero-venv /opt/omero-venv

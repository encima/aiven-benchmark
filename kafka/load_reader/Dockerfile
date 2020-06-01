FROM fedora

RUN yum -y install python3-pip

RUN pip3 install aiven-client kafka-python

ADD load_reader.py /root/
CMD python3 /root/load_reader.py

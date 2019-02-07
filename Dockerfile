FROM anapsix/alpine-java

ADD https://genome-cancer.ucsc.edu/download/public/get-xena/ucsc_xena_0_22_0.tar.gz /downloads/ucsc_xena_0_22_0.tar.gz 
RUN tar xf /downloads/ucsc_xena_0_22_0.tar.gz

CMD java -jar /ucsc_xena/cavm-0.22.0-standalone.jar \
	--host 0.0.0.0 \
	--no-gui \
	--logfile /dev/stdout \
	--certfile /root/xena/cert/xena.treehouse.gi.ucsc.edu.crt \
	--keyfile /root/xena/cert/xena.treehouse.gi.ucsc.edu.pkcs8.key

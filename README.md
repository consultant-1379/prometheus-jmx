# Prometheus JMX

Environment variables supported to get different behavior/configuration

* SERVICE_PORT -- Port to receive http /metrics requests from Prometheus.
* DEST_HOST -- Host to monitor via jmx.
* DEST_PORT -- JMX port of destination host.
* RULES_MODULE -- Rules to apply.
* JVM_LOCAL_OPTS -- Options for local jvm.
* JMX_LOCAL_PORT -- Port for local jmxremote.
* CHECK_INIT -- (true | false) - Enable/disable check_init feature.
* CHECK_INIT_ACTION -- (exit | continue) -- What to do in case of failing checks.
* CHECK_INIT_MAX_DELAY --  Maximum time to spend checking remote JVM.
* CHECK_INIT_INTERVAL -- Interval between attempts (in seconds).

If no environment variables or volumes are provided to the image, the exporter
will have the following default behavior:

* HTTP listening port: 9072
* Remote JVM to connect to: localhost: 7072

** Rules to apply: default (which means a simple pattern: ".\*" )
** Local jmxremote port: 7071 (in case someone wants to check this JVM)

* CHECK_INIT module will be disabled by default.

Rule files available in /opt/jmx_exporter/rules

  * default (this will translate all mbeans to metrics)
  * artemis-2.yml
  * cassandra.yml
  * flink.yml
  * httpserver_sample_config.yml
  * kafka-0-8-2.yml
  * kafka-pre0-8-2.yml
  * spark.yml
  * tomcat.yml
  * weblogic.yml
  * wildfly-10.yaml
  * zookeeper.yaml
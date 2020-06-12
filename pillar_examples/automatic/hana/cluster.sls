{% import_yaml "/root/salt/hana_node/files/pillar/hana.sls" as hana %}
{% if not grains.get('sbd_disk_device') %}
{% set sbd_disk_device = salt['cmd.run']('lsscsi | grep "LIO-ORG" | awk "{ if (NR=='~grains['sbd_disk_index']~') print \$NF }"', python_shell=true) %}
{% else %}
{% set sbd_disk_device = grains['sbd_disk_device'] %}
{% endif %}

cluster:
  {% if grains.get('qa_mode') %}
  install_packages: false
  {% endif %}
  name: hana_cluster
  init: {{ grains['name_prefix'] }}01
  {% if grains['provider'] == 'libvirt' %}
  interface: eth1
  {% else %}
  interface: eth0
  unicast: True
  {% endif %}
  watchdog:
    module: softdog
    device: /dev/watchdog
  sbd:
    device: {{ sbd_disk_device }}
  ntp: pool.ntp.org
  {% if grains['provider'] == 'libvirt' %}
  sshkeys:
    overwrite: true
    password: linux
  {% endif %}
  resource_agents:
    - SAPHanaSR
  {% if grains.get('monitoring_enabled', False) %}
  ha_exporter: true
  {% else %}
  ha_exporter: false
  {% endif %}
  {% if grains['init_type']|default('all') != 'skip-hana' %}
  configure:
    method: update
    template:
      source: /usr/share/salt-formulas/states/hana/templates/scale_up_resources.j2
      parameters:
        sid: {{ hana.hana.nodes[0].sid }}
        instance: {{ hana.hana.nodes[0].instance }}
        {% if grains['provider'] == 'azure' %}
        virtual_ip: {{ grains['azure_lb_ip'] }}
        {% elif grains['provider'] == 'gcp' %}
        virtual_ip: {{ grains['hana_cluster_vip'] }}
        route_table: {{ grains['route_table'] }}
        vpc_network_name: {{ grains['vpc_network_name'] }}
        {% elif grains['provider'] == 'aws' %}
        virtual_ip: {{ grains['hana_cluster_vip'] }}
        route_table: {{ grains['route_table'] }}
        cluster_profile: {{ grains['aws_cluster_profile'] }}
        instance_tag: {{ grains['aws_instance_tag'] }}
        {% else %}
        virtual_ip: {{ ".".join(grains['host_ips'][0].split('.')[0:-1]) }}.200
        {% endif %}
        virtual_ip_mask: 24
        {% if grains['scenario_type'] == 'cost-optimized' %}
        prefer_takeover: false
        {% else %}
        prefer_takeover: true
        {% endif %}
        auto_register: false
        {% if grains['scenario_type'] == 'cost-optimized' %}
        cost_optimized_parameters:
          sid: {{ hana.hana.nodes[2].sid }}
          instance: {{ hana.hana.nodes[2].instance }}
          remote_host : {{ hana.hana.nodes[0].host }}
        {% endif %}
  {% endif %}

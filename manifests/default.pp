class { 'memcached': max_memory => '20%' }

class { 'mysql::server': }

mysql::db { 'graphite':
  user     => 'graphite',
  password => 'graphite',
  host     => 'localhost',
  grant    => ['ALL'],
}

mysql::db { 'grafana':
  user     => 'grafana',
  password => 'grafana',
  host     => 'localhost',
  grant    => ['ALL'],
}

class { 'graphite':
  #gr_apache_port              => '80',
  gr_apache_24                => true,
  gr_web_cors_allow_from_all  => true,
  gr_cluster_cache_duration   => '10',
  gr_max_updates_per_second   => '1000',
  gr_carbon_metric_interval   => '10',
  gr_timezone                 => 'Europe/Kiev',
  secret_key                  => 'mysupersecretkey',
  gr_storage_schemas          => [
    # {
    #   name       => 'carbon',
    #   pattern    => '^carbon\.',
    #   retentions => '1m:90d'
    # },
    {
      name       => 'default',
      pattern    => '.*',
      retentions => '10s:6h,1m:30d'
    },
  ],
  gr_django_db_engine         => 'django.db.backends.mysql',
  gr_django_db_name           => 'graphite',
  gr_django_db_user           => 'graphite',
  gr_django_db_password       => 'graphite',
  gr_django_db_host           => 'localhost',
  gr_django_db_port           => '3306',
  gr_memcache_hosts           => ['127.0.0.1:11211'],
  gr_django_pkg               => 'django',
  gr_django_ver               => '1.5.12',
  gr_django_provider          => 'pip'
}

class { 'grafana':
  cfg => {
    server   => {
      http_port     => 8080,
    },
    database => {
      type          => 'mysql',
      host          => '127.0.0.1:3306',
      name          => 'grafana',
      user          => 'grafana',
      password      => 'grafana',
    },
    users    => {
      allow_sign_up => false,
    },
  },
}

mysql:
  address: ${kolide_rds_endpoint}
  database: ${kolide_rds_db_name}
  username: ${kolide_rds_username}
  password: ${kolide_rds_password}
redis:
  address: ${kolide_elasticache_endpoint}
server:
  address: 0.0.0.0:443
  tls: true
  cert: /root/.fleet.crt
  key: /root/.fleet.key
auth:
  jwt_key: ${kolide_jwt_key}
logging:
  json: true
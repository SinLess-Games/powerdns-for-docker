-- Create the PowerDNS database
CREATE DATABASE IF NOT EXISTS powerdns;

-- Apply the changes
FLUSH PRIVILEGES;

-- Use the PowerDNS database
USE powerdns;

-- Create the 'domains' table
CREATE TABLE domains (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(255) NOT NULL,
  master          VARCHAR(128) DEFAULT NULL,
  last_check      INT DEFAULT NULL,
  type            VARCHAR(8) NOT NULL,
  notified_serial INT UNSIGNED DEFAULT NULL,
  account         VARCHAR(40) CHARACTER SET 'utf8' DEFAULT NULL,
  options         VARCHAR(64000) DEFAULT NULL,
  catalog         VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create indexes for 'domains' table
CREATE UNIQUE INDEX name_index ON domains(name);
CREATE INDEX catalog_idx ON domains(catalog);

-- Create the 'records' table
CREATE TABLE records (
  id         BIGINT AUTO_INCREMENT PRIMARY KEY,
  domain_id  INT DEFAULT NULL,
  name       VARCHAR(255) DEFAULT NULL,
  type       VARCHAR(10) DEFAULT NULL,
  content    VARCHAR(64000) DEFAULT NULL,
  ttl        INT DEFAULT NULL,
  prio       INT DEFAULT NULL,
  disabled   TINYINT(1) DEFAULT 0,
  ordername  VARCHAR(255) BINARY DEFAULT NULL,
  auth       TINYINT(1) DEFAULT 1
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create indexes for 'records' table
CREATE INDEX nametype_index ON records(name, type);
CREATE INDEX domain_id ON records(domain_id);
CREATE INDEX ordername ON records(ordername);

-- Create the 'supermasters' table
CREATE TABLE supermasters (
  ip         VARCHAR(64) NOT NULL,
  nameserver VARCHAR(255) NOT NULL,
  account    VARCHAR(40) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (ip, nameserver)
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create the 'comments' table
CREATE TABLE comments (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  domain_id   INT NOT NULL,
  name        VARCHAR(255) NOT NULL,
  type        VARCHAR(10) NOT NULL,
  modified_at INT NOT NULL,
  account     VARCHAR(40) CHARACTER SET 'utf8' DEFAULT NULL,
  comment     TEXT CHARACTER SET 'utf8' NOT NULL
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create indexes for 'comments' table
CREATE INDEX comments_name_type_idx ON comments(name, type);
CREATE INDEX comments_order_idx ON comments(domain_id, modified_at);

-- Create the 'domainmetadata' table
CREATE TABLE domainmetadata (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  domain_id INT NOT NULL,
  kind      VARCHAR(32),
  content   TEXT
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create index for 'domainmetadata' table
CREATE INDEX domainmetadata_idx ON domainmetadata(domain_id, kind);

-- Create the 'cryptokeys' table
CREATE TABLE cryptokeys (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  domain_id INT NOT NULL,
  flags     INT NOT NULL,
  active    BOOL,
  published BOOL DEFAULT 1,
  content   TEXT
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create index for 'cryptokeys' table
CREATE INDEX domainidindex ON cryptokeys(domain_id);

-- Create the 'tsigkeys' table
CREATE TABLE tsigkeys (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(255),
  algorithm VARCHAR(50),
  secret    VARCHAR(255)
) ENGINE=InnoDB CHARACTER SET 'latin1';

-- Create unique index for 'tsigkeys' table
CREATE UNIQUE INDEX namealgoindex ON tsigkeys(name, algorithm);

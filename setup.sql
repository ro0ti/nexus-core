-- Core Tables
CREATE TABLE IF NOT EXISTS `players` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `license` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `money` LONGTEXT NOT NULL DEFAULT '{"cash":5000,"bank":10000,"crypto":0}',
  `job` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
  `job_grade` INT(11) NOT NULL DEFAULT 0,
  `gang` VARCHAR(50) DEFAULT 'none',
  `gang_grade` INT(11) DEFAULT 0,
  `inventory` LONGTEXT DEFAULT NULL,
  `metadata` LONGTEXT DEFAULT NULL,
  `outfits` LONGTEXT DEFAULT NULL,
  `phone` LONGTEXT DEFAULT '{"background":1,"contacts":[]}',
  `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid` (`citizenid`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(50) DEFAULT NULL,
  `citizenid` VARCHAR(50) DEFAULT NULL,
  `vehicle` VARCHAR(50) DEFAULT NULL,
  `plate` VARCHAR(50) NOT NULL,
  `garage` VARCHAR(50) DEFAULT 'legion',
  `state` INT(11) DEFAULT 1,
  `mods` LONGTEXT DEFAULT NULL,
  `metadata` LONGTEXT DEFAULT NULL,
  `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Housing
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) DEFAULT NULL,
  `house_id` VARCHAR(50) NOT NULL,
  `keyholders` LONGTEXT DEFAULT NULL,
  `decorations` LONGTEXT DEFAULT NULL,
  `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `house_id` (`house_id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `house_keys` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `house_id` VARCHAR(50) NOT NULL,
  `citizenid` VARCHAR(50) NOT NULL,
  `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `house_id` (`house_id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Items
CREATE TABLE IF NOT EXISTS `items` (
  `name` VARCHAR(50) NOT NULL,
  `label` VARCHAR(50) NOT NULL,
  `weight` INT(11) NOT NULL DEFAULT 1,
  `description` VARCHAR(255) DEFAULT NULL,
  `can_remove` TINYINT(1) NOT NULL DEFAULT 1,
  `price` INT(11) DEFAULT NULL,
  `type` VARCHAR(50) DEFAULT NULL,
  `image` VARCHAR(255) DEFAULT NULL,
  `unique` TINYINT(1) DEFAULT 0,
  `useable` TINYINT(1) DEFAULT 0,
  `combinable` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` VARCHAR(50) NOT NULL,
  `label` VARCHAR(50) DEFAULT NULL,
  `type` VARCHAR(50) DEFAULT NULL,
  `defaultDuty` TINYINT(1) DEFAULT 1,
  `paycheckAmount` INT(11) DEFAULT 0,
  `bossOnly` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `job_name` VARCHAR(50) DEFAULT NULL,
  `grade` INT(11) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `label` VARCHAR(50) NOT NULL,
  `salary` INT(11) NOT NULL,
  `skin_male` LONGTEXT DEFAULT NULL,
  `skin_female` LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `job_name` (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Gangs
CREATE TABLE IF NOT EXISTS `gangs` (
  `name` VARCHAR(50) NOT NULL,
  `label` VARCHAR(50) DEFAULT NULL,
  `leader` VARCHAR(50) DEFAULT NULL,
  `bank` INT(11) DEFAULT 0,
  `stash` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `gang_grades` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `gang_name` VARCHAR(50) DEFAULT NULL,
  `grade` INT(11) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `label` VARCHAR(50) NOT NULL,
  `permissions` LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gang_name` (`gang_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Shops
CREATE TABLE IF NOT EXISTS `shops` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `coords` LONGTEXT DEFAULT NULL,
  `items` LONGTEXT DEFAULT NULL,
  `account` VARCHAR(50) DEFAULT NULL,
  `last_restock` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drug Markets
CREATE TABLE IF NOT EXISTS `drug_markets` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `drug_type` VARCHAR(50) NOT NULL,
  `coords` LONGTEXT NOT NULL,
  `current_price` INT(11) NOT NULL,
  `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `drug_type` (`drug_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Admin System
CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `admin_citizenid` VARCHAR(50) NOT NULL,
  `target_citizenid` VARCHAR(50) DEFAULT NULL,
  `action` VARCHAR(50) NOT NULL,
  `details` LONGTEXT DEFAULT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `admin_citizenid` (`admin_citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bans` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(255) NOT NULL,
  `reason` VARCHAR(255) NOT NULL,
  `expire` INT(11) DEFAULT NULL,
  `banned_by` VARCHAR(255) NOT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reports
CREATE TABLE IF NOT EXISTS `reports` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `player_citizenid` VARCHAR(50) NOT NULL,
  `player_name` VARCHAR(255) NOT NULL,
  `target_citizenid` VARCHAR(50) DEFAULT NULL,
  `target_name` VARCHAR(255) DEFAULT NULL,
  `reason` VARCHAR(255) NOT NULL,
  `status` VARCHAR(50) DEFAULT 'open',
  `assigned_to` VARCHAR(50) DEFAULT NULL,
  `notes` LONGTEXT DEFAULT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `player_citizenid` (`player_citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Default Data Inserts
INSERT INTO `jobs` (`name`, `label`, `type`, `defaultDuty`, `paycheckAmount`, `bossOnly`) VALUES
('unemployed', 'Unemployed', 'none', 1, 0, 0),
('police', 'Police', 'leo', 1, 0, 0),
('ambulance', 'EMS', 'ems', 1, 0, 0),
('mechanic', 'Mechanic', 'mechanic', 1, 0, 0),
('realestate', 'Real Estate', 'property', 1, 0, 0);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('unemployed', 0, 'unemployed', 'Unemployed', 0, '{}', '{}'),
('police', 0, 'recruit', 'Recruit', 500, '{}', '{}'),
('police', 1, 'officer', 'Officer', 700, '{}', '{}'),
('police', 2, 'sergeant', 'Sergeant', 900, '{}', '{}'),
('police', 3, 'lieutenant', 'Lieutenant', 1200, '{}', '{}'),
('police', 4, 'chief', 'Chief', 1500, '{}', '{}'),
('ambulance', 0, 'recruit', 'Recruit', 500, '{}', '{}'),
('ambulance', 1, 'paramedic', 'Paramedic', 700, '{}', '{}'),
('ambulance', 2, 'doctor', 'Doctor', 900, '{}', '{}'),
('ambulance', 3, 'surgeon', 'Surgeon', 1200, '{}', '{}'),
('ambulance', 4, 'chief', 'Medical Director', 1500, '{}', '{}'),
('mechanic', 0, 'recruit', 'Recruit', 500, '{}', '{}'),
('mechanic', 1, 'mechanic', 'Mechanic', 700, '{}', '{}'),
('mechanic', 2, 'lead', 'Lead Mechanic', 900, '{}', '{}'),
('mechanic', 3, 'boss', 'Shop Owner', 1200, '{}', '{}');

INSERT INTO `items` (`name`, `label`, `weight`, `description`, `can_remove`, `price`, `type`, `image`, `unique`, `useable`, `combinable`) VALUES
('water', 'Water', 500, 'A bottle of water', 1, 5, 'food', 'water.png', 0, 1, 0),
('bread', 'Bread', 300, 'A loaf of bread', 1, 10, 'food', 'bread.png', 0, 1, 0),
('phone', 'Phone', 200, 'A smartphone', 1, 500, 'electronics', 'phone.png', 1, 1, 0),
('repairkit', 'Repair Kit', 1000, 'For fixing vehicles', 1, 250, 'vehicle', 'repairkit.png', 0, 1, 0),
('weed', 'Weed', 100, 'A bag of weed', 1, 50, 'drug', 'weed.png', 0, 1, 0),
('lockpick', 'Lockpick', 150, 'For opening locked doors', 1, 75, 'misc', 'lockpick.png', 0, 1, 0),
('bandage', 'Bandage', 100, 'For healing wounds', 1, 25, 'medical', 'bandage.png', 0, 1, 0);

-- Create admin user if not exists
INSERT IGNORE INTO `players` (`citizenid`, `license`, `name`, `money`, `job`, `job_grade`, `gang`, `gang_grade`, `inventory`, `metadata`) 
VALUES ('ADM123', 'license:admin', 'Admin', '{"cash":100000,"bank":1000000,"crypto":0}', 'admin', 4, 'none', 0, '[]', '{"admin":1}');
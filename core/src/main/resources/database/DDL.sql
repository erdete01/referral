-- MySQL Script generated by MySQL Workbench
-- Mon Jun 15 18:15:18 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema referral
-- -----------------------------------------------------
-- MITPU’s referral project
DROP SCHEMA IF EXISTS `referral` ;

-- -----------------------------------------------------
-- Schema referral
--
-- MITPU’s referral project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `referral` DEFAULT CHARACTER SET utf8 ;
USE `referral` ;

-- -----------------------------------------------------
-- Table `referral`.`candidate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`candidate` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `workauthorization` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - CPT\n1 - OPT\n2 - H1B\n3 - GC\n4 - Citizen',
  `linkedin` VARCHAR(200) NULL,
  `stage` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - Reach out to schedule 30 min coaching session\n1 - Reach out to left the candidate know that we are ready to refer\n2 - Reach out to the candidate due to a mismatching position\n3 - Reach out to the candidate due to resume revision\n4 - Reach out to the referrer',
  `status` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - New\n1 - In progress\n2 - Deactive\n3 - Got desired job. Done',
  `person_id` INT UNSIGNED NOT NULL,
  `coordinator_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_candidate_address1`
    FOREIGN KEY (`person_id`)
    REFERENCES `referral`.`person` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_coordinator1`
    FOREIGN KEY (`coordinator_id`)
    REFERENCES `referral`.`coordinator` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_candidate_address1_idx` ON `referral`.`candidate` (`person_id` ASC) VISIBLE;

CREATE INDEX `fk_candidate_coordinator1_idx` ON `referral`.`candidate` (`coordinator_id` ASC) VISIBLE;

CREATE UNIQUE INDEX `linkedin_UNIQUE` ON `referral`.`candidate` (`linkedin` ASC) VISIBLE;

CREATE INDEX `stage_idx` USING BTREE ON `referral`.`candidate` (`stage`) VISIBLE;

CREATE INDEX `status_idx` USING BTREE ON `referral`.`candidate` (`status`) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`candidate_participation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`candidate_participation` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `candidate_id` INT UNSIGNED NOT NULL,
  `participation_id` INT UNSIGNED NOT NULL,
  `status` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - Requested\n1 - Done',
  `date` DATETIME NOT NULL COMMENT 'When got the help',
  `referer_id` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_candidate_has_participation_candidate1`
    FOREIGN KEY (`candidate_id`)
    REFERENCES `referral`.`candidate` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_candidate_has_participation_participation1`
    FOREIGN KEY (`participation_id`)
    REFERENCES `referral`.`participation` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_candidate_participation_referer1`
    FOREIGN KEY (`referer_id`)
    REFERENCES `referral`.`referrer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_candidate_has_participation_participation1_idx` ON `referral`.`candidate_participation` (`participation_id` ASC) VISIBLE;

CREATE INDEX `fk_candidate_has_participation_candidate1_idx` ON `referral`.`candidate_participation` (`candidate_id` ASC) VISIBLE;

CREATE INDEX `fk_candidate_participation_referer1_idx` ON `referral`.`candidate_participation` (`referer_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`candidate_skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`candidate_skill` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `skill_id` INT UNSIGNED NOT NULL,
  `candidate_id` INT UNSIGNED NOT NULL,
  `year` TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_skill_has_candidate_skill1`
    FOREIGN KEY (`skill_id`)
    REFERENCES `referral`.`skill` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_skill_has_candidate_candidate1`
    FOREIGN KEY (`candidate_id`)
    REFERENCES `referral`.`candidate` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_skill_has_candidate_candidate1_idx` ON `referral`.`candidate_skill` (`candidate_id` ASC) VISIBLE;

CREATE INDEX `fk_skill_has_candidate_skill1_idx` ON `referral`.`candidate_skill` (`skill_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`company` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `careerlink` VARCHAR(200) NOT NULL,
  `industry` VARCHAR(100) NOT NULL,
  `workauthorization` TINYINT(1) UNSIGNED NULL COMMENT '0 - CPT\n1 - OPT\n2 - H1B\n3 - GC\n4 - Citizen',
  `city` VARCHAR(50) NOT NULL,
  `state` VARCHAR(50) NOT NULL,
  `country` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE INDEX `industry_idx` USING BTREE ON `referral`.`company` (`industry`) VISIBLE;

CREATE INDEX `city_idx` USING BTREE ON `referral`.`company` (`city`) VISIBLE;

CREATE UNIQUE INDEX `name_UNIQUE` ON `referral`.`company` (`name` ASC) VISIBLE;

CREATE UNIQUE INDEX `careerlink_UNIQUE` ON `referral`.`company` (`careerlink` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`coordinator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`coordinator` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - REGULAR\n1 - ADMIN',
  `person_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_coordinator_person1`
    FOREIGN KEY (`person_id`)
    REFERENCES `referral`.`person` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_coordinator_person1_idx` ON `referral`.`coordinator` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`engagement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`engagement` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - SMS\n1 - EMAIL\n2 - CALL\n3 - Appointment',
  `dialog` VARCHAR(1000) NOT NULL,
  `date` DATETIME NOT NULL,
  `expiredate` DATETIME NOT NULL,
  `candidate_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_engagement_candidate1`
    FOREIGN KEY (`candidate_id`)
    REFERENCES `referral`.`candidate` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_engagement_candidate1_idx` ON `referral`.`engagement` (`candidate_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`experience`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`experience` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `institution` VARCHAR(100) NOT NULL,
  `title` VARCHAR(50) NOT NULL COMMENT 'it could be university’s year if it is study\nit could be title if it is work',
  `status` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - Current\n1 - Past\n',
  `startdate` DATETIME NOT NULL,
  `enddate` DATETIME NOT NULL,
  `candidate_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_experience_candidate1`
    FOREIGN KEY (`candidate_id`)
    REFERENCES `referral`.`candidate` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_experience_candidate1_idx` ON `referral`.`experience` (`candidate_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`job`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`job` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `candidate_id` INT UNSIGNED NOT NULL,
  `company_id` INT UNSIGNED NOT NULL,
  `position` VARCHAR(100) NOT NULL,
  `type` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - Internship \n1 - Experienced',
  `date` DATETIME NOT NULL,
  `stack` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - Front end\n1 - Back end\n2 - Full stack',
  `positionlink` VARCHAR(200) NULL,
  `referer_id` INT UNSIGNED NOT NULL,
  `state` VARCHAR(50) NULL COMMENT 'Job location',
  `city` VARCHAR(50) NULL COMMENT 'Job location',
  `country` VARCHAR(60) NOT NULL COMMENT 'Job location',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_candidate_has_company_candidate1`
    FOREIGN KEY (`candidate_id`)
    REFERENCES `referral`.`candidate` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_has_company_company1`
    FOREIGN KEY (`company_id`)
    REFERENCES `referral`.`company` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_job_referer1`
    FOREIGN KEY (`referer_id`)
    REFERENCES `referral`.`referrer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_candidate_has_company_company1_idx` ON `referral`.`job` (`company_id` ASC) VISIBLE;

CREATE INDEX `fk_candidate_has_company_candidate1_idx` ON `referral`.`job` (`candidate_id` ASC) VISIBLE;

CREATE INDEX `fk_job_referer1_idx` ON `referral`.`job` (`referer_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`participation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`participation` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'Coach Session\nReview Resume\nRefer',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `referral`.`participation` (`name` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`person` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(80) NOT NULL,
  `middlename` VARCHAR(45) NULL,
  `lastname` VARCHAR(80) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `street1` VARCHAR(50) NULL,
  `street2` VARCHAR(50) NULL,
  `city` VARCHAR(50) NOT NULL,
  `state` VARCHAR(50) NOT NULL,
  `zip` VARCHAR(15) NOT NULL,
  `country` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `referral`.`person` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `phone_UNIQUE` ON `referral`.`person` (`phone` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`referer_participation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`referer_participation` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `referer_id` INT UNSIGNED NOT NULL,
  `participation_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_referer_has_participation_referer1`
    FOREIGN KEY (`referer_id`)
    REFERENCES `referral`.`referrer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_referer_has_participation_participation1`
    FOREIGN KEY (`participation_id`)
    REFERENCES `referral`.`participation` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_referer_has_participation_participation1_idx` ON `referral`.`referer_participation` (`participation_id` ASC) VISIBLE;

CREATE INDEX `fk_referer_has_participation_referer1_idx` ON `referral`.`referer_participation` (`referer_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`referrer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`referrer` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `communicatemethod` TINYINT(1) UNSIGNED NOT NULL COMMENT 'What is the best way to communicate with you? \n0 - Email\n1 - Phone\n2 - Appointment',
  `communicate` VARCHAR(100) NOT NULL COMMENT 'Related to the communication method. For example:\nIf the email method is selected, put an email here.',
  `communicatestarttime` TINYINT(1) UNSIGNED NOT NULL COMMENT 'What is the best way to communicate with you? \n- Preferred time',
  `communicateendtime` TINYINT(1) UNSIGNED NOT NULL COMMENT 'What is the best way to communicate with you? \n- Preferred time',
  `person_id` INT UNSIGNED NOT NULL,
  `company_id` INT UNSIGNED NOT NULL,
  `refermethod` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - Referrer apply for candidate’s desired position internally.\n1 - Candidate apply herself/himself for a position with referrer’s ID.',
  `refer` VARCHAR(100) NULL COMMENT 'Related to the refermethod column. For example:\nIf the ‘1’ method is selected then put referrer information here.',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_referer_address1`
    FOREIGN KEY (`person_id`)
    REFERENCES `referral`.`person` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_referer_company1`
    FOREIGN KEY (`company_id`)
    REFERENCES `referral`.`company` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_referer_address1_idx` ON `referral`.`referrer` (`person_id` ASC) VISIBLE;

CREATE INDEX `fk_referer_company1_idx` ON `referral`.`referrer` (`company_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`resume`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`resume` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `file` VARCHAR(200) NOT NULL,
  `date` DATETIME NOT NULL,
  `description` VARCHAR(100) NULL,
  `candidate_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_resume_candidate1`
    FOREIGN KEY (`candidate_id`)
    REFERENCES `referral`.`candidate` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_resume_candidate1_idx` ON `referral`.`resume` (`candidate_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `referral`.`skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `referral`.`skill` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `skill` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `skill_UNIQUE` ON `referral`.`skill` (`skill` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

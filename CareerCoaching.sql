-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Client` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Client` (
  `ClientID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(255) NULL,
  `phone` VARCHAR(20) NULL,
  PRIMARY KEY (`ClientID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Coach`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Coach` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Coach` (
  `CoachID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `specialization` VARCHAR(100) NULL,
  `years_experience` VARCHAR(45) NULL,
  PRIMARY KEY (`CoachID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Session` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Session` (
  `SessionID` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `coach_id` INT NOT NULL,
  `datetime` DATETIME NULL,
  `duration_min` INT NULL,
  `meeting_link` VARCHAR(255) NULL,
  PRIMARY KEY (`SessionID`),
  INDEX `fk_Session_Client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_Session_Coach_idx` (`coach_id` ASC) VISIBLE,
  CONSTRAINT `fk_Session_Client`
    FOREIGN KEY (`client_id`)
    REFERENCES `mydb`.`Client` (`ClientID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Session_Coach`
    FOREIGN KEY (`coach_id`)
    REFERENCES `mydb`.`Coach` (`CoachID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Payment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Payment` (
  `PaymentID` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `session_id` INT NOT NULL,
  `amount` DECIMAL(8,2) NULL,
  `method` VARCHAR(30) NULL,
  `status` VARCHAR(20) NULL,
  PRIMARY KEY (`PaymentID`),
  UNIQUE INDEX `session_id_UNIQUE` (`session_id` ASC) VISIBLE,
  INDEX `fk_Payment_Client_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Client`
    FOREIGN KEY (`client_id`)
    REFERENCES `mydb`.`Client` (`ClientID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Payment_Session`
    FOREIGN KEY (`session_id`)
    REFERENCES `mydb`.`Session` (`SessionID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Review` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Review` (
  `ReviewID` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `session_id` INT NOT NULL,
  `rating` INT NULL,
  `comment` VARCHAR(500) NULL,
  PRIMARY KEY (`ReviewID`),
  INDEX `fk_Review_Client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_Review_Session_idx` (`session_id` ASC) VISIBLE,
  CONSTRAINT `fk_Review_Client`
    FOREIGN KEY (`client_id`)
    REFERENCES `mydb`.`Client` (`ClientID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Review_Session`
    FOREIGN KEY (`session_id`)
    REFERENCES `mydb`.`Session` (`SessionID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Sample Data Inserts (simple)
-- -----------------------------------------------------
INSERT INTO `mydb`.`Client` (name, email, phone)
VALUES ('Alice', 'alice@mail.com', '555-1111');

INSERT INTO `mydb`.`Coach` (name, specialization, years_experience)
VALUES ('Dr. Smith', 'Career Advice', '5');

INSERT INTO `mydb`.`Session` (client_id, coach_id, datetime, duration_min, meeting_link)
VALUES (1, 1, '2025-09-20 10:00:00', 60, 'zoom-link');

INSERT INTO `mydb`.`Payment` (client_id, session_id, amount, method, status)
VALUES (1, 1, 100.00, 'card', 'paid');

INSERT INTO `mydb`.`Review` (client_id, session_id, rating, comment)
VALUES (1, 1, 5, 'Great session!');

-- -----------------------------------------------------
-- Test Query (join across tables)
-- -----------------------------------------------------
SELECT c.name AS Client,
       co.name AS Coach,
       s.datetime,
       p.amount,
       r.rating,
       r.comment
FROM `mydb`.`Session` s
JOIN `mydb`.`Client` c ON c.ClientID = s.client_id
JOIN `mydb`.`Coach`  co ON co.CoachID = s.coach_id
LEFT JOIN `mydb`.`Payment` p ON p.session_id = s.SessionID
LEFT JOIN `mydb`.`Review`  r ON r.session_id = s.SessionID;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

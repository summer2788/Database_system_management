-- Develop triggers that support the following integrity constraints using the HW3.sql:
--  Offsprings have at MOST one male, one female parent. Consider NULLS.
-- When inserting or updating specimen or ancestry, have trigger(s) raise the following exceptions:

-- If parent gender is null: Parent gender is set to NULL.
-- If the offspring already has two parents: Offspring already has two parents.
-- If the offspring has the same gendered parent: Offspring already has this gender parent, fix ancestries first.


-- --trial 1
-- /*One male, one female*/
-- INSERT INTO Ancestry VALUES(1004, 1002);
-- INSERT INTO Ancestry VALUES(1004, 1003);
-- /*Two females*/
-- INSERT INTO Ancestry VALUES(1001, 1004);
-- INSERT INTO Ancestry VALUES(1001, 1002);
--expected output: ERROR:  Offspring already has this gender parent, fix ancestries first.
-- --------------------------

-- --trial 2
-- /*Update male specimen to female or NULL*/
-- UPDATE Specimen SET Gender='F' WHERE EID = 1003;
--expected output: ERROR:  Offspring already has this gender parent, fix ancestries first.
-- --------------------------

-- --trial 3
-- /*Update male specimen to female or NULL*/
-- UPDATE Specimen SET Gender=NULL WHERE EID = 1003;
--expected output: ERROR:  Parent gender is set to NULL.
-- --------------------------

CREATE OR REPLACE FUNCTION check_parent_count() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Ancestry WHERE EID = NEW.EID) > 1 THEN
        RAISE EXCEPTION 'ERROR:  Offspring already has two parents.';
    -- ELSE if new.parent's gender = 'F' AND IF there exists already one 'F' parent for this offspring
    -- Raise ERROR 
    ELSEIF (SELECT COUNT(*) FROM Specimen WHERE EID = NEW.Parent AND gender ='F')>=1 THEN
        IF (SELECT COUNT(*) FROM Ancestry JOIN Specimen ON Ancestry.Parent=Specimen.EID WHERE NEW.EID=Ancestry.EID 
        AND Specimen.Gender ='F')>=1 THEN
        RAISE EXCEPTION 'ERROR:  Offspring already has this gender parent, fix ancestries first.';
        END IF;
    -- ELSE if new.parent's gender = 'M' AND IF there exists already one 'M' parent for this offspring
    -- Raise ERROR 
    ELSEIF (SELECT COUNT(*) FROM Specimen WHERE EID = NEW.Parent AND gender ='M')>=1 THEN
        IF (SELECT COUNT(*) FROM Ancestry JOIN Specimen ON Ancestry.Parent=Specimen.EID WHERE NEW.EID=Ancestry.EID 
        AND Specimen.Gender ='M')>=1 THEN
        RAISE EXCEPTION 'ERROR:  Offspring already has this gender parent, fix ancestries first.';
        END IF;
    END IF;    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_parent_count_trigger
    BEFORE INSERT OR UPDATE ON Ancestry
    FOR EACH ROW EXECUTE PROCEDURE check_parent_count();

--1. FIND THE NEW.EID'S OFFSTRING IN ANCESTRY TABLE
--2. CHECK IF THERE EXISTS SAME GENDER PARENT IN ANCESTRY TABLE AS NEW'S PARENT
--3. IF YES, RAISE ERROR
--4. IF NO, RETURN NEW

CREATE OR REPLACE FUNCTION check_parent_specimen() RETURNS TRIGGER AS $$
BEGIN 
    IF (SELECT COUNT(*) FROM Ancestry a1 JOIN Ancestry a2 ON a1.EID=a2.EID JOIN Specimen ON a2.parent = Specimen.EID  WHERE a1.parent = NEW.EID
    AND a2.parent <> NEW.EID AND Specimen.GENDER=NEW.GENDER) >= 1 THEN
    RAISE EXCEPTION 'ERROR:  Offspring already has this gender parent, fix ancestries first.';
    ELSEIF NEW.GENDER IS NULL THEN
    RAISE EXCEPTION 'ERROR:  Parent gender is set to NULL.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_parent_specimen_trigger
    BEFORE INSERT OR UPDATE ON Specimen
    FOR EACH ROW EXECUTE PROCEDURE check_parent_specimen();

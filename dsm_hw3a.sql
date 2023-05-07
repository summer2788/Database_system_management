-- Develop triggers that support the following integrity constraints using the HW3.sql:
-- Parents are not younger than their offsprings
-- When inserting or updating in specimen or ancestry, have trigger(s) raise an exception when the rule is broken: 'Has older offsprings, fix ancestries first.' and stop inserting or updating. 

CREATE FUNCTION check_specimen() RETURNS TRIGGER AS $$
    -- first check if NEW.EID is in the ancestry table 
    --if it is the eid, then check if the NEW.birthdate is less than the parent's birthdate
    --if it is the parent, then check if the NEW.birthdate is greater than the offspring's birthdate
    DECLARE
        parent_birthdate DATE;
        offspring_birthdate DATE;
        offspring_eid INTEGER;
        parent_eid INTEGER;
    BEGIN
        --child case
        IF EXISTS (SELECT * FROM Ancestry WHERE EID = NEW.EID) THEN
            parent_eid = (SELECT PARENT FROM Ancestry WHERE EID = NEW.EID);
            SELECT BirthDate INTO parent_birthdate FROM Specimen WHERE EID = parent_eid;
            IF parent_birthdate > NEW.BirthDate THEN
                RAISE EXCEPTION 'Has older offsprings, fix ancestries first.';
            END IF;    
        END IF;

        --parent case
        IF EXISTS (SELECT * FROM Ancestry WHERE PARENT= NEW.EID) THEN
            offspring_eid = (SELECT EID FROM Ancestry WHERE PARENT = NEW.EID);
            SELECT BirthDate INTO offspring_birthdate FROM Specimen WHERE EID = offspring_eid;
            IF offspring_birthdate < NEW.BirthDate THEN
                RAISE EXCEPTION 'Has older offsprings, fix ancestries first.';
            END IF;
        END IF;
        
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION check_ancestry() RETURNS TRIGGER AS $$
DECLARE
    parent_birthdate DATE;
    offspring_birthdate DATE;
BEGIN
    SELECT BirthDate INTO parent_birthdate FROM Specimen WHERE EID = NEW.Parent;
    SELECT BirthDate INTO offspring_birthdate FROM Specimen WHERE EID = NEW.EID;
    IF parent_birthdate > offspring_birthdate THEN
        RAISE EXCEPTION 'Has older offsprings, fix ancestries first.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_ancestry_trigger
    BEFORE INSERT OR UPDATE ON Ancestry
    FOR EACH ROW EXECUTE PROCEDURE check_ancestry();

CREATE TRIGGER check_specimen_trigger
    BEFORE INSERT OR UPDATE ON Specimen
    FOR EACH ROW EXECUTE PROCEDURE check_specimen();


-- Develop triggers that support the following integrity constraints using the HW3.sql:
--  If a compound (Habitat) becomes overbooked then we need a warning. Compare Habitat size to the SpaceRequirement of AnimalSpecies.
-- When inserting or updating specimen, have trigger(s) raise a warning: % Compound is overbooked by % / % if exceeding the size of the habitat.
-- Note: % marks in the trigger code act as placeholders for variables (similarly to what Python used with ? and SQL). 
-- So the three % marks correspond to three variables in the trigger code that should be: HID number, total size that would be in compound after the addition and finally the actual compound size. 
-- For example: hid = 100, habitat size = 120, total space requirements = 150.
-- % Compound is overbooked by % / %   == 100 compound is overbooked by 150/120. 
-- The variables are added after the string and separating them with a comma (as with Python and ? ? ? placeholders).

CREATE OR REPLACE FUNCTION check_habitat() RETURNS TRIGGER AS $$  
    DECLARE
        total_size INTEGER;
        habitat_size INTEGER;
        new_size INTEGER;

    BEGIN
        habitat_size = (SELECT Size FROM Habitat WHERE HID = NEW.HID);
        total_size = (SELECT SUM(SpaceRequirements) FROM AnimalSpecies JOIN Specimen ON AnimalSpecies.AID = Specimen.AID WHERE HID = NEW.HID) ; 
        new_size= (SELECT SpaceRequirements FROM AnimalSpecies WHERE AID = NEW.AID);
        total_size = total_size + new_size;
        IF total_size > habitat_size THEN
            RAISE WARNING '% Compound is overbooked by % / %', NEW.HID, total_size, habitat_size;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_habitat_trigger
    BEFORE INSERT OR UPDATE ON Specimen
    FOR EACH ROW EXECUTE PROCEDURE check_habitat();


    

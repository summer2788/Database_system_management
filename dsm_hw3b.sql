    -- Develop triggers that support the following integrity constraints using the HW3.sql:
    -- AnimalSpecies Habitat name must coincide with the Habitat table name (partial match of words is okay). Note that AnimalSpecies may have a longer list of possible habitats.
    -- Temperature should not differ more than 7 degrees of what the species needs. 
    -- When inserting specimen or updating habitat information, have trigger(s) do the following:

    -- If habitat name does not match, raise an exception: Not the correct habitat
    -- If habitat name does match, raise a notice: Correct habitat
    -- If temperature is over 7 degrees different, raise an execption: The Temperature difference can kill animals

    --these are the test input with expected output:

    --trial 1
    -- INSERT INTO AnimalSpecies VALUES(2, 'Tropical elephant', 'A', 35.5, 'tropical', 1, 3, 100.0);
    -- INSERT INTO AnimalSpecies VALUES(3, 'Elephant', 'A', 35.5, ' temperate, tropical', 1, 3, 100.0);
    -- /*Correct habitat*/
    -- INSERT INTO Specimen VALUES(1007, 3, 101, 'Dumbo', '01/03/2016', 'F', 30.0, 100.0);
    -- /*Incorrect habitat*/
    -- INSERT INTO Specimen VALUES(1006, 2, 104, 'Dumbont', '01/03/2016', 'F', 30.0, 100.0);
    -- --------------------------

    -- trial 2
    -- /*Temperature warning*/
    -- UPDATE Habitat SET Temperature = 42 WHERE HID =104;
    -- INSERT INTO Specimen VALUES(1008, 3, 104, 'Dumbo', '01/03/2016', 'F', 30.0, 100.0);
    -- --------------------------

    -- trial 3
    -- /*Too high temperature when putting to habitat*/
    -- UPDATE Habitat SET Temperature = 45 WHERE HID =103;
    -- INSERT INTO Specimen VALUES(1009, 3, 103, 'Dumbo', '01/03/2016', 'F', 30.0, 100.0);
    -- --------------------------

    -- trial 4
    -- /*Update habitat to "kill animals"*/
    -- UPDATE Habitat SET Temperature = 45 WHERE HID =101;
    -- --------------------------

CREATE OR REPLACE FUNCTION check_habitat() RETURNS TRIGGER AS $$
    DECLARE
        habitat_name TEXT;
        species_habitat TEXT;
        habitat_temp INTEGER;
        species_temp INTEGER;
    BEGIN
        habitat_name = (SELECT habitat FROM Habitat WHERE HID = NEW.HID);
        species_habitat = (SELECT Habitat FROM AnimalSpecies WHERE AID = NEW.AID);
        habitat_temp = (SELECT Temperature FROM Habitat WHERE HID = NEW.HID);
        species_temp = (SELECT Temperature FROM AnimalSpecies WHERE AID = NEW.AID);
        IF species_habitat like '%' || habitat_name || '%' THEN
            RAISE NOTICE 'Correct habitat';
        ELSE
            RAISE EXCEPTION 'Not the correct habitat';
        END IF;
        IF abs(habitat_temp - species_temp) > 7 THEN
            RAISE EXCEPTION 'The Temperature difference can kill animals';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_habitat_trigger
    BEFORE INSERT OR UPDATE ON Specimen
    FOR EACH ROW EXECUTE PROCEDURE check_habitat();


--check temperature in habitat using join
CREATE OR REPLACE FUNCTION check_habitat_temp() RETURNS TRIGGER AS $$
    DECLARE
        habitat_temp INTEGER;
        species_temp INTEGER;
    BEGIN
        habitat_temp = NEW.Temperature;
        IF EXISTS(SELECT * FROM AnimalSpecies JOIN Specimen ON AnimalSpecies.AID = Specimen.AID WHERE HID = NEW.HID AND abs(habitat_temp - Temperature) > 7) THEN
            RAISE EXCEPTION 'The Temperature difference can kill animals';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER check_habitat_temp_trigger
    BEFORE INSERT OR UPDATE ON Habitat
    FOR EACH ROW EXECUTE PROCEDURE check_habitat_temp();







    

         











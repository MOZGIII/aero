require 'db_core/models/model'

class CheckInDeskFlight < Model
  def CheckInDeskFlight.create_table(connection)
    begin
      connection.do("
CREATE TABLE check_id_desk_flights(
  id serial PRIMARY KEY,
  flight_id integer REFERENCES flights(id) NOT NULL,
  check_in_desk_id integer REFERENCES check_in_desks(id) NOT NULL,
  info text,
  UNIQUE(flight_id, check_in_desk_id)
) WITH OIDS
        ")
      return true
    rescue DBI::ProgrammingError => e
      return false
    end
  end
end

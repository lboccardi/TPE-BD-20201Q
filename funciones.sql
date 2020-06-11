drop table if exists YEAR,QUARTER,MONTH,DATEDETAIL,EVENT;
create table YEAR (
	year integer not null check (year < 2500),
	isleap boolean default false,
	primary key(year)
);

create table QUARTER (
	id serial not null,
	quarternumber integer not null check(quarternumber between 1 and 4),
	yearfk integer not null, 
	primary key(id), 
	unique(quarternumber, yearfk), 
	foreign key(yearfk) references year
);


create table MONTH (
	id serial not null,
	monthid integer not null check (monthid between 1 and 12),
	monthdesc varchar(20) check (monthdesc in ('enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre')),
	quarterfk integer not null,
	primary key(id),
	unique(monthid, quarterfk),
	foreign key (quarterfk) references quarter
);


create table DATEDETAIL (
	id serial not null, 
	day integer not null check (day between 1 and 31),
	dayofweek varchar(20) check (dayofweek in ('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo')),
	weekend boolean default false, 
	monthfk integer not null,
	primary key(id), 
	unique(day, monthfk), 
	foreign key(monthfk) references month
);

create table EVENT (
	Declaration_Number varchar(20) check (Declaration_Number like 'DR-_%'),
	Declaration_Type varchar(30) check (Declaration_Type in ('Disaster', 'Fire', 'Emergency')),
	Declaration_Date integer not null,
	State varchar(2) check( State in ('AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MS','MO','MT','NC','NE','NH','NJ','NM','NV','NY','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY')),
	Disaster_Type varchar(20) check( Disaster_Type in ('Tornado','Flood','Fire','Other','Earthquake','Hurricane','Volcano','Storm','Chemical','Typhoon','Drought','Dam/Levee Break','Snow','Ice','Winter','Mud/Landslide','Human Cause','Terrorism','Tsunami','Water')),
	primary key (Declaration_Number),
	foreign key (Declaration_Date) references DATEDETAIL
);
create or replace function get_weekday (IN weekday integer)
    returns varchar as $$
    begin
        case weekday
        when 0 then return 'domingo';
        when 1 then return 'lunes';
        when 2 then return 'martes';
        when 3 then return 'miercoles';
        when 4 then return 'jueves';
        when 5 then return 'viernes';
        when 6 then return 'sabado';
        else raise exception 'error number';
        end case;
    end;
    $$ language plpgsql;

DO $$
 DECLARE
 d1 integer:= 0;
 d2 integer:= 2;
 d3 integer:= 22;
 begin
     raise notice '%',get_weekday(d1);
     raise notice '%',get_weekday(d2);
    raise notice '%',get_weekday(d3);
 end;
$$
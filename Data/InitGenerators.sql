create procedure INIT_GENERATORS
returns (
    S varchar(255))
as
declare variable REL_NAME varchar(31);
declare variable GEN_NAME varchar(31);
begin
  for select RDB$RELATION_NAME
      from RDB$RELATIONS
      where (RDB$VIEW_BLR is null) and
            (RDB$RELATION_NAME not starting with 'RDB$')
      into :REL_NAME
  do
  begin
    GEN_NAME = 'GEN_' || :REL_NAME;
    S = 'CREATE GENERATOR ' || :GEN_NAME || ';';
    suspend;
    S = 'SET GENERATOR ' || :GEN_NAME || ' TO (SELECT MAX(ID) FROM ' ||
:REL_NAME || ');';
    suspend;
  end
end;
 
output 'C:\init_generators.sql';
 
select * from INIT_GENERATORS;
commit;
output;
 
drop procedure INIT_GENERATORS;

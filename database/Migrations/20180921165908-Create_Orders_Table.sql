@@map_types.sql

RECREATE TABLE {id orders} (
	{id id}	!IDENTITY,
	{id lockid}	!UPDLOCKCTL,
	{id created_at}	!datetime,
	{id updated_at}	!datetime,
	{id company_id}	!IDREFERENCE,
	{id status} !ENUM,
	{id number}	!STRING16,
	{id reference} !STRING16,
	{id total}	!MONEY,
	{id note}	!BIGTEXT
);


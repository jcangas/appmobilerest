@@map_types.sql

RECREATE TABLE {id products} (
	{id id}	!IDENTITY,
	{id lockid}	!UPDLOCKCTL,
	{id created_at}	!DATETIME,
	{id updated_at}	!DATETIME,
	{id code}	!STRING32,
	{id description} !SHORTEXT,
  {id price} !MONEY
);

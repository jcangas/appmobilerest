@@map_types.sql

RECREATE TABLE {id companies} (
	{id id}	!IDENTITY,
	{id lockid}	!UPDLOCKCTL,
	{id created_at}	!DATETIME,
	{id updated_at}	!DATETIME,
	{id code}	!STRING16,
	{id name}	!STRING64,
	{id nif} !STRING16,
	{id street}	!STRING64,
	{id zipcode} !STRING16,
	{id city}	!STRING32,
	{id state} !STRING32,
	{id country} !STRING8,
	{id email} !EMAIL,
	{id phone} !PHONE
);

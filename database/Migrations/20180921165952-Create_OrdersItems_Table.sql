@@map_types.sql

RECREATE TABLE {id order_items} (
	{id id}	!IDENTITY,
	{id lockid}	!UPDLOCKCTL,
	{id created_at}	!datetime,
	{id updated_at}	!datetime,
	{id order_id} !IDREFERENCE,
	{id product_id} !IDREFERENCE,
	{id quantity} !DECIMAL,
	{id price} !MONEY,
	{id total} !MONEY
);

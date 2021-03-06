set echo off feedback off break off
/* TYPE MAP FOR FIREBIRD */
DEF IDENTITY="BIGINT generated by default as identity primary key"
DEF IDREFERENCE=BIGINT
DEF UPDLOCKCTL="BIGINT NOT NULL"
DEF GUID=CHAR(38)
DEF BOOL=BOOLEAN
DEF ENUM=INTEGER
DEF INT8=SMALLINT
DEF INT16=SMALLINT
DEF INT32=INTEGER
DEF INT64=BIGINT
DEF INT=BIGINT
DEF DECIMAL=DECIMAL(15,4)
DEF SMALLMONEY=DECIMAL(10,4)
DEF MONEY=DECIMAL(18,4)
DEF DATE=DATE
DEF TIME=TIME
DEF DATETIME=TIMESTAMP
DEF STRING=VARCHAR
DEF STRING8=VARCHAR(16)
DEF STRING16=VARCHAR(16)
DEF STRING32=VARCHAR(32)
DEF STRING64=VARCHAR(64)
DEF STRING128=VARCHAR(128)
DEF SHORTEXT=VARCHAR(200)
DEF BIGTEXT="BLOB SUB_TYPE TEXT"

DEF EMAIL=VARCHAR(64)
DEF PHONE=VARCHAR(16)
DEF URL=VARCHAR(256)


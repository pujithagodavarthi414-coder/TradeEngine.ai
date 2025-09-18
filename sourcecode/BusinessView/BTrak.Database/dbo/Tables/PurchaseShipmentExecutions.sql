CREATE TABLE [dbo].[PurchaseShipmentExecutions]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[ContractId] UNIQUEIDENTIFIER NOT NULL,
	[ShipmentNumber] NVARCHAR(250) NULL,
	[ShipmentQuantity] Decimal(18,2) NULL,
	[BLQuantity] Decimal(18,2) NULL,
	[VesselId] UNIQUEIDENTIFIER NULL,
	[VoyageNumber] NVARCHAR(250) NULL,
	[PortLoadId] UNIQUEIDENTIFIER NULL,
	[PortDischargeId] UNIQUEIDENTIFIER NULL,
	[WorkEmployeeId] UNIQUEIDENTIFIER NULL,
	[ETADate] DATETIME NULL, 
	[FillDueDate] DATETIME NULL, 
	[StatusId] UNIQUEIDENTIFIER NULL,
	CompanyId [uniqueidentifier]  NULL,
    [InactiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,

)

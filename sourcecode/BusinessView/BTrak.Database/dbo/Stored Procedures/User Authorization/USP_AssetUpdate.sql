CREATE PROCEDURE [dbo].[USP_AssetUpdate]
(
	@Id uniqueidentifier,
	@AssetNumber nvarchar(50),
	@PurchasedDate datetime,
	@ProductId uniqueidentifier,
	@AssetName nvarchar(50),
	@Cost decimal(18, 0),
	@CurrencyId uniqueidentifier,
	@IsWriteOff bit,
	@DamagedDate datetime,
	@DamagedReason nvarchar(800),
	@IsEmpty bit,
	@IsVendor bit,
	@CreatedDateTime datetime,
	@CreatedByUserId uniqueidentifier,
	@UpdatedDateTime datetime,
	@UpdatedByUserId uniqueidentifier
)

AS

SET NOCOUNT ON

UPDATE [Asset]
SET [AssetNumber] = @AssetNumber,
	[PurchasedDate] = @PurchasedDate,
	[ProductId] = @ProductId,
	[AssetName] = @AssetName,
	[Cost] = @Cost,
	[CurrencyId] = @CurrencyId,
	[IsWriteOff] = @IsWriteOff,
	[DamagedDate] = @DamagedDate,
	[DamagedReason] = @DamagedReason,
	[IsEmpty] = @IsEmpty,
	[IsVendor] = @IsVendor,
	[CreatedDateTime] = @CreatedDateTime,
	[CreatedByUserId] = @CreatedByUserId
WHERE [Id] = @Id
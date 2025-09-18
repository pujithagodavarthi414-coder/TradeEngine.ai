CREATE PROCEDURE [dbo].[USP_UpsertTVA]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@TVAValue DECIMAL(20, 4),
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
		
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@Id =  '00000000-0000-0000-0000-000000000000') SET @Id = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[TVA] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
				BEGIN
					IF(@Id IS NULL)
					BEGIN
						SET @Id = (SELECT NEWID())

						INSERT INTO [dbo].[TVA](
											Id,
											TVAValue,
											StartDate,
											EndDate,
											CompanyId,
											CreatedByUserId,
											CreatedDateTime
											)
									SELECT @Id,
										   @TVAValue,
										   @StartDate,
										   @EndDate,
										   @CompanyId,
										   @OperationsPerformedBy,
										   GETDATE()
					END
					ELSE
					BEGIN
						UPDATE [dbo].[TVA]
								SET TVAValue = @TVAValue,
									StartDate = @StartDate,
									EndDate = @EndDate,
									UpdatedByUserId = @OperationsPerformedBy,
									UpdatedDateTime = GETDATE(),
									InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
						WHERE Id = @Id
					END
					SELECT @Id
				END

		END
		ELSE
		RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
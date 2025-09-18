CREATE PROCEDURE [dbo].[USP_UpsertRFQRequest]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @DataSetId UNIQUEIDENTIFIER = NULL,
   @DataSourceId UNIQUEIDENTIFIER = NULL,
   @TemplateId UNIQUEIDENTIFIER = NULL,
   @TemplateTypeId UNIQUEIDENTIFIER = NULL,
   @ClientIdXml XML = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
														FROM [RFQRequest] WHERE Id = @Id ) = @TimeStamp
												THEN 1 ELSE 0 END END)
			IF(@IsLatest = 1)
			BEGIN
				IF(@Id IS NULL)
				BEGIN
					DECLARE @ClientIdList TABLE
					(
						ClientId UNIQUEIDENTIFIER
					)

					INSERT INTO @ClientIdList(ClientId)
					SELECT x.value('Id[1]','UNIQUEIDENTIFIER') AS Id
					FROM  @ClientIdXml.nodes('/GenericListOfGuid/ListItems/guid') XmlData(x)

					INSERT INTO [dbo].[RFQRequest](
								[Id],
								ClientId,
								DataSourceId,
								CreatedDateTime,
								CreatedByUserId
								)
						SELECT NEWID(),
							   ClientId,
							   @DataSourceId,
							   GETDATE(),
							   @OperationsPerformedBy
							   FROM @ClientIdList
				END
			END
			ELSE
			  	RAISERROR (50008,11, 1)
			SELECT 1
		END
		ELSE
		BEGIN
			RAISERROR (@HavePermission,11, 1)			
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
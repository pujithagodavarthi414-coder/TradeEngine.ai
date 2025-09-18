CREATE PROCEDURE [dbo].[USP_UpsertDocumentsDescriptions]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@DescriptionsXml XML = NULL,
    @ReferenceTypeId UNIQUEIDENTIFIER=NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@ReferenceTypeId =  '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

						DECLARE @CurrentDate DATETIME = GETDATE()
						IF(@DescriptionsXml IS NOT NULL)
						BEGIN
								CREATE TABLE #InitialDescription        
                                    (						           
                                        Id UNIQUEIDENTIFIER, 
                                        [Description] NVARCHAR(max),
                                        OrderNumber INT,
										DescriptionId UNIQUEIDENTIFIER
                                    )
									INSERT INTO #InitialDescription(Id,[Description],OrderNumber,DescriptionId)
                                    SELECT NEWID(),
                                            [Table].[Column].value('Description[1]', 'nvarchar(Max)'),
                                            [Table].[Column].value('OrderNumber[1]', 'INT'),
                                            IIF([Table].[Column].value('Id[1]', 'nvarchar(2000)')='',NULL,[Table].[Column].value('Id[1]', 'UNIQUEIDENTIFIER'))
                                    FROM @DescriptionsXml.nodes('/ArrayOfInitialDocumentsDescription/InitialDocumentsDescription') AS [Table]([Column])
									UPDATE [DocumentsDescription] 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									        WHERE ReferenceId = '1912F3AC-5BAA-4EDC-894D-10103F96AF58' AND Id NOT IN (SELECT DescriptionId FROM #InitialDescription) AND InactiveDateTime IS NULL AND ReferenceTypeId=@ReferenceTypeId
									 UPDATE [DocumentsDescription] 
										 SET [ReferenceId]      = '1912F3AC-5BAA-4EDC-894D-10103F96AF58',
										     [ReferenceTypeId]   = @ReferenceTypeId,
											 [Description]  = D.[Description],
											 OrderNumber  = D.OrderNumber,
											 UpdatedDateTime = @Currentdate,
											 UpdatedByUserId = @OperationsPerformedBy
											FROM #InitialDescription D
											WHERE [DocumentsDescription].Id  = D.DescriptionId

											INSERT INTO [DocumentsDescription](
                                                        [Id],
                                                        [Description],
                                                        [ReferenceId],
                                                        [ReferenceTypeId],
                                                        OrderNumber,
                                                        CreatedDateTime,
                                                        CreatedByUserId
                                                        )
                                                 SELECT D.Id,
                                                        D.[Description], 
                                                        '1912F3AC-5BAA-4EDC-894D-10103F96AF58',
                                                        @ReferenceTypeId,
                                                        D.OrderNumber,
                                                        @Currentdate,
                                                        @OperationsPerformedBy
                                                   FROM #InitialDescription D WHERE D.DescriptionId IS  NULL 
									END
									ELSE
									BEGIN
									UPDATE [DocumentsDescription] 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									        WHERE ReferenceId = '1912F3AC-5BAA-4EDC-894D-10103F96AF58' AND InactiveDateTime IS NULL AND ReferenceTypeId=@ReferenceTypeId      
									END

								
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
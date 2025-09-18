-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-21 00:00:00.000'
-- Purpose      To Save or Update EntityTypeRoleFeature
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEntityRoleFeature]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@EntityRoleId= '19B6F9FC-7370-4B9C-A05C-3B8D819EEEAF',
--@EntityFeatureIdXml=N'<GenericListOfGuid><ListItems><guid>AB90D413-5021-4232-ACAB-11E11E9A59E6</guid><guid>CB4F95E1-08E8-46CD-A25A-352EAED56505</guid><guid>BE7781C6-713D-4B8A-AFF7-4EA7D0415730</guid></ListItems></GenericListOfGuid>'

CREATE PROCEDURE [dbo].[USP_UpsertEntityRoleFeature]
( 
   @EntityFeatureIdXml    XML = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @EntityRoleId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
		IF (@HavePermission = '1')
		BEGIN
				DECLARE @Currentdate DATETIME = GETDATE()
				
				UPDATE EntityRoleFeature SET InactiveDateTime = @Currentdate, UpdatedByUserId = @OperationsPerformedBy, UpdatedDateTime = @Currentdate WHERE EntityRoleId = @EntityRoleId

		        DECLARE @Temp TABLE
				(
					EntityRoleFeatureId  UNIQUEIDENTIFIER,
					EntityFeatureId UNIQUEIDENTIFIER
				)
				INSERT INTO  @Temp(EntityRoleFeatureId ,EntityFeatureId)
				SELECT NEWID(),x1.y1.value('(text())[1]','varchar(100)')
				FROM @EntityFeatureIdXml.nodes('/GenericListOfGuid/ListItems/guid') AS x1(y1)
		       
				 INSERT INTO [dbo].[EntityRoleFeature](
		                     [Id],
							 [EntityFeatureId],
							 [EntityRoleId],
							 [InActiveDateTime],
							 [CreatedDateTime],
							 [CreatedByUserId]				
							 )
		              SELECT EntityRoleFeatureId,
							 EntityFeatureId,
							 @EntityRoleId,
							 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
							 @Currentdate,
							 @OperationsPerformedBy		
				             FROM @Temp  
				            
					SELECT  @EntityRoleId AS EntityRoleId
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

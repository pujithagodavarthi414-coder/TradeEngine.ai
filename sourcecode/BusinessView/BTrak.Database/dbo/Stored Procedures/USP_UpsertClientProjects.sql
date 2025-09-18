----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-25 00:00:00.000'
-- Purpose      To Update Client Projects by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertClientProjects] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientProjectId = '8169D6A6-E082-4F66-AA14-DBB455DBC063', 
-- @ClientId = '09CF62AD-B1CB-43C7-91B7-B0CC2451FBFF', @ProjectId = '53C96173-0651-48BD-88A9-7FC79E836CCE', @IsArchived = 0, @TimeStamp = 0x000000000003690C
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertClientProjects]
(
   @ClientProjectId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @ClientId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		   IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL  
		  
	       IF(@ClientId IS NULL)	      
		   BEGIN
		     
		       RAISERROR(50011,16, 2, 'ClientId')
		  
		   END	
	   	   	    
		   IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL  
		  
	       IF(@ProjectId IS NULL)	      
		   BEGIN
		     
		       RAISERROR(50011,16, 2, 'ProjectId')
		  
		   END		  
		   ELSE 	
	   	   	  		  
			  DECLARE @ClientProjectIdCount INT = (SELECT COUNT(1) FROM ClientProjects WHERE Id = @ClientProjectId) 
			  
			  DECLARE @ProjectIdCount INT = (SELECT COUNT(1) FROM ClientProjects WHERE ProjectId = @ProjectId)     
       	  
			  IF(@ClientProjectIdCount = 0 AND @ClientProjectId IS NOT NULL)
			  BEGIN
              
		  		RAISERROR(50002,16, 2,'ClientProject')
          
			  END
			  ELSE IF(@ProjectIdCount > 0)
			  BEGIN
              
		  		RAISERROR(50001,16, 1,'ProjectId')
          
			  END
			  ELSE
		 
				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @ClientProjectId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ClientProjects WHERE Id = @ClientProjectId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
					IF(@IsLatest = 1)
					BEGIN

						DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					
						DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM ClientProjects WHERE Id = @ClientProjectId)

						DECLARE @Currentdate DATETIME = GETDATE()						

						DECLARE @OldProjectId UNIQUEIDENTIFIER  = (SELECT [ProjectId] FROM ClientProjects CP WHERE CP.Id = @ClientProjectId)

						DECLARE @NewValue NVARCHAR (250)

						DECLARE @FieldName NVARCHAR (250)

						DECLARE @Description NVARCHAR (1000)

						IF(@ClientId IS NULL)
						BEGIN

							EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @FieldName = 'Insert', @OperationsPerformedBy = @OperationsPerformedBy

						END
						ELSE
						BEGIN

							IF(@ProjectId <> @OldProjectId)
							BEGIN 

								 SET @FieldName = 'ProjectId' 

								 SET @Description = 'PROJECTIDUPDATED'

								 EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldProjectId, @NewValue = @ProjectId, @FieldName = @FieldName,
								 @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

							END

						END

					 IF(@ClientProjectId IS NULL)
					 BEGIN
					 SET @ClientProjectId = NEWID()

						INSERT INTO [dbo].[ClientProjects](
									[Id],
			   	         			[ClientId],
									[ProjectId],
									[CreatedDateTime],
			   	         			[CreatedByUserId],			
			   	         			[InActiveDateTime]
			   	         			)
							 SELECT @ClientProjectId,
									@ClientId,
									@ProjectId,
									@Currentdate,
			   	         			@OperationsPerformedBy,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END 

						END
						ELSE
						BEGIN
						UPDATE [ClientProjects]
						   SET [ClientId] = @ClientId,
                               [ProjectId] = @ProjectId,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE Id = @ClientProjectId
						END	

						SELECT Id FROM [dbo].[ClientProjects] WHERE Id = @ClientProjectId

 					END
					ELSE

						RAISERROR(50008,11,1)

				END
				ELSE
				BEGIN

					RAISERROR(@HavePermission,11,1)

				END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO

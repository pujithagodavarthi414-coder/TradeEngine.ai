-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Save or Update the Module
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertModule] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ModuleName='Test'

CREATE PROCEDURE [dbo].[USP_UpsertModule]
(
    @ModuleId UNIQUEIDENTIFIER = NULL,
    @ModuleName NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT =0,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 
	IF (@HavePermission = '1')
	BEGIN


    DECLARE @CurrentDate DATETIME = GETDATE()

	DECLARE @ModuleNameCount INT = (SELECT COUNT(1) FROM Module WHERE ModuleName = @ModuleName AND (@ModuleId IS NULL OR Id = @ModuleId) AND InActiveDateTime IS NULL)

	DECLARE @ModuleIdCount INT = (SELECT COUNT(1) FROM BugPriority WHERE Id = @ModuleId AND InActiveDateTime IS NULL)

	IF(@ModuleName IS NULL)
	BEGIN
	
		RAISERROR(50011,16, 2, 'ModuleName')
	
	END
	ELSE IF(@ModuleNameCount > 0)
	BEGIN
	
		RAISERROR(50001,16,1,'Module')
	
	END
	ELSE IF(@ModuleIdCount = 0 AND @ModuleId IS NOT NULL)
	BEGIN
	
		RAISERROR(50002,16, 1,'Module')
	
	END
	ELSE
	BEGIN
			DECLARE @IsLatest BIT = (CASE WHEN @ModuleId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                     FROM [Module] WHERE Id = @ModuleId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
     
			 IF(@IsLatest = 1)
			 BEGIN
		           
				   IF(@ModuleId IS NULL)
				   BEGIN
					 
						SET @ModuleId = NEWID()
						       
						INSERT INTO [dbo].[Module](
									[Id],
									[ModuleName],
									[CreatedDateTime],
									[CreatedByUserId],
									InActiveDateTime)
						   SELECT @ModuleId,
						          @ModuleName,
						          @Currentdate,
						          @OperationsPerformedBy,
								  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					END
					ELSE
					BEGIN
						
						UPDATE [dbo].[Module]
						    SET [ModuleName]  = @ModuleName
							    ,[UpdatedByUserId] = @OperationsPerformedBy
								,[UpdatedDateTime] = @CurrentDate
								,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @ModuleId

					END
					   
					SELECT Id FROM [dbo].[Module] WHERE Id = @ModuleId
		                    
			 END
			 ELSE

		        RAISERROR (50008,11, 1)

	END
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
-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Save or update the  main use case
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertMainUseCase] @MainUseCaseName = 'Test',@IsArchived = 0,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@TimeStamp = 0x000000000000177E,@MainUseCaseId = 'BB88EBA1-A9D7-4510-A528-A6D7A93F46D5'
------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertMainUseCase
(
	@MainUseCaseId UNIQUEIDENTIFIER = NULL,
	@MainUseCaseName NVARCHAR(1000) = NULL,
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
    IF (@OperationsPerformedBy='00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	IF (@MainUseCaseId = '00000000-0000-0000-0000-000000000000') Set @MainUseCaseId = NULL

	IF (@MainUseCaseName = '') SET @MainUseCaseName = NULL

	IF(@IsArchived = 1 AND @MainUseCaseId IS NOT NULL)
	BEGIN

		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
            IF(EXISTS(SELECT Id FROM [Company] WHERE MainUseCaseId = @MainUseCaseId))
            BEGIN
	        
				SET @IsEligibleToArchive = 'ThisMainUseCaseUsedInCompanyDeleteTheDependenciesAndTryAgain'
            
            END

			IF(@IsEligibleToArchive <> '1')
            BEGIN
         
				RAISERROR (@isEligibleToArchive,11, 1)
         
            END

	END   

    IF (@MainUseCaseName = NULL)
    BEGIN
	  
	  RAISERROR(50011,16,2,'MainUsecaseName')

	END

	ELSE
	BEGIN
	 
	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	   DECLARE @MainUseIdCount INT = (SELECT COUNT(1) FROM [MainUseCase] WHERE Id = @MainUseCaseId)

	   DECLARE @MainUseCaseNameCount INT = (SELECT COUNT(1) FROM [MainUseCase] 
	                                        WHERE MainUseCaseName = @MainUseCaseName AND 
	                                             (@MainUsecaseId IS NULL OR Id <> @MainUseCaseId))

	IF (@MainUseIdCount = 0 AND @MainUseCaseId IS NOT NULL)
	BEGIN
	 
	  RAISERROR(50002,16,1,'MainUsecaseName')
	 
	END
	ELSE IF(@MainUseCaseNameCount > 0)
	BEGIN
	 
	 RAISERROR(50001,16,1,'MainUsecaseName')

	END
	ELSE
	BEGIN
	 
	  DECLARE @IsLatest BIT = ( CASE WHEN @MainUseCaseId IS NULL THEN 1  
	                                ELSE CASE WHEN (SELECT [TimeStamp]  FROM [dbo].[MainUseCase] 
	                                           WHERE Id = @MainUseCaseId) = @TimeStamp THEN 1 ELSE 0 END END)
	

	   IF(@IsLatest = 1)
	   BEGIN
	     
		 DECLARE @CurrentDate DATETIME = GETDATE()
	
		 IF(@MainUseCaseId IS NULL)
		 BEGIN
			
			 SET @MainUseCaseId = NEWID()

			 INSERT INTO [MainUsecase](
			                           Id,
			                           MainUseCaseName,
			                           CreatedDateTime,
			                           InActiveDateTime
									  )
							
							  SELECT  @MainUseCaseId,
							          @MainUseCaseName,
									  @Currentdate,
									  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

		 END
		 ELSE
		 BEGIN
				
				UPDATE [dbo].[MainUsecase]
				  SET [MainUseCaseName]  = @MainUseCaseName
				      ,[UpdatedByUserId] = @OperationsPerformedBy
					  ,[UpdatedDateTime] = @CurrentDate
					  ,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
				WHERE Id = @MainUseCaseId

		 END

		SELECT Id FROM [MainUseCase] WHERE Id = @MainUseCaseId

	    END 
		ELSE 
		  
		  RAISERROR(50008,11,1)

	    END

		END
		
  END TRY
   
  BEGIN CATCH

     THROW

  END CATCH

END
GO
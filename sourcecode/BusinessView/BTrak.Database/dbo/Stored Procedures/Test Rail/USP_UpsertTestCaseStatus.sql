-------------------------------------------------------------------------------
-- Modified      Mahesh Musuku
-- Created      '2019-07-08 00:00:00.000'
-- Purpose      To Save or update the TestCaseStatus
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestCaseStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Status = 'test',@StatusHexValue = '#FFFFFF'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestCaseStatus]
(
	@TestCaseStatusId UNIQUEIDENTIFIER = NULL,
	@Status NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@TimeZone NVARCHAR(250) = NULL,
	@StatusHexValue NVARCHAR(50) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	      
		  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
       
           IF (@HavePermission = '1')
           BEGIN

		        IF(@Status = '') SET @Status = NULL
		        
			    IF(@IsArchived = 1 AND @TestCaseStatusId IS NOT NULL)
		        BEGIN
		 	    
		              DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
			          
	                  IF(EXISTS(SELECT Id FROM [TestRunSelectedCase] WHERE StatusId = @TestCaseStatusId ))
	                  BEGIN
	                  
	                  SET @IsEligibleToArchive = 'ThisTestCaseStatusUsedInTestRunSelectedCaseDeleteTheDependenciesAndTryAgain'
	                  
	                  END
					  ELSE IF(EXISTS(SELECT Id FROM [TestRunSelectedStep] WHERE StatusId = @TestCaseStatusId))
	                  BEGIN
	                  
	                  SET @IsEligibleToArchive = 'ThisTestCaseStatusUsedInTestRunSelectedStepDeleteTheDependenciesAndTryAgain'
	                  
	                  END
			          
			          IF(@IsEligibleToArchive <> '1')
		              BEGIN
		              
		                  RAISERROR (@isEligibleToArchive,11, 1)
		              
		              END
                END

		        IF(@Status IS NULL)
		        BEGIN
		        	
		            RAISERROR(50011,16, 2, 'TestCaseStatus')
		        
		        END
		        ELSE
		        BEGIN
		        
		        	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	                SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

                    DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)



		        
		        	DECLARE @TestCaseStatusIdCount INT = (SELECT COUNT(1) FROM TestCaseStatus WHERE Id = @TestCaseStatusId AND CompanyId = @CompanyId)
		        	    
		        	DECLARE @StatusCount INT = (SELECT COUNT(1) FROM [dbo].[TestCaseStatus] WHERE [Status] = @Status AND CompanyId = @CompanyId AND (Id <> @TestCaseStatusId OR @TestCaseStatusId IS NULL))
		        
		            IF(@TestCaseStatusIdCount = 0 AND @TestCaseStatusId IS NOT NULL)
		            BEGIN
		        
		            	RAISERROR(50002,16, 1,'TestCaseStatus')
		        
		            END
		            ELSE IF(@StatusCount > 0)
		        	BEGIN
		        
		        		RAISERROR(50001,16,1,'TestCaseStatus')
		        
		        	END
		            ELSE
		            BEGIN
		        			DECLARE @IsLatest BIT = (CASE WHEN @TestCaseStatusId IS NULL 
		        			                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
		        																 FROM [TestCaseStatus] WHERE Id = @TestCaseStatusId) = @TimeStamp
		        														   THEN 1 ELSE 0 END END)
                
		        			IF(@IsLatest = 1)
		        			BEGIN
		        
		        				--DECLARE @Currentdate DATETIME = GETDATE()
		        		      
		        			       UPDATE    [dbo].[TestCaseStatus]
		        			          SET    [Status] = @Status,
		        							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
		        							 [StatusHexValue] = @StatusHexValue,
		        							 [CompanyId] = @CompanyId,
		        			                 [UpdatedDateTime] = @Currentdate ,
											 [UpdatedDateTimeZoneId] = @TimeZoneId,
		        			                 [UpdatedByUserId] = @OperationsPerformedBy,
											 [IsFailed] = IsFailed,
											 [IsBlocked] = IsBlocked,
											 [IsPassed] = IsPassed,
											 [IsReTest] = IsReTest,
											 [IsUntested] = IsUntested
											 FROM TestCaseStatus TCS 
											 WHERE Id = @TestCaseStatusId AND CompanyId = @CompanyId

		        			SELECT Id FROM [dbo].[TestCaseStatus] WHERE Id = @TestCaseStatusId
		        		
		        		END
		        		ELSE
		        		  RAISERROR (50008,11, 1)
		        
		     END
		        
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

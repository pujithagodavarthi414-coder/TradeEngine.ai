-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestSuite
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Ranadheer Rana Velaga
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the TestSuite
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestCaseType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TypeName='test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestCaseType]
(
    @TestCaseTypeId UNIQUEIDENTIFIER = NULL,
    @TypeName NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @IsDefault BIT = NULL
​
)
AS
BEGIN
​
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
​
		IF(@TypeName = '') SET @TypeName = NULL
​
		IF(@IsArchived = 1 AND @TestCaseTypeId IS NOT NULL)
		BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM [TestCase] WHERE TypeId = @TestCaseTypeId AND InActiveDateTime IS NULL))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisTestCaseTypeUsedInTestCaseDeleteTheDependenciesAndTryAgain'
	         
	         END
			
			 IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END
        END
		
		IF(@TypeName IS NULL)
		BEGIN
			
		    RAISERROR(50011,16, 2, 'TypeName')
​
		END
		ELSE
		BEGIN
​
			    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	            SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

                DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)


​
				DECLARE @Default BIT = (SELECT IsDefault FROM TestCaseType WHERE Id = @TestCaseTypeId  AND InActiveDateTime IS NULL)
			    
			    DECLARE @TestCaseTypeIdCount INT = (SELECT COUNT(1) FROM TestCaseType WHERE Id = @TestCaseTypeId AND CompanyId = @CompanyId )
			      
			    DECLARE @TypeNamesCount INT = (SELECT COUNT(1) FROM [dbo].[TestCaseType] WHERE [TypeName] = @TypeName AND CompanyId = @CompanyId AND (Id <> @TestCaseTypeId OR @TestCaseTypeId IS NULL) )
			    
			    IF(@TestCaseTypeIdCount = 0 AND @TestCaseTypeId IS NOT NULL)
		        BEGIN
			    
		        	RAISERROR(50002,16, 1,'TestcaseType')
			    
		        END
		        ELSE IF(@TypeNamesCount > 0)
			    BEGIN
			    
			    	RAISERROR(50001,16,1,'TestcaseType')
			    
			    END
				ELSE IF (@Default = 1 AND @IsArchived =1)
				BEGIN
​
					RAISERROR('SetDefaultToAnotherTestCaseBeforeDeletingThis',16,1)
​
				END
				ELSE IF (@Default = 1 AND @IsDefault = 0)
		        BEGIN
​
					RAISERROR('SetDefaultToAnotherTestCaseBeforeEditingThis',16,1)
​
		        END
		        ELSE
		        BEGIN
				
				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
				IF (@HavePermission = '1')
                BEGIN
				
					DECLARE @IsLatest BIT = (CASE WHEN @TestCaseTypeId IS NULL 
					                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [TestCaseType] WHERE Id = @TestCaseTypeId) = @TimeStamp
																   THEN 1 ELSE 0 END END)
        
					IF(@IsLatest = 1)
					BEGIN
				    
						--DECLARE @Currentdate DATETIME = GETDATE()
​
                                UPDATE [TestCaseType]
								   SET IsDefault = 0 ,
								       UpdatedDateTime = @Currentdate,
									   UpdatedByUserId = @OperationsPerformedBy
							     WHERE IsDefault =1 AND CompanyId = @CompanyId AND @IsDefault = 1
​
						 IF(@TestCaseTypeId IS NULL)
						 BEGIN

						 SET @TestCaseTypeId = NEWID()

						  INSERT INTO [dbo].TestCaseType(
						              [Id],
						              [TypeName],
						              [InActiveDateTime],
						              [CompanyId],
						              [CreatedDateTime],
									  [CreatedDateTimeZoneId],
						              [CreatedByUserId],
									  [isDefault])
						       SELECT @TestCaseTypeId,
						              @TypeName,
						              CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						              @CompanyId,
						              @Currentdate,
									  @TimeZoneId,
						              @OperationsPerformedBy,
									  @IsDefault
							END
							ELSE
							BEGIN

						       UPDATE [dbo].TestCaseType
						          SET [TypeName] = @TypeName,
						              [InActiveDateTime] =CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  [InActiveDateTimeZoneId] = CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
						              [CompanyId] = @CompanyId,
						              [UpdatedDateTime] = @Currentdate,
									  [UpdatedDateTimeZoneId] =  @TimeZoneId,
						              [UpdatedByUserId] = @OperationsPerformedBy,
									  [isDefault] = @IsDefault
									  WHERE Id = @TestCaseTypeId

							END
	       				
						SELECT Id FROM [dbo].[TestCaseType] WHERE Id = @TestCaseTypeId
						     
				    END
				    ELSE
				      RAISERROR (50008,11, 1)
				    
				    END
				    ELSE
				    BEGIN
				    
				    	RAISERROR (@HavePermission,11, 1)
				    	
				    END
	END	    
				    
END		    
​
END TRY
BEGIN CATCH
​
   THROW
​
END CATCH
END
GO
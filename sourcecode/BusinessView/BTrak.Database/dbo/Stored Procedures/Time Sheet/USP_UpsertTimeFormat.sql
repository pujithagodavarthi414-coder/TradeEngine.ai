-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Save or update the time formats
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTimeFormat] @TimeFormatDisplayText = 'Test',@IsArchived = 0,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE  [dbo].[USP_UpsertTimeFormat]
(
 @TimeFormatId UNIQUEIDENTIFIER = NULL,
 @TimeFormatDisplayText NVARCHAR(100) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	   
	    IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF (@TimeFormatId = '00000000-0000-0000-0000-000000000000') SET @TimeFormatId = NULL    

		IF (@TimeFormatDisplayText = '') SET @TimeFormatDisplayText = NULL

		IF(@IsArchived = 1 AND @TimeFormatId IS NOT NULL)
	    BEGIN

	      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
          IF(EXISTS(SELECT Id FROM [Company] WHERE TimeFormatId = @TimeFormatId ))
          BEGIN
	      
          SET @IsEligibleToArchive = 'ThisNumberFormatUsedInCompanyDeleteTheDependenciesAndTryAgain'
          
          END

	      IF(@IsEligibleToArchive <> '1')
          BEGIN
       
           RAISERROR (@isEligibleToArchive,11, 1)
       
          END
	    END  


		IF(@TimeFormatDisplayText IS NULL)
        BEGIN
		   
		   RAISERROR(50011,16, 2, 'TimeFormatText')

		END
		ELSE
		BEGIN

		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
		       DECLARE @TimeFormatIdCount INT = (SELECT COUNT(1) FROM TimeFormat 
		                                         WHERE  Id = @TimeFormatId)
		    
		       DECLARE @TimeFormatDisplayTextCount INT = (SELECT COUNT(1) FROM TimeFormat 
		                                                   WHERE @TimeFormatDisplayText = DisplayText AND 
		    											   (@TimeFormatId IS NULL OR Id <> @TimeFormatId))
		    											   
		    
	        IF (@TimeFormatIdCount = 0 AND @TimeFormatId IS NOT NULL)
            BEGIN
		     
		      RAISERROR(50002,16, 1,'TimeFormat')
		    
		    END
		    ELSE IF(@TimeFormatDisplayTextCount > 0)
		    BEGIN
		       
		       RAISERROR(50001,16,1,'TimeFormat')
		    
		    END
		    ELSE
		    BEGIN
		    
		       DECLARE @IsLatest INT = (CASE WHEN @TimeFormatId IS NULL THEN 1 ELSE 
		                                CASE WHEN (SELECT [TimeStamp] FROM TimeFormat 
		    							WHERE Id = @TimeFormatId) = @TimeStamp THEN 1 ELSE 0 END END)
		    						
		    IF (@IsLatest = 1)
		    BEGIN
		       
		       DECLARE @CurrentDateTime DATETIME = GETDATE()
		    
			IF(@TimeFormatId IS NULL)
			   BEGIN

			   SET @TimeFormatId = NEWID()

			   INSERT INTO TimeFormat(Id,
                                      DisplayText,
                                      CreatedDateTime,
                                      CreatedByUserId,
                                      InActiveDateTime
		    						  )
		    				   SELECT @TimeFormatId,
		    						  @TimeFormatDisplayText,
		    						  @CurrentDateTime,
		    						  @OperationsPerformedBy,
		    						  CASE WHEN @IsArchived = 1 THEN @CurrentDateTime ELSE NULL END

					END
					ELSE
					BEGIN

					            UPDATE TimeFormat
					             SET  DisplayText = @TimeFormatDisplayText,
                                      UpdatedDateTime = @CurrentDateTime,
									  InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDateTime ELSE NULL END,
                                      UpdatedByUserId =  @OperationsPerformedBy
                                     WHERE Id  =@TimeFormatId

					END
		    
		    			SELECT Id FROM TimeFormat WHERE Id = @TimeFormatId
		    
            END
		    ELSE
		      
		      RAISERROR(50008,11, 1)
		    END
		
		END
		END TRY
		BEGIN CATCH

		  THROW

        END CATCH
 END				
-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Save or update the date formats
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC USP_UpsertDateFormat @DateFormatText = 'Test',@IsArchived = 0,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertDateFormat]
(
 @DateFormatId UNIQUEIDENTIFIER = NULL,
 @DateFormatText NVARCHAR(100) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
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

	IF(@OperationsPerformedBy ='00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy=NULL
	 IF (@DateFormatId ='00000000-0000-0000-0000-000000000000') SET @DateFormatId=NULL
	 IF (@DateFormatText ='') SET @DateFormatText=NULL
	 IF(@IsArchived = 1 AND @DateFormatId IS NOT NULL)
	 BEGIN
		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
            IF(EXISTS(SELECT Id FROM [Company] WHERE DateFormatId = @DateFormatId))
            BEGIN
            SET @IsEligibleToArchive = 'ThisDateFormatUsedInCompanyDeleteTheDependenciesAndTryAgain'
            END
			IF(@IsEligibleToArchive <> '1')
            BEGIN
             RAISERROR (@isEligibleToArchive,11, 1)
            END
	 END
	 IF(@DateFormatText IS NULL)
	 BEGIN
	      RAISERROR(50011,16,2,'DateFormatText')
	 END
	 ELSE
	 BEGIN
		  DECLARE @DateFormatIdCount INT = (SELECT COUNT(1) FROM [DateFormat] WHERE Id = @DateFormatId)
		  DECLARE @DateFormatTextCount INT = (SELECT COUNT(1) FROM [DateFormat]
		                                      WHERE DisplayText=@DateFormatText AND
											        (Id <> @DateFormatId OR @DateFormatId IS NULL))
		  IF(@DateFormatIdCount = 0 AND @DateFormatId IS NOT NULL)
		  BEGIN
		    RAISERROR(50002,16,1,'DateFormat')
		  END
		  ELSE IF(@DateFormatTextCount > 0)
		  BEGIN
			 RAISERROR(50001,16,1,'DateFormat')
		  END
		  ELSE
		  BEGIN
			  DECLARE @IsLatestBit INT =(CASE WHEN @DateFormatId IS NULL
			                             THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [dbo].[DateFormat]
										 WHERE (Id=@DateFormatId))=@TimeStamp THEN 1 ELSE 0 END END)
		  IF @IsLatestBit=1
		  BEGIN
			DECLARE @CurrentDate DATETIME = GETDATE()
	
		IF(@DateFormatId IS NULL)
		BEGIN

		SET @DateFormatId = NEWID()
		INSERT INTO [dbo].[DateFormat](
			             Id,
			             DisplayText,
			             CreatedDateTime,
			             InActiveDateTime
						 )
			      SELECT @DateFormatID,
			             @DateFormatText,
			     		 @CurrentDate,
			    		 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

		END
		ELSE
		BEGIN

				UPDATE  [dbo].[DateFormat]
					SET  DisplayText		=	 @DateFormatText,
			             UpdatedDateTime	=	 @CurrentDate,
						 UpdatedByUserId = @OperationsPerformedBy,
			             InActiveDateTime	=	 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
					WHERE Id = @DateFormatId

		END
			SELECT Id FROM [dbo].[DateFormat] WHERE Id=@DateFormatID
		   END
		   END
		   END
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

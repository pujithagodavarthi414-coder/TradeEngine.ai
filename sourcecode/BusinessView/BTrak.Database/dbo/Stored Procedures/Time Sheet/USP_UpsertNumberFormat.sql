-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Save or update the number formats
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertNumberFormat] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@NumberFormat ='Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertNumberFormat(
@NumberFormatId UNIQUEIDENTIFIER = NULL,
@NumberFormat NVARCHAR(100) = NULL,
@TimeStamp TIMESTAMP = NULL,
@IsArchived  BIT =NULL,
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

	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	 IF(@NumberFormatId = '00000000-0000-0000-0000-000000000000') SET @NumberFormatId = NULL

	 IF(@NumberFormat = '' ) SET @NumberFormat = NULL

	 IF(@IsArchived = 1 AND @NumberFormatId IS NOT NULL)
	 BEGIN

	      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
          IF(EXISTS(SELECT Id FROM [Company] WHERE NumberFormatId = @NumberFormatId))
          BEGIN
	      
          SET @IsEligibleToArchive = 'ThisNumberFormatUsedInCompanyDeleteTheDependenciesAndTryAgain'
          
          END

	      IF(@IsEligibleToArchive <> '1')
          BEGIN
       
           RAISERROR (@isEligibleToArchive,11, 1)
       
          END
	 END   

	 IF(@NumberFormat IS NULL)
	 BEGIN
	  
	   RAISERROR(50011,16, 2, 'NumberFormat')

	 END
	 ELSE
	 BEGIN
	 
		DECLARE @NumberFormatIdCount INT = (SELECT COUNT(1) FROM NumberFormat 
		                                    WHERE Id = @NumberFormatId)

		DECLARE @NumberFormatCount INT = (SELECT COUNT(1) FROM NumberFormat 
		                                  WHERE DisplayText=@NumberFormat AND (@NumberFormatId IS NULL OR Id <> @NumberFormatId))
    IF EXISTS(SELECT * FROM(SELECT ASCII(String)[ASCII Value] FROM(
               select substring(a.b, v.number+1, 1) String 
               from (select @NumberFormat b) a
               join master..spt_values v on v.number < len(a.b)
               where v.type = 'P')T)Z WHERE (Z.[ASCII Value]  BETWEEN 65  AND 90) OR (Z.[ASCII Value]  BETWEEN 97  AND 121))
	BEGIN

	 RAISERROR('InvalidNumberFormatPleaseAvoidTheAlphabiticalLettersInTheNumberFormat',16, 1)

	END
	IF(@NumberFormatIdCount = 0 AND @NumberFormatId IS NOT NULL)
	BEGIN
	    
		 RAISERROR(50002,16, 1,'NumberFormat')

	END
	ELSE IF(@NumberFormatCount > 0)
	BEGIN
	   
	   RAISERROR(50001,16,1,'NumberFormat')

	END
	ELSE
	BEGIN
	   
	   DECLARE @IsLatest INT = (CASE WHEN @NumberFormatId IS NULL THEN 1 ELSE 
	                            CASE WHEN (SELECT [TimeStamp] FROM NumberFormat 
								WHERE Id = @NumberFormatId) = @TimeStamp THEN 1 ELSE 0 END END )

	IF(@IsLatest = 1)
	BEGIN
	   
	   DECLARE @CurrentDateTime DATETIME = GETDATE()

	   IF(@NumberFormatId IS NULL)
	   BEGIN

	   SET @NumberFormatId = NEWID()
	   INSERT INTO NumberFormat(
	                            Id,
                                DisplayText,
                                CreatedDateTime,
                                InActiveDateTime
								)
						 SELECT @NumberFormatId,
						        @NumberFormat,
								@CurrentDateTime,
								CASE WHEN @IsArchived = 1 THEN @CurrentDateTime ELSE NULL END

		END
		ELSE
		BEGIN

						UPDATE  NumberFormat
							SET	DisplayText			   = 		   @NumberFormat,
                                UpdatedDateTime		   = 		  @CurrentDateTime,
                                UpdatedByUserId		   = 		  @OperationsPerformedBy,
                                InActiveDateTime	   = 		  CASE WHEN @IsArchived = 1 THEN @CurrentDateTime ELSE NULL END
							WHERE Id = @NumberFormatId
		END

				SELECT Id FROM NumberFormat WHERE Id=@NumberFormatId

	END
	ELSE
	   
	   RAISERROR(50008,11, 1)

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
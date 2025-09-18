-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update WebHook
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertWebHook] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@WebHookName = 'Test'								  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertWebHook]
(
   @WebHookId UNIQUEIDENTIFIER = NULL,
   @WebHookName NVARCHAR(50) = NULL,
   @WebHookUrl NVARCHAR(MAX) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		--IF(@IsArchived = 1 AND @WebHookId IS NOT NULL)
		--BEGIN
		--     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	 --        IF(EXISTS(SELECT Id FROM Job WHERE DepartmentId = @WebHookId))
	 --        BEGIN
	 --        SET @IsEligibleToArchive = 'ThisDepartmentUsedInJobPleaseDeleteTheDependenciesAndTryAgain'
	 --        END
		--     IF(@IsEligibleToArchive <> '1')
		--     BEGIN
		--         RAISERROR (@isEligibleToArchive,11, 1)
		--     END
	 --   END
		IF(@WebHookName = '') SET @WebHookName = NULL
	    IF(@WebHookName IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'WebHookName')
		END
		ELSE
		BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @WebHookIdCount INT = (SELECT COUNT(1) FROM WebHook  WHERE Id = @WebHookId)
		DECLARE @WebHookNameCount INT = (SELECT COUNT(1) FROM WebHook WHERE WebHookName = @WebHookName AND CompanyId = @CompanyId AND (@WebHookId IS NULL OR Id <> @WebHookId))
	    IF(@WebHookIdCount = 0 AND @WebHookId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'WebHook')
        END
        ELSE IF(@WebHookNameCount>0)
        BEGIN
          RAISERROR(50001,16,1,'WebHook')
         END
         ELSE
		  BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			         IF (@HavePermission = '1')
			         BEGIN
			         	DECLARE @IsLatest BIT = (CASE WHEN @WebHookId  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [WebHook] WHERE Id = @WebHookId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			            IF(@IsLatest = 1)
			         	BEGIN
			                 DECLARE @Currentdate DATETIME = GETDATE()
             
			 IF( @WebHookId IS NULL)
			 BEGIN

			 SET @WebHookId = NEWID()
			 INSERT INTO [dbo].[WebHook](
                         [Id],
						 [CompanyId],
						 [WebHookName],
						 [WebHookUrl],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]
						 )
                  SELECT @WebHookId,
						 @CompanyId,
						 @WebHookName,
						 @WebHookUrl,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy

			END
			ELSE
			BEGIN

				UPDATE [dbo].[WebHook]
					SET  [CompanyId]			   =  		 @CompanyId,
						 [WebHookName]		       =  		 @WebHookName,
						 [WebHookUrl]              =         @WebHookUrl,
						 [InActiveDateTime]		   =  		 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 [UpdatedDateTime]		   =  		 @Currentdate,
						 [UpdatedByUserId]		   =  		 @OperationsPerformedBy
					WHERE Id = @WebHookId

			END


			             SELECT Id FROM [dbo].[WebHook] WHERE Id = @WebHookId
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
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO
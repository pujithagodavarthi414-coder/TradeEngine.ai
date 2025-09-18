-------------------------------------------------------------------------------
-- Author       Aswani
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Get the PartsOfDays By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPartsOfDay]
(
  @PartsOfDayId UNIQUEIDENTIFIER = NULL,
  @PartsOfDayName NVARCHAR(250) = NULL,
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

		DECLARE @Currentdate DATETIME = GETDATE()
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @PartsOfDayNameCount INT = (SELECT COUNT(1) FROM [PartsOfDay] WHERE [PartsOfDayName] = @PartsOfDayName AND (@PartsOfDayId IS NULL OR Id <> @PartsOfDayId) AND CompanyId = @CompanyId)
		
		
			 IF(@PartsOfDayName IS NULL)
			 BEGIN
			   RAISERROR(50011,16, 2, 'PartsOfDayName')
			 END
			 ELSE IF(@PartsOfDayNameCount > 0)
			 BEGIN
			 RAISERROR(50001,16,1,'PartsOfDay')
			 END
		     ELSE
		     BEGIN

			 IF(@PartsOfDayId IS NULL)
			 BEGIN
			 
			 	    SET @PartsOfDayId = NEWID()
			 
			 		INSERT INTO [dbo].[PartsOfDay](
			 	     		          [Id],
			 	     		          [CompanyId],
			 						  [PartsOfDayName],
			 	     		          [CreatedDateTime],
			 	     		          [CreatedByUserId])
			 	     		   SELECT @PartsOfDayId,
			 	     		          @CompanyId,
			 						  @PartsOfDayName,
			 	     		          @Currentdate,
			 	     		          @OperationsPerformedBy
			 
			 END
			 	SELECT Id FROM [dbo].[PartsOfDay] WHERE Id = @PartsOfDayId
			 END
		END
	    ELSE
		  RAISERROR (@HavePermission,11, 1)
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END

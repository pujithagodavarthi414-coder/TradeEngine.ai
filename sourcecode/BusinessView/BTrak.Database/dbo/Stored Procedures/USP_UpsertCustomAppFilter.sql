-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-11-19 00:00:00.000'
-- Purpose      To Save or update the CustomApp Filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertCustomAppFilter] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@FilterQuery = 'Id IS NOT NULL',@DashboardId = 'B78BBCEE-2586-47EF-A801-DA9F2A8990D8'

CREATE PROCEDURE [dbo].[USP_UpsertCustomAppFilter]
(
   @DashboardId UNIQUEIDENTIFIER,
   @FilterQuery NVARCHAR(800)  = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @CustomAppFilterId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].CustomAppFilter WHERE DashboardId = @DashboardId AND CreatedByUserId = @OperationsPerformedBy)

					IF(@CustomAppFilterId IS NOT NULL)
					BEGIN

						UPDATE [dbo].CustomAppFilter SET FilterQuery = @FilterQuery
						                                 ,UpdatedDateTime = @Currentdate
														 WHERE Id = @CustomAppFilterId

					END
					ELSE
					BEGIN

						INSERT INTO [dbo].CustomAppFilter
						            (
									Id
									,DashboardId
									,CreatedByUserId
									,CreatedDateTime
									,FilterQuery
									)
									SELECT NEWID()
									,@DashboardId
									,@OperationsPerformedBy
									,@Currentdate
									,@FilterQuery
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
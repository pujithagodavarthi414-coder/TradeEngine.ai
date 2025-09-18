-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-02-01 00:00:00.000'
-- Purpose      To Get Trends
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_GetTrends] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
 
CREATE PROCEDURE [dbo].[USP_GetTrends]
(
	@TrendId UNIQUEIDENTIFIER = NULL,
	@UniqueNumber BIGINT = NULL,
	@SearchTrendValue NVARCHAR(800),
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@TrendId = '00000000-0000-0000-0000-000000000000') SET @TrendId = NULL
		
		IF(@SearchTrendValue = '') SET @SearchTrendValue = NULL
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy AND InActiveDateTime IS NULL AND IsActive = 1)

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN
			
			SELECT T.Id AS TrendId
			       ,T.TrendValue
				   ,T.GenericFormSubmittedId
				   ,T.GenericFormKeyId
			       
				 
			FROM Trend T
			    
			WHERE (@TrendId IS NULL OR T.Id = @TrendId)
			       
			       AND (@SearchTrendValue IS NULL OR T.TrendValue LIKE ('%' + @SearchTrendValue + '%'))

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO
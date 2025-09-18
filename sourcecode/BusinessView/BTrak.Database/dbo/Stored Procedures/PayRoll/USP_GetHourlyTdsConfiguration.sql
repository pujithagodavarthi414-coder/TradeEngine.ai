CREATE PROCEDURE [dbo].[USP_GetHourlyTdsConfiguration](
@BranchId UNIQUEIDENTIFIER = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@SearchText [NVARCHAR](800) = NULL,
@SortBy NVARCHAR(250) = NULL,
@SortDirection NVARCHAR(50) = NULL,
@PageNo INT = 1,
@PageSize INT = 10,
@IsArchived BIT = NULL
)
AS
BEGIN
SET NOCOUNT ON
   BEGIN TRY
		
		IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

		IF (@HavePermission = '1')
        BEGIN

				IF(@SortDirection IS NULL )
				BEGIN
					SET @SortDirection = 'DESC'
				END
				
				DECLARE @OrderByColumn NVARCHAR(250) 

				IF(@SortBy IS NULL)
				BEGIN

					SET @SortBy = 'Tax'

				END
				ELSE
				BEGIN

					SET @SortBy = @SortBy

				END
				IF(@SearchText   = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

				SELECT *,TotalCount = COUNT(1) OVER() FROM(
					SELECT HTC.Id, HTC.BranchId, B.BranchName, HTC.MaxLimit, HTC.TaxPercentage, HTC.ActiveFrom, HTC.ActiveTo, HTC.TimeStamp AS [TimeStamp]
							FROM HourlyTdsConfiguration AS HTC
							JOIN Branch AS B ON B.Id = HTC.BranchId 
							WHERE B.InActiveDateTime IS NULL AND B.CompanyId = @CompanyId
								 AND (((@IsArchived = 0 OR @IsArchived IS NULL ) AND HTC.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND HTC.InActiveDateTime IS NOT NULL))
								 AND (@SearchText IS NULL OR (B.BranchName LIKE '%'+ @SearchText +'%') OR (HTC.MaxLimit LIKE '%'+ @SearchText +'%') OR (HTC.TaxPercentage LIKE '%'+ @SearchText +'%'))
					GROUP BY HTC.Id, HTC.BranchId, B.BranchName, HTC.MaxLimit, HTC.TaxPercentage, HTC.ActiveFrom, HTC.ActiveTo, HTC.TimeStamp
					) T
					ORDER BY 
						CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'Tax' THEN TaxPercentage
								 WHEN @SortBy = 'MaxLimit' THEN MaxLimit
								 WHEN @SortBy = 'Branch' THEN BranchName
						END
						END ASC,
						CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'Tax' THEN TaxPercentage
								 WHEN @SortBy = 'MaxLimit' THEN MaxLimit
								 WHEN @SortBy = 'Branch' THEN BranchName
							END
						END DESC

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
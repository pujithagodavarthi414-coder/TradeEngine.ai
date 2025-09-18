CREATE PROCEDURE [dbo].[USP_GetDaysOfWeekConfiguration](
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

				SET @SortBy = 'BranchName'

			END
			ELSE
			BEGIN

				SET @SortBy = @SortBy

			END

			IF(@SearchText   = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

			            SELECT 
			            D.Id, 
			            D.DaysOfWeekId, 
			            W.WeekDayName, 
			            D.PartsOfDayId, 
			            PD.PartsOfDayName, 
			            D.FromTime, 
			            D.ToTime, 
			            D.IsWeekend, 
			            D.BranchId, 
			            B.BranchName, 
			            D.ActiveFrom, 
			            D.ActiveTo, 
			            D.[TimeStamp],
			            D.IsBankHoliday
						FROM DaysOfWeekConfiguration AS D
						JOIN Branch AS B ON B.Id = D.BranchId AND B.InActiveDateTime IS NULL
						JOIN PartsOfDay AS PD ON PD.Id = D.PartsOfDayId
						JOIN WeekDays AS W ON W.Id = D.DaysOfWeekId AND W.InActiveDateTime IS NULL
						WHERE B.CompanyId = @CompanyId
								 AND (((@IsArchived = 0 OR @IsArchived IS NULL ) AND D.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND D.InActiveDateTime IS NOT NULL))
								 AND (@SearchText IS NULL OR (B.BranchName LIKE '%'+ @SearchText +'%') OR (W.WeekDayName LIKE '%'+ @SearchText +'%') OR (PD.PartsOfDayName LIKE '%'+ @SearchText +'%'))

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
CREATE PROCEDURE [dbo].[USP_GetAllowanceTime](
@BranchId UNIQUEIDENTIFIER = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@SearchText [NVARCHAR](800) = NULL,
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
			
			IF(@SearchText   = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

			SELECT A.Id, A.AllowanceRateSheetForId, R.RateSheetForName, A.BranchId, B.BranchName, A.MaxTime, A.MinTime, A.ActiveFrom, A.ActiveTo, A.TimeStamp
					FROM AllowanceTime AS A
					JOIN RateSheetFor AS R ON R.Id = A.AllowanceRateSheetForId AND R.InActiveDateTime IS NULL AND R.CompanyId = @CompanyId
					JOIN Branch AS B ON B.Id = A.BranchId AND B.InActiveDateTime IS NULL AND B.CompanyId = @CompanyId
					WHERE (((@IsArchived = 0 OR @IsArchived IS NULL ) AND A.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND A.InActiveDateTime IS NOT NULL))
					AND (@SearchText IS NULL OR (B.BranchName LIKE '%'+ @SearchText +'%') OR (R.RateSheetForName LIKE '%'+ @SearchText +'%'))

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

CREATE PROCEDURE [dbo].[USP_GetRateTagAllowanceTime](
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

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

		IF (@HavePermission = '1')
        BEGIN
			
			IF(@SearchText   = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

			SELECT A.Id, 
			       A.AllowanceRateTagForId, 
			       CASE WHEN RTF.RateTagForName IS NOT NULL THEN RTF.RateTagForName
				                                             WHEN PD.PartsOfDayName IS NOT NULL THEN PD.PartsOfDayName
				                                             WHEN WD.WeekDayName IS NOT NULL THEN WD.WeekDayName
															 WHEN H.Reason IS NOT NULL THEN H.Reason 
				                                             WHEN SD.Reason IS NOT NULL THEN SD.Reason ELSE '' END AS RateTagForName, 
				   A.BranchId, 
			       B.BranchName, 
			       A.MaxTime, 
			       A.MinTime,
			       A.ActiveFrom,
			       A.ActiveTo,
				   A.IsBankHoliday,
			       A.[TimeStamp],
				   TotalCount = COUNT(1) OVER()
			       FROM RateTagAllowanceTime AS A
				   LEFT JOIN RateTagFor RTF ON A.AllowanceRateTagForId = RTF.Id AND RTF.InActiveDateTime IS NULL AND RTF.CompanyId = @CompanyId
				   LEFT JOIN PartsOfDay PD ON A.AllowanceRateTagForId = PD.Id
				   LEFT JOIN WeekDays WD ON A.AllowanceRateTagForId = WD.Id
				   LEFT JOIN Holiday H ON A.AllowanceRateTagForId = H.Id
				   LEFT JOIN SpecificDay SD ON A.AllowanceRateTagForId = SD.Id
			       JOIN Branch AS B ON B.Id = A.BranchId AND B.InActiveDateTime IS NULL AND B.CompanyId = @CompanyId
			       WHERE (((@IsArchived = 0 OR @IsArchived IS NULL ) AND A.InActiveDateTime IS NULL) 
				          OR (@IsArchived = 1 AND A.InActiveDateTime IS NOT NULL))

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
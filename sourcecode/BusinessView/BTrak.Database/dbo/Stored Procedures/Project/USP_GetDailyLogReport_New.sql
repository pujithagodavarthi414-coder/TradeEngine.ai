-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-11 00:00:00.000'
-- Purpose      To Get the logtime report by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetDailyLogReport_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetDailyLogReport_New]
(
   @SelectedDate DATETIME = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @LineManagerId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SearchText VARCHAR(500) = NULL,
   @SortBy NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @PageNumber INT = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PageSize INT = NULL
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	      
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
            
        IF (@HavePermission = '1')
        BEGIN

		    IF(@SortDirection IS NULL )
			BEGIN

				SET @SortDirection = 'DESC'

			END
			
			DECLARE @OrderByColumn NVARCHAR(250) 

			IF(@SortBy IS NULL)
			BEGIN

				SET @SortBy = 'DeployedDateTime'

			END
			ELSE
			BEGIN

				SET @SortBy = @SortBy

			END
			
			SET @SearchText = '%'+ @SearchText +'%'

			IF(@PageNumber IS NULL) SET @PageNumber = 1

			IF(@PageSize IS NULL) SET @PageSize = 2147483647

			IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

			IF(@LineManagerId = '00000000-0000-0000-0000-000000000000') SET @LineManagerId = NULL

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@SelectedDate IS NULL) SET @SelectedDate = CAST((GETDATE() - 1) AS DATE)

			DECLARE @CompanyId UNIQUEIDENTIFIER =  (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
			DECLARE @CompliantHours NUMERIC(10,3) = (SELECT CAST(REPLACE([Value], 'h', '' ) AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId)
			
			  SELECT UserId,
					 UserName AS EmployeeName,
					 UserProfileImage,
					 [Date],
					 CONVERT(VARCHAR,CONVERT(INT,SpentTime)) + 'h' + IIF(ROUND((SpentTime * 60.0) % 60.0,0) = 0,'', ':' + CONVERT(VARCHAR,CONVERT(INT,ROUND((SpentTime * 60.0) % 60.0,0))) + 'm') AS OfficeSpentTime,
					 --CASE WHEN (CAST(REPLACE([SpentTime], 'h', '') AS NUMERIC(10,3))) < 0 THEN 0 ELSE SpentTime END AS OfficeSpentTime,
					 CONVERT(VARCHAR,CONVERT(INT,LogTime)) + 'h' + IIF(ROUND((LogTime * 60.0) % 60.0,0) = 0,'', ':' + CONVERT(VARCHAR,CONVERT(INT,ROUND((LogTime * 60.0) % 60.0,0))) + 'm') AS LoggedSpentTime,
					 --LogTime AS LoggedSpentTime,
					 [Status]
					 [Status]
			FROM [dbo].[Ufn_GetLogTimeReport_New](@SelectedDate,@BranchId,ISNULL(@LineManagerId,@OperationsPerformedBy),@CompanyId,@EntityId,@CompliantHours)
			WHERE (@SearchText IS NULL 
				            OR UserName LIKE @SearchText
				            OR SpentTime LIKE @SearchText
				            OR LogTime LIKE @SearchText)
			   ORDER BY 
				     CASE WHEN @SortDirection = 'ASC' THEN
				          CASE WHEN @SortBy = 'Employee Name' THEN UserName
				               WHEN @SortBy = 'Office Spent Time' THEN SpentTime
				               WHEN @SortBy = 'Logged Spent Time' THEN LogTime
				          END 
				     END ASC,
				     CASE WHEN @SortDirection = 'DESC' THEN
				           CASE WHEN @SortBy = 'Employee Name' THEN UserName
				               WHEN @SortBy = 'Office Spent Time' THEN SpentTime
				               WHEN @SortBy = 'Logged Spent Time' THEN LogTime
				          END 
	 			     END DESC
					 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
					     
					 FETCH NEXT @PageSize ROWS ONLY

		END
        ELSE
            RAISERROR (@HavePermission,11, 1)

   END TRY  
   BEGIN CATCH

         THROW

   END CATCH
END

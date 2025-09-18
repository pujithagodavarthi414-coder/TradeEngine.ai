---------------------------------------------------------------------------------
---- Author       Gududhuru Raghavendra
---- Created      '2020-03-28 00:00:00.000'
---- Purpose      To Get Activity Tracker History
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetActivityTrackerHistory]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@PageNumber INT = 1,
@PageSize INT = 25,
@Category NVARCHAR(50),
@SelectedCategory NVARCHAR(50) = NULL
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY

		DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
        BEGIN
			
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF(@Category IS NULL) SET @Category = NULL
			ELSE
				BEGIN
				IF(@Category = 'trackAppsUrls')
				SET @SelectedCategory = 'Track apps and urls'
				IF(@Category = 'screenShotFrequency')
				SET @SelectedCategory = 'Screenshot frequency'
				IF(@Category = 'deleteScreenShots')
				SET @SelectedCategory = 'Delete screenshots'
				IF(@Category = 'keyboard')
				SET @SelectedCategory = 'Key board strokes tracking'
				IF(@Category = 'mouseTracking')
				SET @SelectedCategory = 'Mouse clicks tracking'
				IF(@Category = 'idealTime')
				SET @SelectedCategory = 'Idle time'
				IF(@Category = 'offlineTracking')
				SET @SelectedCategory = 'Offline tracking'
				END

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			SELECT *,COUNT(1) OVER() AS TotalCount FROM (
			SELECT 
				ATH.OldValue,
				ATH.NewValue,
				ATH.Category,
				ATH.FieldName,
				ATH.CreatedByUserId,
				ATH.CreatedDateTime,
				U.ProfileImage,
				ATH.TimeStamp,
				U.FirstName + ' ' + ISNULL(U.SurName,'') UserName
				FROM ActivityTrackerHistory ATH 
				JOIN [user] U ON U.Id = ATH.CreatedByUserId
				WHERE ATH.CompanyId = @CompanyId
				AND (@SelectedCategory IS NULL OR ATH.Category = @SelectedCategory)
				) T
				ORDER BY T.CreatedDateTime DESC

                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		        
                FETCH NEXT @PageSize ROWS ONLY
		END

	END TRY

	BEGIN CATCH
		
			THROW

	END CATCH
END
-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2020-04-15 00:00:00.000'
-- Purpose      To Get the Time Usage Drill Down
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeUsageDrillDown] @UserId = 'D1272DDE-5E0F-44D0-ABCA-17E97EC5AC9D',@OperationPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',
--@Date='2021-02-10',@ApplicatonType= 'Neutral'


CREATE PROCEDURE [dbo].[USP_GetTimeUsageDrillDown](
@UserId UNIQUEIDENTIFIER = NULL ,
@OperationPerformedBy UNIQUEIDENTIFIER,
@Date DATE = NULL,
@PageNo INT = 1,
@PageSize INT = 10,
@SortBy NVARCHAR(250) = NULL,
@SortDirection NVARCHAR(50) = NULL,
@ApplicatonType [NVARCHAR](800) = NULL
)
AS
BEGIN
SET NOCOUNT ON
   BEGIN TRY 
		IF (@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationPerformedBy)

        IF (@HavePermission = '1')
        BEGIN
		        
				IF (@Date IS NULL)
				BEGIN
					SET @Date = GETDATE()
				END
				
				IF(@SortDirection IS NULL )
				BEGIN
					SET @SortDirection = 'DESC'
				END

				IF(@SortBy IS NULL)
				BEGIN

					SET @SortBy = 'applicationName'

				END
				ELSE
				BEGIN

					SET @SortBy = @SortBy

				END
					
					SELECT * ,TotalCount = COUNT(1) OVER() 
					FROM (
							SELECT UAS.UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name]
							       ,UAS.AppUrlImage,UAS.ApplicationName,UAS.ApplicationTypeName
								   ,([TimeInMillisecond]/1000.0) SpentValue
							FROM UserActivityAppSummary UAS
							     INNER JOIN [User] U ON U.Id = UAS.UserId
							WHERE (@UserId IS NULL OR U.Id = @UserId) 
								  AND (UAS.CreatedDateTime = @Date)
								  AND UAS.CompanyId = @CompanyId
								  AND UAS.ApplicationTypeName = @ApplicatonType
							GROUP BY  UAS.UserId,U.FirstName,U.SurName,UAS.AppUrlImage,UAS.ApplicationName,UAS.ApplicationTypeName
								   ,[TimeInMillisecond]
                        ) T
					WHERE T.ApplicationTypeName = @ApplicatonType
					ORDER BY
							CASE WHEN @SortDirection = 'ASC' THEN
								CASE WHEN @SortBy = 'applicationName' THEN CAST(ApplicationName AS NVARCHAR)
								     ELSE CAST(SpentValue AS sql_variant)
								END
							END ASC,
							CASE WHEN @SortDirection = 'DESC' THEN
								CASE WHEN @SortBy = 'applicationName' THEN CAST(ApplicationName AS NVARCHAR)
								     ELSE CAST(SpentValue AS sql_variant)
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
GO

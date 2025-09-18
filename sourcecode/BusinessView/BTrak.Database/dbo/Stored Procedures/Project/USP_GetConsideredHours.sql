-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get theConsideredHours By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetConsideredHours] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetConsideredHours]
(
	@ConsideredHoursId  UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER ,
	@IsArchived BIT = NULL,
	@ConsiderHourName  NVARCHAR(500) = NULL
)
AS
BEGIN
  SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = 1)
	BEGIN

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	      IF (@ConsideredHoursId = '00000000-0000-0000-0000-000000000000') SET @ConsideredHoursId = NULL

		  IF (@ConsiderHourName = '')SET @ConsiderHourName = NULL

          SELECT CH.[Id] AS ConsiderHourId,
                 CH.[ConsiderHourName],
                 CH.InActiveDateTime AS [ArchivedDateTime],
                 CH.[CompanyId],
                 CH.[CreatedDatetime],
                 CH.[CreatedByUserId],
				 U.FirstName +' '+ISNULL(U.SurName,'') AS FullName,
				 CH.[TimeStamp],
				 TotalCount = COUNT(1) OVER(),
				 CASE WHEN CH.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
          FROM  [dbo].[ConsiderHours] CH WITH (NOLOCK)
		  INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.Id = CH.CreatedByUserId 
          WHERE (@ConsideredHoursId IS NULL OR CH.Id = @ConsideredHoursId) 
                AND (@ConsiderHourName IS NULL OR CH.ConsiderHourName LIKE '%'+ @ConsiderHourName +'%') 
                AND (@IsArchived IS NULL 
				     OR (@IsArchived = 1 AND CH.InActiveDateTime IS NOT NULL) 
					 OR (@IsArchived = 0 AND CH.InActiveDateTime IS NULL)) 
			    AND CH.CompanyId = @CompanyId 
		  ORDER BY CH.[CreatedDatetime] DESC
		END
		ELSE
		   
		  RAISERROR(@HavePermission,11,1)

     END TRY
     BEGIN CATCH
        
       THROW

    END CATCH
END
GO
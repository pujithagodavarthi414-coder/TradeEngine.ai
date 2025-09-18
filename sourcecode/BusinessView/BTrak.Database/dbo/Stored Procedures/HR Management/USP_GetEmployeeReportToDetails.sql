-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Report TO Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeReportToDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036972'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetEmployeeReportToDetails]
(
   @EmployeeReportToId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			  IF (@SortDirection = NULL) SET @SortDirection = 'ASC'

			  IF (@SortBy = NULL) SET @SortBy = 'ReportToEmployeeName'
	      
			  IF(@SearchText = '') SET @SearchText = NULL

			  SET @SearchText = '%'+  RTRIM(LTRIM(@SearchText)) +'%'

			  SELECT E.Id EmployeeId,
					 E.UserId,
			         U.FirstName,
					 ER.Id EmployeeReportToId, 
					 U.SurName,
					 U.UserName Email,
					 D.DesignationName,
					 RU.FirstName ReportToEmployeeFirstName,
					 RU.SurName ReportToEmployeeSurName,
					 RU.UserName ReportToEmployeeEmail,
					 ER.OtherText Comments,
					 ER.ActiveFrom ReportingFrom,
					 ER.ActiveTo ReportingTo,
					 ER.ReportingMethodId,
					 RM.ReportingMethodType ReportingMethod,
					 ER.ReportToEmployeeId,
					 ER.[TimeStamp],
					 U.FirstName + ' ' + U.SurName UserName,
					 RU.FirstName + ' ' + RU.SurName ReportToEmployeeName,
					  RU.Id ReportToUserId,
					 CASE WHEN ER.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].EmployeeReportTo ER WITH (NOLOCK)
					JOIN Employee E ON E.Id = ER.EmployeeId AND E.InactiveDateTime IS NULL
			        JOIN [User] U ON U.Id = E.UserId  AND U.InactiveDateTime IS NULL
					LEFT JOIN ReportingMethod RM ON RM.Id = ER.ReportingMethodId AND RM.InactiveDateTime IS NULL
					JOIN Employee RE ON RE.Id = ER.ReportToEmployeeId AND RE.InactiveDateTime IS NULL
					LEFT JOIN Job J ON J.EmployeeId = ER.ReportToEmployeeId AND J.InactiveDateTime IS NULL
					LEFT JOIN Designation D ON D.Id = J.DesignationId AND D.InactiveDateTime IS NULL
					JOIN [User] RU ON RU.Id = RE.UserId AND RU.InactiveDateTime IS NULL
			  WHERE  (@EmployeeReportToId IS NULL OR ER.Id = @EmployeeReportToId)
				   AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
				   AND U.CompanyId = @CompanyId
			       AND (@SearchText IS NULL 
						OR (RU.FirstName + ' ' + ISNULL(RU.SurName,'') LIKE @SearchText)
					    OR (ER.OtherText LIKE @SearchText)
						OR (D.DesignationName LIKE @SearchText)
						OR (RM.ReportingMethodType LIKE @SearchText)
						OR (REPLACE(CONVERT(NVARCHAR,ER.ActiveFrom,106),' ','-')) LIKE @SearchText)
			       AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ER.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ER.InActiveDateTime IS NULL))
				ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'ReportToEmployeeName') THEN  RU.FirstName + ' ' + RU.SurName
                              WHEN(@SortBy = 'Comments') THEN ER.OtherText
							  WHEN(@SortBy = 'DesignationName') THEN D.DesignationName
							  WHEN(@SortBy = 'ReportingMethod') THEN RM.ReportingMethodType
							  WHEN(@SortBy = 'ReportingFrom') THEN CAST(ER.ActiveFrom AS SQL_VARIANT)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'ReportToEmployeeName') THEN  RU.FirstName + ' ' + RU.SurName
                              WHEN(@SortBy = 'Comments') THEN ER.OtherText
							  WHEN(@SortBy = 'DesignationName') THEN D.DesignationName
							  WHEN(@SortBy = 'ReportingMethod') THEN RM.ReportingMethodType
							  WHEN(@SortBy = 'ReportingFrom') THEN CAST(ER.ActiveFrom AS SQL_VARIANT)
                          END
                      END DESC

			  OFFSET ((@PageNo - 1) * @PageSize) ROWS

			  FETCH NEXT @PageSize ROWS ONLY
		END
		ELSE
		   
		   RAISERROR(@HavePermission,11,1)

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
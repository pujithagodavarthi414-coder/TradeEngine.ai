	-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Contract Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmploymentContractDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmploymentContractDetails]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @EmploymentContractId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @IsArchived BIT = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(50) = NULL
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

		    IF (@SortBy = NULL) SET @SortBy = 'ContractTypeName'
	        
	        IF (@SearchText = '') SET @SearchText = NULL
		    
		    SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

	      SELECT E.Id EmployeeId,
		         U.FirstName,
				 C.Id EmploymentContractId,
				 U.SurName,
				 U.UserName Email,
				 C.StartDate,
				 C.EndDate,
				 C.ContractDetails,
				 C.ContractTypeId,
				 CT.ContractTypeName,
				 C.ContractedHours,
				 C.HourlyRate,
				 C.CurrencyId,
				 CU.CurrencyName,
				 C.HolidayOrThisYear,
				 C.HolidayOrFullEntitlement,
				 C.[TimeStamp],
				 U.FirstName + ' ' + U.SurName UserName,
				 CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 TotalCount = COUNT(1) OVER()

		  FROM  [dbo].[Contract] C WITH (NOLOCK)
				JOIN Employee E ON E.Id = C.EmployeeId  AND E.InactiveDateTime IS NULL
		        JOIN [User] U ON U.Id = E.UserId  AND U.InactiveDateTime IS NULL
				JOIN ContractType CT ON CT.Id = C.ContractTypeId  AND CT.InactiveDateTime IS NULL
				LEFT JOIN Currency CU ON CU.Id = C.CurrencyId  AND CU.InactiveDateTime IS NULL
		  WHERE  (@EmploymentContractId IS NULL OR C.Id = @EmploymentContractId)
		       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			   AND U.CompanyId = @CompanyId
		       AND (@SearchText IS NULL 
			        OR (CT.ContractTypeName LIKE @SearchText)
				    OR (C.ContractedHours LIKE @SearchText)
					OR (REPLACE(CONVERT(NVARCHAR,C.StartDate,106),' ','-') LIKE @SearchText)
					OR (REPLACE(CONVERT(NVARCHAR,C.EndDate,106),' ','-') LIKE @SearchText))
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
		  ORDER BY 
		     CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'ContractTypeName')		 THEN CT.ContractTypeName
							  WHEN(@SortBy = 'ContractedHours')			 THEN C.ContractedHours
                              WHEN(@SortBy = 'StartDate')				 THEN CAST(CONVERT(DATETIME,C.StartDate,121) AS sql_variant)
                              WHEN(@SortBy = 'EndDate')					 THEN CAST(CONVERT(DATETIME,C.EndDate,121) AS sql_variant)
                              WHEN(@SortBy = 'HolidayOrThisYear')        THEN C.HolidayOrThisYear
                              WHEN(@SortBy = 'HolidayOrFullEntitlement') THEN C.HolidayOrFullEntitlement
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'ContractTypeName')		 THEN CT.ContractTypeName
							  WHEN(@SortBy = 'ContractedHours')			 THEN C.ContractedHours
                              WHEN(@SortBy = 'StartDate')				 THEN CAST(CONVERT(DATETIME,C.StartDate,121) AS sql_variant)
                              WHEN(@SortBy = 'EndDate')					 THEN CAST(CONVERT(DATETIME,C.EndDate,121) AS sql_variant)
                              WHEN(@SortBy = 'HolidayOrThisYear')        THEN C.HolidayOrThisYear
                              WHEN(@SortBy = 'HolidayOrFullEntitlement') THEN C.HolidayOrFullEntitlement
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
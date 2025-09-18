-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Get Employee Contact Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeContactDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'


CREATE PROCEDURE [dbo].[USP_GetEmployeeContactDetails]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection VARCHAR(50)=NULL,
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

		   IF(@SearchText = '') SET @SearchText = NULL

			  SET @SearchText = '%'+ @SearchText+'%'

		   SELECT    ECD.Id EmployeeContactDetailId,
		             E.Id EmployeeId,
					 E.UserId,
			         U.FirstName,
					 U.SurName,
					 U.UserName Email,
					 ECD.Address1,
					 ECD.Address2,
					 ECD.PostalCode,
					 ECD.StateId,
					 S.StateName,
					 ECD.CountryId,
					 C.CountryName,
					 C.CountryCode,
					 ECD.HomeTelephoneno HomeTelephone,
			         ECD.Mobile,
					 ECD.WorkTelephoneno WorkTelephone,
		             ECD.WorkEmail,
					 ECD.OtherEmail,
					 ECD.ContactPersonName,
					 ECD.Relationship,
					 ECD.DateOfBirth,
					 ECD.[TimeStamp],
					 U.FirstName + ' ' + U.SurName UserName,
					 CASE WHEN ECD.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].EmployeeContactDetails AS ECD WITH (NOLOCK)
					JOIN Employee E ON E.Id = ECD.EmployeeId AND E.InActiveDateTime IS NULL
			        JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
					LEFT JOIN [State] S ON S.Id = ECD.StateId AND  S.InActiveDateTime IS NULL
					JOIN [Country] C ON C.Id = ECD.CountryId  AND C.InActiveDateTime IS NULL
			  WHERE (@EmployeeId IS NULL OR E.Id = @EmployeeId)
					AND U.CompanyId = @CompanyId
			       AND (@SearchText IS NULL 
				        OR (E.NickName LIKE @SearchText)
					    OR (U.FirstName LIKE @SearchText)
						OR (U.SurName LIKE @SearchText))
			  ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'UserName') THEN  U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'StateName') THEN S.StateName
							  WHEN(@SortBy = 'CountryName') THEN C.CountryName
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                        CASE WHEN(@SortBy = 'UserName') THEN  U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'StateName') THEN S.StateName
							  WHEN(@SortBy = 'CountryName') THEN C.CountryName
                          END
                      END DESC

			  OFFSET ((@PageNo - 1) * @PageSize) ROWS

		     FETCH NEXT @PageSize ROWS ONLY

		END
	      
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END

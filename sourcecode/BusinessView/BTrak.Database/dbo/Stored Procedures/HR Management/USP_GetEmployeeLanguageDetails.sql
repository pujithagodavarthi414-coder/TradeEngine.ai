-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Language Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeLanguageDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE  PROCEDURE [dbo].[USP_GetEmployeeLanguageDetails]
(
   @EmployeeLanguageId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @IsArchived BIT = NULL
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

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF (@SortDirection = NULL) SET @SortDirection = 'ASC'

		   IF (@SortBy = NULL) SET @SortBy = 'Language'
	      
		   IF(@SearchText = '') SET @SearchText = NULL

		   SET @SearchText = '%'+  RTRIM(LTRIM(@SearchText)) +'%'

		   SELECT E.Id EmployeeId,
					 EL.Id EmployeeLanguageId,
					 E.UserId,
			         U.FirstName,
					 U.SurName,
					 U.UserName Email,
					 EL.Comments,
					 EL.LanguageId,
					 EL.CompetencyId,
					 EL.[CanRead],
					 EL.[CanSpeak],
					 EL.[CanWrite],
					 L.LanguageName [Language],
					 C.CompetencyName Competency,
					 EL.[TimeStamp],
					 U.FirstName + ' ' + U.SurName UserName,
					 CASE WHEN EL.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].EmployeeLanguage EL WITH (NOLOCK)
					JOIN Employee E ON E.Id = EL.EmployeeId  AND E.InactiveDateTime IS NULL
			        JOIN [User] U ON U.Id = E.UserId  AND U.InactiveDateTime IS NULL
					LEFT JOIN [Language] L ON L.Id = EL.LanguageId  AND L.InactiveDateTime IS NULL 
					LEFT JOIN Competency C ON C.Id = EL.CompetencyId AND C.InactiveDateTime IS NULL 
			  WHERE (@EmployeeLanguageId IS NULL OR EL.Id = @EmployeeLanguageId)
			       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
				   AND U.CompanyId = @CompanyId
			       AND (@SearchText IS NULL 
				        OR (L.LanguageName LIKE @SearchText)
						OR (C.CompetencyName LIKE @SearchText)
						OR (EL.Comments LIKE @SearchText)
						OR (IIF(EL.CanRead = 1,'Yes','No') LIKE @SearchText)
						OR (IIF(EL.CanSpeak = 1,'Yes','No') LIKE @SearchText)
						OR (IIF(EL.CanWrite = 1,'Yes','No') LIKE @SearchText)
						)
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EL.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EL.InActiveDateTime IS NULL))
			  ORDER BY 
			    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
						CASE WHEN(@SortBy = 'UserName')   THEN U.FirstName + ' ' + U.SurName
                             WHEN(@SortBy = 'Language')   THEN L.LanguageName
                              WHEN(@SortBy = 'Competency') THEN C.CompetencyName
                              WHEN(@SortBy = 'CanRead')   THEN EL.CanRead
                              WHEN(@SortBy = 'CanSpeak')   THEN EL.CanSpeak
                              WHEN(@SortBy = 'CanWrite')   THEN EL.CanWrite
                              WHEN(@SortBy = 'Comments')   THEN EL.Comments
                          END
                      END ASC,
                      CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
                           CASE WHEN(@SortBy = 'UserName')   THEN U.FirstName + ' ' + U.SurName
                             WHEN(@SortBy = 'Language')   THEN L.LanguageName
                              WHEN(@SortBy = 'Competency') THEN C.CompetencyName
                              WHEN(@SortBy = 'CanRead')   THEN EL.CanRead
                              WHEN(@SortBy = 'CanSpeak')   THEN EL.CanSpeak
                              WHEN(@SortBy = 'CanWrite')   THEN EL.CanWrite
                              WHEN(@SortBy = 'Comments')   THEN EL.Comments
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

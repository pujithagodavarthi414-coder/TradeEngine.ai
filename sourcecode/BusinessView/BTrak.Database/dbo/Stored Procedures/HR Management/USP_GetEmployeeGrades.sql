-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-05-20 00:00:00.000'
-- Purpose      To Get Employee Grades
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetEmployeeGrades] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeGrades]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeGradeId UNIQUEIDENTIFIER = NULL,	
	@EmployeeId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
	,@PageNo INT = 1
    ,@SortDirection NVARCHAR(250) = NULL
    ,@SortBy NVARCHAR(250) = NULL
    ,@PageSize INT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

            IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

            IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

            IF(@SearchText = '') SET @SearchText = NULL

            IF(@SortBy IS NULL) SET @SortBy = 'EmployeeName'

            SET @SearchText = '%' + @SearchText + '%'

		   IF(@EmployeeGradeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeGradeId = NULL		  
		   
		   IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT EG.Id AS EmployeeGradeId
		   	      ,EG.EmployeeId
				  ,EG.GradeId
				  ,G.GradeName
				  ,G.GradeOrder
				  ,E.UserId
				  ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
				  ,U.ProfileImage
                  ,EG.ActiveFrom
                  ,EG.ActiveTo
				  ,EG.CreatedByUserId
				  ,EG.CreatedDateTime
                  ,EG.[TimeStamp]
                  ,COUNT(1) OVER() AS TotalRecordsCount
           FROM EmployeeGrade AS EG
		        INNER JOIN Grade G ON G.Id = EG.GradeId
                           AND EG.InActiveDateTime IS NULL
				INNER JOIN Employee E ON E.Id = EG.EmployeeId
				           AND E.InActiveDateTime IS NULL
                INNER JOIN [User] U ON U.Id = E.UserId
				           AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
           WHERE U.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (G.GradeName LIKE @SearchText)
			        OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
			        OR (EG.ActiveFrom LIKE @SearchText)
			        OR (EG.ActiveTo LIKE @SearchText)
			   )
		   	   AND (@EmployeeGradeId IS NULL OR EG.Id = @EmployeeGradeId)
		   	   AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			   AND (@IsArchived IS NULL 
			        OR (@IsArchived = 1 AND EG.ActiveTo IS NOT NULL AND EG.ActiveTo < GETDATE()) 
					OR (@IsArchived = 0 AND (EG.ActiveTo IS NULL OR EG.ActiveTo >= CONVERT(DATE,GETDATE()))))
           ORDER BY       
                    CASE WHEN (@SortDirection = 'ASC') THEN
                               CASE WHEN(@SortBy = 'GradeName') THEN G.GradeName
                                    WHEN(@SortBy = 'EmployeeName') THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
                                    WHEN(@SortBy = 'GradeOrder') THEN CAST(G.GradeOrder AS SQL_VARIANT)
                                    WHEN(@SortBy = 'ActiveFrom') THEN CAST(EG.ActiveFrom AS SQL_VARIANT)
                                    WHEN(@SortBy = 'ActiveTo') THEN CAST(EG.ActiveTo AS SQL_VARIANT)
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE WHEN(@SortBy = 'GradeName') THEN G.GradeName
                                    WHEN(@SortBy = 'EmployeeName') THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
                                    WHEN(@SortBy = 'GradeOrder') THEN CAST(G.GradeOrder AS SQL_VARIANT)
                                    WHEN(@SortBy = 'ActiveFrom') THEN CAST(EG.ActiveFrom AS SQL_VARIANT)
                                    WHEN(@SortBy = 'ActiveTo') THEN CAST(EG.ActiveTo AS SQL_VARIANT)
                                END
                            END DESC
                OFFSET ((@PageNo - 1) * @PageSize) ROWS
                FETCH NEXT @PageSize ROWS ONLY

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
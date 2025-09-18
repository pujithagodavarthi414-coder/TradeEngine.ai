CREATE PROCEDURE [dbo].[USP_SearchAuditHistory]
(
  @AssetId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @PageNumber INT = NULL,
  @PageSize INT = NULL,
  @SortBy NVARCHAR(100) = 'CreatedDateTime',
  @SortDirection NVARCHAR(100) = 'DESC'
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	   DECLARE @HavePermission NVARCHAR(500)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            IF (@AssetId = '00000000-0000-0000-0000-000000000000') SET @AssetId = NULL
            
			IF(@PageNumber IS NULL) SET @PageNumber = 1
            
            SELECT Z.CreatedByUserId,
                   Z.FirstName,
                   Z.SurName,
                   Z.FullName,
                   Z.ProfileImage,
                   Z.CreatedDateTime,
                   Z.[Description]
			  FROM ((SELECT A.CreatedByUserId,
                     U.FirstName,
                     U.SurName,
                     U.FirstName+' ' + ISNULL(U.SurName,'') AS FullName,
                     U.ProfileImage,
                     A.CreatedDateTime,
                     ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[0].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[1].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[2].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[3].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[4].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[5].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[6].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[7].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[8].Description'),'')
                     +ISNULL(JSON_VALUE ( AuditJson , '$.AssetsFieldsChangedList[9].Description'),'') AS [Description]
              FROM [Audit] A
                   INNER JOIN [User] U ON A.CreatedByUserId = U.Id
                WHERE U.CompanyId = @CompanyId 
                      AND (@AssetId IS NULL OR @AssetId = JSON_VALUE ( A.AuditJson , '$.AssetId')) 
                      )
              UNION ALL
              (SELECT C.CommentedByUserId,
                    U.FirstName AS CommentedUserFirstName,
                    U.SurName AS CommentedUserSurName,
                    U.FirstName+' '+ISNULL(U.SurName,'') AS CommentedUserFullName,
                    U.ProfileImage AS CommentedUserProfileImage,
                    C.CreatedDateTime AS CommentCreatedDateTime,
                    C.Comment
                    FROM Comment C
                         INNER JOIN [User] U ON U.Id = C.CommentedByUserId
                         WHERE C.CompanyId = @CompanyId
                               AND C.ReceiverId = @AssetId)
                    ) Z
                     ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
                               CASE WHEN @SortBy = 'FirstName' THEN  Z.FirstName
                                    WHEN @SortBy = 'SurName' THEN Z.SurName
                                    WHEN @SortBy = 'FullName' THEN Z.FullName
                                    WHEN @SortBy = 'CreatedDateTime' THEN Z.CreatedDateTime
                                    WHEN @SortBy = 'Description' THEN Z.[Description]
                                    END 
                               END ASC,
                               CASE WHEN @SortDirection = 'DESC' THEN
                                    CASE WHEN @SortBy = 'FirstName' THEN  Z.FirstName
                                    WHEN @SortBy = 'SurName' THEN Z.SurName
                                    WHEN @SortBy = 'FullName' THEN Z.FullName
                                    WHEN @SortBy = 'CreatedDateTime' THEN Z.CreatedDateTime
                                    WHEN @SortBy = 'Description' THEN Z.[Description]
                                    END 
                                END DESC
                      --OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                      --FETCH NEXT @PageSize ROWS ONLY
       END
       END TRY  
       BEGIN CATCH 
            SELECT ERROR_NUMBER() AS ErrorNumber,
               ERROR_SEVERITY() AS ErrorSeverity,
               ERROR_STATE() AS ErrorState,
               ERROR_PROCEDURE() AS ErrorProcedure,
               ERROR_LINE() AS ErrorLine,
               ERROR_MESSAGE() AS ErrorMessage
      END CATCH
END
GO
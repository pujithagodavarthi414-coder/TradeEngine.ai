-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-08 00:00:00.000'
-- Purpose      To Get the EachAudit Deatils By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetEachAudit_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId='EFF76881-EC2F-4ECE-B7D4-CEE139C48C17'

CREATE PROCEDURE [dbo].[USP_GetEachAudit_New]
(
   @UserId UNIQUEIDENTIFIER = NULL,
   @FeatureId UNIQUEIDENTIFIER = NULL,
   @UserStoryId UNIQUEIDENTIFIER = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @PageNumber INT = 1,
   @PageSize INT = 10,
   @SearchText VARCHAR(500) = NULL,
   @SortBy NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL
)
AS
BEGIN
   SET NOCOUNT ON 
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @CompanyId UNIQUEIDENTIFIER =  NULL
         
         IF(@UserId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @UserId = NULL
         END
         
         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @OperationsPerformedBy = NULL
         END
         
         IF(@FeatureId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @FeatureId = NULL
         END
         
         IF (@OperationsPerformedBy IS NOT NULL)
         BEGIN
         SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         END
         IF(@SortDirection IS NULL)
         BEGIN
         
              SET @SortDirection = 'ASC'
         
         END
         
         IF(@SortBy IS NULL)
         BEGIN
         
               SET @SortBy = 'UserName'
         
         END
         ELSE
         BEGIN
         
               SET @SortBy = @SortBy
         
         END
         IF(@PageSize IS NULL OR @PageSize = '')
         BEGIN
              SET @PageSize = (SELECT COUNT(1) FROM [Audit])
         END
         SET @SearchText = '%'+ @SearchText +'%'
         SELECT CONVERT(UNIQUEIDENTIFIER,JSON_VALUE(AuditJSON,'$.UserId')) AS UserId,
                CONVERT(UNIQUEIDENTIFIER,JSON_VALUE(AuditJSON,'$.FeatureId')) AS FeatureId,
                CONVERT(UNIQUEIDENTIFIER,JSON_VALUE(AuditJSON,'$.UserStoryId')) AS UserStoryId,
                JSON_VALUE(AuditJSON,'$.Description') AS [Description],
                JSON_VALUE(AuditJSON,'$.FieldName') AS [FieldName],
                CA.AuditJSON,
                CA.CreatedDateTime AS ViewedDate, 
                U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName,
                F.FeatureName AS FeatureName,
                U.ProfileImage
         FROM Audit CA
             LEFT JOIN [User] U ON U.Id = JSON_VALUE(AuditJSON,'$.UserId') 
             LEFT JOIN Feature F ON F.Id = JSON_VALUE(AuditJSON,'$.FeatureId')
             LEFT JOIN UserStory US ON US.Id = JSON_VALUE(AuditJSON,'$.UserStoryId')
         WHERE((@DateFrom IS NULL OR @DateTo IS NULL)
                OR (CONVERT(DATE,CA.CreatedDateTime) >= CONVERT(DATE,@DateFrom) AND CONVERT(DATE,CA.CreatedDateTime) <= CONVERT(DATE,@DateTo))
              )
              AND (@UserId IS NULL OR U.Id = @UserId) 
              AND (@FeatureId IS NULL OR F.Id = @FeatureId)
              AND (@UserStoryId IS NULL OR US.Id = @UserStoryId)
              AND IsOldAudit IS NULL 
              AND (U.CompanyId = @CompanyId)
              AND (@SearchText IS NULL 
                    OR FirstName + ' ' + ISNULL(SurName,'') LIKE @SearchText
                    OR FeatureName LIKE @SearchText
                    OR CA.CreatedDateTime LIKE @SearchText)
         ORDER BY 
           CASE WHEN @SortDirection = 'ASC' THEN
                CASE WHEN @SortBy = 'UserName' THEN FirstName + ' ' + ISNULL(SurName,'')
                     WHEN @SortBy = 'ViewedDate' THEN Cast(CA.CreatedDateTime as sql_variant) 
                     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
                END 
           END ASC,
           CASE WHEN @SortDirection = 'DESC' THEN
                CASE WHEN @SortBy = 'UserName' THEN FirstName + ' ' + ISNULL(SurName,'')
                     WHEN @SortBy = 'ViewedDate' THEN Cast(CA.CreatedDateTime as sql_variant) 
                     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
                END 
           END DESC
         OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
               
         FETCH NEXT @PageSize ROWS ONLY
    END TRY 
    BEGIN CATCH 
        
          THROW

    END CATCH
END

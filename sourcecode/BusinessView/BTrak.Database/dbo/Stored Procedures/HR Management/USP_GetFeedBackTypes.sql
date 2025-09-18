-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-25 00:00:00.000'
-- Purpose      To Get the Feed Back Types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetFeedBackTypes] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_GetFeedBackTypes]
(
  @FeedbackTypeId UNIQUEIDENTIFIER = NULL,
  @FeedBackTypename NVARCHAR(250) = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @IsArchived  BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
         
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         IF(@HavePermission = '1')
         BEGIN
          
          IF (@FeedbackTypeId = '00000000-0000-0000-0000-000000000000') SET @FeedbackTypeId = NULL
          
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          IF(@FeedBackTypename = '' ) SET @FeedBackTypename = NULL
          
          IF(@SearchText = '' ) SET @SearchText = NULL
          
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
             
                    SELECT FT.[Id] AS FeedbackTypeId,
                           FT.[CompanyId],
                           FT.[CreatedDateTime],
                           FT.[CreatedByUserId],
                           FT.[FeedbackTypeName],
                           FT.[TimeStamp],
                           (CASE WHEN FT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
                           TotalCount = COUNT(1) OVER()
                     FROM FeedBackType As FT
                     WHERE  FT.CompanyId = @CompanyId 
                          AND (@FeedBackTypeId IS NULL OR FT.Id = @FeedBackTypeId) 
                          AND (@FeedBackTypeName IS NULL OR FT.[FeedBackTypeName] = @FeedBackTypename) 
                          AND (@SearchText IS NULL OR FT.[FeedBackTypeName] LIKE '% ' + @Searchtext + '%') 
                          AND (@IsArchived IS NULL OR (@IsArchived = 1 AND FT.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND FT.InactiveDateTime IS  NULL))
                  ORDER BY FT.[FeedbackTypeName] ASC
          
          END
         ELSE
          
            RAISERROR(@HavePermission,11,1)
        END TRY
        BEGIN CATCH
         
         THROW
        END CATCH
END
GO

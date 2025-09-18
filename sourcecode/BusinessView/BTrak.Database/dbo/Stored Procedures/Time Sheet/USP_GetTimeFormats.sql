-----------------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get time formats
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeFormats] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTimeFormats]
(
  @TimeFormatId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
               IF(@TimeFormatId = '00000000-0000-0000-0000-000000000000') SET @TimeFormatId = NULL
               IF(@SearchText = '') SET  @SearchText = NULL
             
               SET @SearchText = '%'+ @SearchText +'%'
               SELECT [Id] AS TimeFormatId,
                         [DisplayText] AS TimeFormatName,
						 [Pattern] TimeFormatPattern,
                         TF.[CreatedDateTime],
                         TF.[CreatedByUserId],
                         TF.[TimeStamp],
                         IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
                         TotalCount = COUNT(1) OVER()
               FROM  [dbo].[TimeFormat] TF WITH (NOLOCK)
               WHERE (@TimeFormatId IS NULL OR TF.Id = @TimeFormatId) 
                     AND (@SearchText IS NULL 
                          OR (DisplayText LIKE @SearchText))
                     AND (@IsArchived IS NULL 
                          OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL)
                          OR (@IsArchived = 0 AND InActiveDateTime IS NULL))
               ORDER BY DisplayText ASC
          
     END TRY  
     BEGIN CATCH 
        
          THROW
    END CATCH
END
GO
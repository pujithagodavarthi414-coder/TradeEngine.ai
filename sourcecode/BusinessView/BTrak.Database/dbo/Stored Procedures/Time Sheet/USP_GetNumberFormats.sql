-----------------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get number formats
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetNumberFormats] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetNumberFormats]
(
  @NumberFormatId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
           
		       IF(@NumberFormatId = '00000000-0000-0000-0000-000000000000') SET @NumberFormatId = NULL

               IF(@SearchText = '') SET  @SearchText = NULL
             
               SET @SearchText = '%'+ @SearchText +'%'

               SELECT [Id] AS NumberFormatId,
                      [DisplayText] AS NumberFormat,
					  NF.[TimeStamp],
					  NF.CreatedDateTime,
					  CASE WHEN NF.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			  TotalCount = COUNT(1) OVER()

               FROM  [dbo].[NumberFormat] NF WITH (NOLOCK)
               WHERE (@NumberFormatId IS NULL OR NF.Id = @NumberFormatId) 
                     AND (@SearchText IS NULL OR (DisplayText LIKE @SearchText))
					 AND (@IsArchived IS NULL 
					      OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
						  OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))

               ORDER BY DisplayText ASC
          
     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH

END
GO
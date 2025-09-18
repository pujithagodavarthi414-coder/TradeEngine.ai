-----------------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get date formats
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetDateFormats] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetDateFormats]
(
  @DateFormatId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
           
		   		IF(@DateFormatId = '00000000-0000-0000-0000-000000000000') SET @DateFormatId = NULL

				IF(@SearchText = '') SET  @SearchText = NULL
				
				SET @SearchText= REPLACE(@SearchText,'_','$_')
				SET @SearchText = '%'+ @SearchText +'%'

				    SELECT DF.[Id] AS DateFormatId,
				           DF.[DisplayText] AS DateFormatName,
						   [Pattern] DateFormatPattern,
						   IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
						   DF.InActiveDateTime,
						   DF.[CreatedDateTime],
						   DF.[TimeStamp],
						   TotalCount = COUNT(1) OVER()

				   FROM  [dbo].[DateFormat] DF WITH (NOLOCK)
				   WHERE (@DateFormatId IS NULL OR DF.Id = @DateFormatId) 
				         AND (@SearchText IS NULL OR (DisplayText LIKE @SearchText ESCAPE '$')) 
						 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
					      OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL)) 
				   ORDER BY DisplayText ASC
                     
     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH

END
GO
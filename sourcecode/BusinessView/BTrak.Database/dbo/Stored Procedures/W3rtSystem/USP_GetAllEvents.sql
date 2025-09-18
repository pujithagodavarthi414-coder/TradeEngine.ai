-------------------------------------------------------------------------------
-- Author       kandapu sushmitha 
-- Created      '2020-10-04 00:00:00.000'
-- Purpose      To Get All rooms By Applying venue Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetAllEvents]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetAllEvents]
(
 @EventId               UNIQUEIDENTIFIER = NULL, 
 @EventName             NVARCHAR(250)    = NULL, 
 @OperationsPerformedBy UNIQUEIDENTIFIER, 
 @SearchText            NVARCHAR(250)    = NULL, 
 @IsActive              BIT              = NULL
)
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
          
		  DECLARE @HavePermission NVARCHAR(250)= (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

            IF(@HavePermission = '1')
                BEGIN
                    DECLARE @CompanyId UNIQUEIDENTIFIER=
                    (
                        SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                    )

                    IF(@EventId = '00000000-0000-0000-0000-000000000000')
                       
					    SET @EventId = NULL;

                    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')

                        SET @OperationsPerformedBy = NULL;

                    IF(@SearchText = '')

                        SET @SearchText = NULL

                    SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

                    SELECT ET.Id AS EventId, 
                           ET.EventTypeName AS EventName, 
                           ET.Description, 
                           ET.[Timestamp],
                           CASE WHEN ET.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived, 
                           TotalCount = COUNT(1) OVER()
                    FROM [dbo].[EventType] ET WITH(NOLOCK)
                    WHERE(@EventId IS NULL OR ET.Id = @EventId)
                         AND (@SearchText IS NULL)
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

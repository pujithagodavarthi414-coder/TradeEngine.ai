-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-09-27 00:00:00.000'
-- Purpose      To Get the testrail configurations By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetTestRailConfigurations] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0

CREATE PROCEDURE [dbo].[USP_GetTestRailConfigurations]
(
    @TestRailConfigurationId UNIQUEIDENTIFIER = NULL,
    @ConfigurationName NVARCHAR(250) = NULL,
    @ConfigurationTime FLOAT = NULL,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
            BEGIN

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
            IF (@TestRailConfigurationId = '00000000-0000-0000-0000-000000000000') SET @TestRailConfigurationId = NULL
             
            IF (@ConfigurationName = '') SET @ConfigurationName = NULL
           
            IF(@IsArchived IS NULL)SET @IsArchived = 0
               
                SELECT TRC.Id AS TestRailConfigurationId,
                       TRC.ConfigurationName,
					   TRC.ConfigurationShortName,
                       TRC.ConfigurationTime,
                       CASE WHEN TRC.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
                       TRC.CompanyId,
                       TRC1.CreatedDatetime,
                       TRC.CreatedByUserId,
                       TRC.[TimeStamp],
                       TotalCount = COUNT(1) OVER()
                FROM  [dbo].[TestRailConfiguration] TRC WITH (NOLOCK) 
                    INNER JOIN [TestRailConfiguration] TRC1 ON TRC.Id = TRC1.Id 
                WHERE TRC.CompanyId = @CompanyId 
                      AND (@TestRailConfigurationId IS NULL OR TRC.Id = @TestRailConfigurationId) 
                      AND (@ConfigurationName IS NULL OR TRC.ConfigurationName = @TestRailConfigurationId) 
                      AND (@ConfigurationTime IS NULL OR TRC.ConfigurationTime = @ConfigurationTime )
                      AND ((@IsArchived = 1 AND TRC.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TRC.InActiveDateTime IS NULL)) 
                ORDER BY TRC1.CreatedDateTime   
        END
        ELSE
        RAISERROR (@HavePermission,11, 1)    
     END TRY  
     BEGIN CATCH 
        
        THROW

    END CATCH
END
GO
-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Ensure User Can Have Access or Not
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--SELECT [dbo].[Ufn_EnsureUserCanHaveAccess]('127133F1-4427-4149-9DD6-B02E0E036971','FC361D23-F317-4704-B86F-0D6E7287EEE9')

CREATE FUNCTION [dbo].[Ufn_EnsureUserCanHaveAccess]
(
   @UserId UNIQUEIDENTIFIER,
   @FeatureId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(500)
AS
BEGIN	   
       DECLARE @Result NVARCHAR(500)

	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

	   IF(@FeatureId = '00000000-0000-0000-0000-000000000000') SET @FeatureId = NULL

	   DECLARE @FeatureName NVARCHAR(250) = (SELECT FeatureName FROM [Feature] WHERE Id = @FeatureId)

       DECLARE @Value BIT = 0

       DECLARE @Count INT = (SELECT COUNT(1) FROM CompanyModule CM INNER JOIN FeatureModule FM ON FM.ModuleId = CM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
	   WHERE FM.FeatureId = @FeatureId AND CM.CompanyId = @CompanyId)
		
		IF(@CompanyId IS NULL)
            SET @Result = 'ThisUserAccountIsNotExist'

		IF(@FeatureId IS NULL)
			SET @Result = 'ThisFeatureIsNotExist'

		ELSE IF(@Count = 0)
			SET @Result = 'ThisFeatureNotBelongToYourCompanyFeatures'

		ELSE 
		BEGIN

            DECLARE @Features TABLE
            (
                ParentFeatureId UNIQUEIDENTIFIER,
                FeatureId UNIQUEIDENTIFIER,
                [Level] INT,
                IsValid INT
            )
            ;WITH Descendants AS
            (SELECT ParentFeatureId, Id  AS Descendant, 1 AS [Level]
             FROM Feature WHERE InActiveDateTime IS NULL
             UNION ALL
             SELECT D.ParentFeatureId, F.Id Child, d.[Level] + 1
             FROM Descendants AS D
                  INNER JOIN Feature F on D.Descendant = F.ParentFeatureId AND F.InActiveDateTime IS NULL
            ) 
        
            INSERT INTO @Features(ParentFeatureId,FeatureId,[Level])
            SELECT ParentFeatureId,Descendant,[Level]
            FROM Descendants
            WHERE Descendant = @FeatureId
        
            DECLARE @Counter INT = (SELECT COUNT(1) FROM @Features)
            DECLARE @MaxLevel INT = (SELECT MAX([Level]) FROM @Features)
        
            WHILE(@Counter > 0)
            BEGIN
                
                SELECT @FeatureId = FeatureId FROM @Features WHERE [Level] = @Counter
        
                IF((SELECT COUNT(Id) FROM RoleFeature WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId] (@UserId)) AND FeatureId = @FeatureId) > 0)
                    UPDATE @Features SET IsValid = 1 WHERE [Level] = @Counter
        
                SET @Counter = @Counter - 1
            END
        
            IF((SELECT SUM(IsValid) FROM @Features) = @MaxLevel)
                SET @Result = '1'
            ELSE
                SET @Result =  'YouDoNotHavePermissionsToThisFeature'

	  END
	  RETURN @Result
END
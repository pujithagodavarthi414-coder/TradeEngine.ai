-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Save or Update the Roles
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from Feature 
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertRoleFeature] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@RoleName='Head',
 --@FeatureGuids= N'<GenericListOfGuid xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 --                 <ListItems>
 --              <guid>A6CD2213-5D0F-4656-9961-00AA07CE13F8</guid>
 --              <guid>E81E64E5-4438-4DF4-AAE0-146DCA7D6703</guid>
    --           <guid>F226D22E-DCE4-4ADD-BA23-1033EED6DA7C</guid>
 --              </ListItems>
 --              </GenericListOfGuid>' 
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertRoleFeature]
(
  @RoleId UNIQUEIDENTIFIER = NULL,
  @RoleName NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL,
  @FeatureGuids XML = NULL,
  @IsArchived BIT = NULL,
  @IsDeveloper BIT = NULL,
  @IsNewRole BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) ='1' -- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN

      IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

      IF (@RoleName = '') SET @RoleName = NULL

      
      IF(@RoleName IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'RoleName')

      END
      ELSE 
      BEGIN --'Super Admin'
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
          SET @FeatureGuids = CAST(@FeatureGuids AS XML)

          DECLARE @SuperAdminRoleId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId)

          DECLARE @RoleIdCount INT = (SELECT COUNT(1) FROM [Role] WHERE Id = @RoleId AND CompanyId = @CompanyId)

          DECLARE @RoleNameCount INT = (SELECT COUNT(1) FROM [Role] WHERE RoleName = @RoleName AND CompanyId = @CompanyId AND (@RoleId IS NULL OR Id <> @RoleId) AND InactiveDateTime IS NULL)

          --IF(@RoleIdCount = 0 AND @RoleId IS NOT NULL)
          --BEGIN

          --  RAISERROR(50002,16, 1,'Role')

          --END
          
          --ELSE 
          IF(@RoleNameCount > 0)
          BEGIN
          
            RAISERROR(50001,16,1,'Role')
          
          END
          
          ELSE
          BEGIN
          DECLARE @IsLatest BIT = (CASE WHEN @IsNewRole = 1 THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [Role] WHERE Id = @RoleId) = @TimeStamp THEN 1 ELSE 0 END END)
          
          IF (@IsLatest = 1)
          BEGIN
             
          DECLARE @CurrentDate DATETIME = GETDATE()

            
                IF(@RoleId IS NULL OR (@RoleIdCount = 0 AND @RoleId IS NOT NULL))
				BEGIN

                IF(@IsNewRole = 1)
				SET @RoleId = @RoleId

				INSERT INTO [dbo].[Role](
                            [Id],
                            [RoleName],                 
                            [CompanyId],
							[IsDeveloper],
                            [CreatedDateTime],
                            [CreatedByUserId],
                            [InActiveDateTime]
                            )
                     SELECT @RoleId,
                            @RoleName,
                            @CompanyId,
							@IsDeveloper,
                            @Currentdate,
                            @OperationsPerformedBy,
                            CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
                        
				END
				ELSE
				BEGIN
                    
                    IF(@SuperAdminRoleId = @RoleId AND (@RoleName <> 'Super Admin' OR @IsArchived = 1))
                    BEGIN

                        RAISERROR('DefaultRoleCanNotBeAltered',11,1);

                    END
                    ELSE
                    BEGIN

				        UPDATE  [dbo].[Role]
				         SET    [RoleName] = @RoleName, 
					            [IsDeveloper] = @IsDeveloper,
                                [CompanyId]  = @CompanyId,
                                [UpdatedDateTime] = @CurrentDate,
                                [UpdatedByUserId] = @OperationsPerformedBy,
                                [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					    	WHERE Id = @RoleId
                    
                    END

				END
                            
                UPDATE RoleFeature SET InActiveDateTime = @CurrentDate WHERE RoleId = (SELECT Id FROM [Role] WHERE Id = @RoleId) AND FeatureId NOT IN ('2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D','5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3')
                      
                INSERT INTO [dbo].[RoleFeature](
                            Id,
                            RoleId,
                            FeatureId,
                            CreatedDateTime,
                            CreatedByUserId,
                            [InActiveDateTime]
                            )
                      SELECT NEWID(),
                            @RoleId,
                            Id,
                            @Currentdate,
                            @OperationsPerformedBy,
                            CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
                       FROM Feature  WHERE Id IN (SELECT  x.y.value('(text())[1]', 'varchar(100)') FROM  @FeatureGuids.nodes('/GenericListOfGuid/*/guid') AS x(y))
                       
                SELECT Id FROM [dbo].[Role] WHERE Id = @RoleId
            
           END
           ELSE
             
               RAISERROR(50008,11,1)
          END
       END
	END
    END TRY  
    BEGIN CATCH 
        
         THROW
    END CATCH
END
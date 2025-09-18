CREATE PROCEDURE [dbo].[USP_UpsertRoleFeature]
(
  @RoleId UNIQUEIDENTIFIER = NULL,
  @RoleName NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL,
  @FeatureGuids XML = NULL,
  @IsArchived BIT = NULL,
  @IsDeveloper BIT = NULL,
  @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250) ='1'

        IF (@HavePermission = '1')
        BEGIN
            
            IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

            IF (@RoleName = '') SET @RoleName = NULL
      
            IF(@RoleName IS NULL)
            BEGIN
               RAISERROR(50011,16, 2, 'RoleName')
            END
            ELSE
            BEGIN
                
                SET @FeatureGuids = CAST(@FeatureGuids AS XML)

                DECLARE @SuperAdminRoleId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId)

                DECLARE @RoleIdCount INT = (SELECT COUNT(1) FROM [Role] WHERE Id = @RoleId AND CompanyId = @CompanyId)

                DECLARE @RoleNameCount INT = (SELECT COUNT(1) FROM [Role] WHERE RoleName = @RoleName AND CompanyId = @CompanyId AND (@RoleId IS NULL OR Id <> @RoleId) AND InactiveDateTime IS NULL)

                IF(@RoleIdCount = 0 AND @RoleId IS NOT NULL)
                BEGIN
                    RAISERROR(50002,16, 1,'Role')
                END
          
                ELSE IF(@RoleNameCount > 0)
                BEGIN
                    RAISERROR(50001,16,1,'Role')
                END

                ELSE
                BEGIN
                    
                    DECLARE @IsLatest BIT = '1'
                    IF (@IsLatest = 1)
                    BEGIN
                        
                        DECLARE @CurrentDate DATETIME = GETDATE()

                        IF(@RoleId IS NULL)
				        BEGIN

				            SET @RoleId = NEWID()

				            INSERT INTO [dbo].[Role](
                                    [Id],
                                    [RoleName],                 
                                    [CompanyId],
							        [IsDeveloper],
                                    [CreatedDateTime],
                                    [CreatedByUserId],
                                    [InactiveDateTime]
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

                END

            END
        END

        ELSE
            RAISERROR(50008,11,1)

    END TRY
    BEGIN CATCH 
        
         THROW
    END CATCH
END
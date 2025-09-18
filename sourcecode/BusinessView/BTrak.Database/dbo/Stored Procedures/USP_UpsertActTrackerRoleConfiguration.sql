--EXEC [dbo].[USP_UpsertActTrackerRoleConfiguration] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@AppUrlId='8119B40C-834C-4721-80E0-0C8257C3E977',
--@RoleIdXMl='<?xml version="1.0" encoding="utf-8"?>
--<GenericListOfNullableOfGuid
-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
--  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <ListItems><guid>606e7152-047c-43ba-8426-03a743bbaef4</guid>
--          <guid>381d7c81-1274-4c77-970b-142a82bf6e2b</guid>
--          <guid>90d51fd0-f599-4b89-ad20-31a74f1a93ea</guid>
--          <guid>4d5adf0f-88df-462c-a987-38ac05aeab0c</guid>
--          <guid>511bbedd-5c23-49fd-af05-2e82061426df</guid></ListItems></GenericListOfNullableOfGuid>'
CREATE PROCEDURE [dbo].[USP_UpsertActTrackerRoleConfiguration](
@RoleIdXMl XMl = NULL,
@AppUrlId UNIQUEIDENTIFIER,
@ConsiderPunchCard BIT,
@FrequencyIndex INT = NULL,
@IsSelectAll BIT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@Remove BIT = NULL,
@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
     SET NOCOUNT ON
       BEGIN TRY
            
            IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
            IF(@AppUrlId = '00000000-0000-0000-0000-000000000000') SET @AppUrlId = NULL
            IF(@AppUrlId IS NULL)
            BEGIN
                RAISERROR(50011,11,2,'AppUrlId')
            END
            ELSE
            BEGIN
                 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
             
                 IF (@HavePermission = '1')
                 BEGIN              
                 
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					DECLARE @Currentdate DATETIME = GETDATE()
					DECLARE @OldAppUrlId UNIQUEIDENTIFIER = NULL
					DECLARE @OldConsiderPunchCard BIT = NULL
					DECLARE @OldAppUrlValue NVARCHAR(500) = NULL
					DECLARE @NewAppUrlValue NVARCHAR(500) = NULL

					SELECT @OldAppUrlId = ActivityTrackerAppUrlTypeId,
						   @OldConsiderPunchCard = ConsiderPunchCard
						   FROM ActivityTrackerRoleConfiguration WHERE ComapnyId = @CompanyId

					IF(@Remove IS NULL OR @Remove = 0)
					BEGIN	
					
						CREATE TABLE #RoleIds ( Id UNIQUEIDENTIFIER,
											RoleId UNIQUEIDENTIFIER,
											IsExist BIT
												)
                
						INSERT INTO #RoleIds(Id,RoleId)
						SELECT NEWID(),
								x.y.value('(text())[1]','UNIQUEIDENTIFIER')                          
								FROM  
								@RoleIdXMl.nodes('/GenericListOfNullableOfGuid
														   /ListItems/guid')AS x(y)

						--UPDATE #RoleIds  SET VersionNumber = A.VersionNumber,OriginalId=A.OriginalId FROM [ActTrackerRoleConfiguration] A JOIN #RoleIds RI ON RI.RoleId=A.RoleId AND 
																					--                                                          @AppUrlId <> A.AppUrlId AND A.AsAtInActiveDateTime IS NULL
						UPDATE ActivityTrackerRoleConfiguration SET ActivityTrackerAppUrlTypeId = @AppUrlId ,
						ConsiderPunchCard = @ConsiderPunchCard,FrequencyIndex = @FrequencyIndex, SelectAll = @IsSelectAll WHERE RoleId IN (SELECT RoleId FROM #RoleIds) AND ComapnyId = @CompanyId
                    
						UPDATE #RoleIds SET IsExist = 1 FROM [ActivityTrackerRoleConfiguration] A JOIN #RoleIds RI ON RI.RoleId=A.RoleId AND @AppUrlId = A.ActivityTrackerAppUrlTypeId AND @FrequencyIndex = A.FrequencyIndex AND A.InActiveDateTime IS NULL
						UPDATE ActivityTrackerRoleConfiguration SET FrequencyIndex = @FrequencyIndex, SelectAll = 0 WHERE ComapnyId = @CompanyId AND @FrequencyIndex = -1
                    
						--UPDATE ActivityTrackerRoleConfiguration SET InActiveDateTime = @Currentdate WHERE Id IN (SELECT Id from #RoleIds Where Id IS NOT NULL) AND InActiveDateTime IS NULL
						INSERT INTO [dbo].[ActivityTrackerRoleConfiguration](
																		Id,
																		ActivityTrackerAppUrlTypeId,
																		ConsiderPunchCard,
																		RoleId,
																		FrequencyIndex,
																		SelectAll,
																		ComapnyId,
																		CreatedDateTime,
																		CreatedByUserId)
																SELECT Id,                                                                     
																		@AppUrlId,
																		@ConsiderPunchCard,
																		RoleId,
																		@FrequencyIndex,
																		@IsSelectAll,
																		@CompanyId,
																		@Currentdate,
																		@OperationsPerformedBy
																		FROM #RoleIds WHERE  IsExist IS NULL            
						 SELECT RoleId FROM #RoleIds              
                         
					END
					ELSE
					BEGIN
						
						DECLARE @Index INT= IIF((SELECT COUNT(*) FROM ActivityTrackerRoleConfiguration WHERE FrequencyIndex = -1 AND ComapnyId = @CompanyId) > 0, -1 , @FrequencyIndex)

						DECLARE @TrackId UNIQUEIDENTIFIER = (SELECT TOP(1) ActivityTrackerAppUrlTypeId FROM ActivityTrackerRoleConfiguration WHERE FrequencyIndex = @Index AND ComapnyId = @CompanyId)

						UPDATE ActivityTrackerRoleConfiguration SET FrequencyIndex = -1, ActivityTrackerAppUrlTypeId = @TrackId, SelectAll = 0  WHERE FrequencyIndex = @FrequencyIndex AND ComapnyId = @CompanyId 

						UPDATE ActivityTrackerRoleConfiguration SET FrequencyIndex = FrequencyIndex - 1 WHERE FrequencyIndex > @FrequencyIndex AND ComapnyId = @CompanyId

					END
				    
					IF(@OldAppUrlId <> @AppUrlId)
					BEGIN
						IF(@AppUrlId = 'd823d2eb-d592-4957-867c-a204c633eac7')
							SET @NewAppUrlValue = 'off'
						IF(@AppUrlId = '8119b40c-834c-4721-80e0-0c8257c3e977')
							SET @NewAppUrlValue = 'Apps'
						IF(@AppUrlId = 'd1376714-5db6-4d14-8e11-b5aac2c7c662')
							SET @NewAppUrlValue = 'Apps and urls'
						IF(@AppUrlId = '83824c7a-eec0-4f64-a1ee-d9967aa59536')
							SET @NewAppUrlValue = 'Apps and urls(detailed)'
						IF(@AppUrlId = '468e34ec-53d6-444a-9434-7bc185c4cb6d')
							SET @NewAppUrlValue = 'Urls'
						IF(@OldAppUrlId = 'd823d2eb-d592-4957-867c-a204c633eac7')
							SET @OldAppUrlValue = 'off'
						IF(@OldAppUrlId = '8119b40c-834c-4721-80e0-0c8257c3e977')
							SET @OldAppUrlValue = 'Apps'
						IF(@OldAppUrlId = 'd1376714-5db6-4d14-8e11-b5aac2c7c662')
							SET @OldAppUrlValue = 'Apps and urls'
						IF(@OldAppUrlId = '83824c7a-eec0-4f64-a1ee-d9967aa59536')
							SET @OldAppUrlValue = 'Apps and urls(detailed)'
						IF(@OldAppUrlId = '468e34ec-53d6-444a-9434-7bc185c4cb6d')
									SET @OldAppUrlValue = 'Urls'

						EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Track apps and urls',
						@FieldName = 'AppUrl',@OldValue = @OldAppUrlValue,@NewValue = @NewAppUrlValue, @CompanyId = @CompanyId
						END

						SELECT @OldAppUrlValue = NULL,@NewAppUrlValue = NULL

						SET @OldAppUrlValue = IIF(@OldConsiderPunchCard = 0,'Disabled','Enabled')
						SET @NewAppUrlValue = IIF(@ConsiderPunchCard = 0,'Disabled','Enabled')
				    
						IF(@OldAppUrlValue <> @NewAppUrlValue)
						EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Track apps and urls',
						@FieldName = 'ConsiderPunchCard',@OldValue = @OldAppUrlValue,@NewValue = @NewAppUrlValue, @CompanyId = @CompanyId

				   END
                   ELSE
                   BEGIN
                   
                        RAISERROR (@HavePermission,11, 1)
                   END
				   
                END
              END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO
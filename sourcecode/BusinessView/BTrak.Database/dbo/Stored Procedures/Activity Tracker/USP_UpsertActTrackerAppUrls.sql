--EXEC [dbo].[USP_UpsertActTrackerAppUrls] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',
--@AppUrlName='sql',@IsApp=1,
--@ProductiveRoleIdsXMl='<?xml version="1.0" encoding="utf-8"?>
--<GenericListOfNullableOfGuid
-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
--  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <ListItems><guid>606e7152-047c-43ba-8426-03a743bbaef4</guid>
--          <guid>AF1C7A94-48A5-4B07-B161-DFCDCB2166F1</guid>
--          <guid>511bbedd-5c23-49fd-af05-2e82061426df</guid></ListItems></GenericListOfNullableOfGuid>'
--@UnProductiveRoleIdsXMl='<?xml version="1.0" encoding="utf-8"?>
--<GenericListOfNullableOfGuid
-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
--  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <ListItems><guid>606e7152-047c-43ba-8426-03a743bbaef4</guid>
--          <guid>AF1C7A94-48A5-4B07-B161-DFCDCB2166F1</guid>
--          <guid>511bbedd-5c23-49fd-af05-2e82061426df</guid></ListItems></GenericListOfNullableOfGuid>'
-------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertActTrackerAppUrls]( 
@AppUrlNameId UNIQUEIDENTIFIER = NULL, 
@ProductiveRoleIdsXMl XMl, 
@UnProductiveRoleIdsXMl XMl, 
@AppUrlImage NVARCHAR(250) = NULL, 
@AppUrlName NVARCHAR(250), 
@IsArchived BIT=NULL, 
@OperationsPerformedBy UNIQUEIDENTIFIER, 
@IsApp BIT = NULL, 
@ApplicationCategoryId UNIQUEIDENTIFIER = NULL,
@TimeStamp TIMESTAMP = NULL
) 
AS 
BEGIN 
     SET NOCOUNT ON 
       BEGIN TRY 
            
            IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL 
            
			IF(@ApplicationCategoryId = '00000000-0000-0000-0000-000000000000') SET @ApplicationCategoryId = NULL 
            
            ELSE 
            BEGIN 
               DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 
             
              
                 IF (@HavePermission = '1') 
                 BEGIN       
					
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

					IF(@AppUrlName IS NULL) 
					BEGIN 
						RAISERROR(50011,11,2,'appurlName') 
					END 
					DECLARE @AppUrlNamesCount INT = (SELECT COUNT(1) FROM ActivityTrackerApplicationUrl WHERE AppUrlName = @AppUrlName AND (Id <> @AppUrlNameId OR @AppUrlNameId IS NULL) AND CompanyId = @CompanyId AND InActiveDateTime IS NULL) 
					IF(@AppUrlNamesCount > 0) 
					BEGIN 
							RAISERROR(50001,11,2,'AppurlName') 
					END        
       
                         DECLARE @Currentdate DATETIME = GETDATE() 
					SET @AppUrlName = LTRIM(RTRIM(@AppUrlName))
                        -- DECLARE @AppUrlNameVersionNumber INT=(SELECT VersionNumber FROM AppUrlNames WHERE Id = @AppUrlNameId And InActiveDateTime IS NULL) 
					
					CREATE TABLE #RoleIds ( Id UNIQUEIDENTIFIER, 
                                        RoleId UNIQUEIDENTIFIER,
										IsProductive BIT DEFAULT 0,
                                        IsExist BIT 
                                            ) 
                
					INSERT INTO #RoleIds(Id,IsProductive,RoleId) 
                    SELECT NEWID(),1,
                            x.y.value('(text())[1]','UNIQUEIDENTIFIER')                           
                            FROM  @ProductiveRoleIdsXMl.nodes('/GenericListOfNullableOfGuid
                                                       /ListItems/guid')AS x(y) 
					
					INSERT INTO #RoleIds(Id,IsProductive,RoleId) 
                    SELECT NEWID(),0,
                            x.y.value('(text())[1]','UNIQUEIDENTIFIER')                           
                            FROM  @UnProductiveRoleIdsXMl.nodes('/GenericListOfNullableOfGuid
                                                       /ListItems/guid')AS x(y) 
					                     
						IF(@AppUrlNameId IS NULL)
						BEGIN
							SET @AppUrlNameId = NEWID()
							INSERT INTO [dbo].[ActivityTrackerApplicationUrl]( 
															Id, 
															AppUrlName, 
															ActivityTrackerAppUrlTypeId, 
															AppUrlImage, 
															CompanyId,
															CreatedByUserId,
															ApplicationCategoryId,
															CreatedDateTime, 
															InActiveDateTime
															) 
													SELECT  @AppUrlNameId, 
															@AppUrlName, 
															CASE WHEN @IsApp = 1 THEN (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App') ELSE (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'URL') END, 
															@AppUrlImage, 
															@CompanyId,
															@OperationsPerformedBy,
															@ApplicationCategoryId,
															@Currentdate, 
															CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						--UPDATE ActTrackerAppUrls SET InActiveDateTime = @Currentdate WHERE RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND AppUrlNameId = @AppUrlNameId AND InActiveDateTime IS NULL
        
							  INSERT INTO [dbo].[ActivityTrackerApplicationUrlRole]( 
																	Id, 
																	ActivityTrackerApplicationUrlId,                                                         
																	RoleId, 
																	IsProductive, 
																	CompanyId, 
																	[CreatedByDateTime], 
																	CreatedByUserId) 
																	SELECT Id,                                                                    
																			@AppUrlNameId, 
																			RoleId, 
																			IsProductive,
																			@CompanyId, 
																			@Currentdate, 
																			@OperationsPerformedBy 
																	FROM #RoleIds        
											
											SELECT RoleId FROM #RoleIds   
						END
						ELSE
						BEGIN

						 --UPDATE #RoleIds  SET VersionNumber = A.VersionNumber,OriginalId=A.Id FROM [ActTrackerAppUrls] A JOIN #RoleIds RI ON RI.RoleId=A.RoleId AND  
						--                                                                                                        @AppUrlNameId = A.AppUrlNameId AND A.InActiveDateTime IS NULL 
							UPDATE #RoleIds SET IsExist = 1 
							FROM [ActivityTrackerApplicationUrlRole] A 
							      JOIN #RoleIds RI ON RI.RoleId = A.RoleId 
								       AND @AppUrlNameId = A.ActivityTrackerApplicationUrlId 
									   AND A.InActiveDateTime IS NULL 

							UPDATE ActivityTrackerApplicationUrlRole 
							SET InActiveDateTime = @Currentdate ,[UpdatedByUserId] = @OperationsPerformedBy
												,[UpdatedDateTime] = @Currentdate 
							WHERE RoleId NOT IN (SELECT RoleId FROM #RoleIds) 
												AND ActivityTrackerApplicationUrlId = @AppUrlNameId AND CompanyId = @CompanyId 
												AND InActiveDateTime IS NULL

							UPDATE [dbo].[ActivityTrackerApplicationUrl]
										SET [AppUrlName] = @AppUrlName
											,[AppUrlImage] = @AppUrlImage
											,[ActivityTrackerAppUrlTypeId] = CASE WHEN @IsApp = 1 THEN (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App') ELSE (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'URL') END
											,[CompanyId] = @CompanyId
											,[UpdatedByUserId] = @OperationsPerformedBy
											,[UpdatedDateTime] = @Currentdate
											,ApplicationCategoryId = @ApplicationCategoryId
											,[InActiveDateTime] = NULL
										WHERE Id = @AppUrlNameId AND CompanyId = @CompanyId

							IF(@IsArchived IS NULL)
							BEGIN
								INSERT INTO [dbo].[ActivityTrackerApplicationUrlRole]( 
																	Id, 
																	ActivityTrackerApplicationUrlId,                                                         
																	RoleId,
																	IsProductive,
																	CompanyId, 
																	[CreatedByDateTime], 
																	CreatedByUserId) 
													SELECT Id,                                                                    
															@AppUrlNameId, 
															RoleId, 
															IsProductive,
															@CompanyId, 
															@Currentdate, 
															@OperationsPerformedBy 
															FROM #RoleIds WHERE IsExist IS NULL
								
								UPDATE ActivityTrackerApplicationUrlRole 
							SET IsProductive = RI.IsProductive ,[UpdatedByUserId] = @OperationsPerformedBy
												,[UpdatedDateTime] = @Currentdate 
							FROM [ActivityTrackerApplicationUrlRole] A 
							      JOIN #RoleIds RI ON RI.RoleId = A.RoleId 
								       AND @AppUrlNameId = A.ActivityTrackerApplicationUrlId 
									   AND A.InActiveDateTime IS NULL 
									   AND RI.IsExist = 1

							END
							ELSE
							BEGIN

								UPDATE [dbo].[ActivityTrackerApplicationUrl]
										SET [AppUrlName] = @AppUrlName
											,[AppUrlImage] = @AppUrlImage
											,[ActivityTrackerAppUrlTypeId] = CASE WHEN @IsApp = 1 THEN (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App') ELSE (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'URL') END
											,[CompanyId] = @CompanyId
											,[UpdatedByUserId] = @OperationsPerformedBy
											,ApplicationCategoryId = @ApplicationCategoryId
											,[UpdatedDateTime] = @Currentdate
											,[InActiveDateTime] = @Currentdate
										WHERE Id = @AppUrlNameId AND CompanyId = @CompanyId

								UPDATE [dbo].[ActivityTrackerApplicationUrlRole]
									    SET [InActiveDateTime] = @CurrentDate
										WHERE ActivityTrackerApplicationUrlId = @AppUrlNameId AND CompanyId = @CompanyId
							
							END
						END

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
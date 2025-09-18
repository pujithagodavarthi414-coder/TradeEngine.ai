-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-07 00:00:00.000'
-- Purpose      To Save or update the Projects
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------  
--EXEC [dbo].[USP_UpsertProject] @ProjectResponsiblePersonId ='127133F1-4427-4149-9DD6-B02E0E036971', @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectName='Etrakk'

CREATE PROCEDURE [dbo].[USP_UpsertProject]
(
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @ProjectName NVARCHAR(250) = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @ProjectResponsiblePersonId UNIQUEIDENTIFIER,
  @ProjectStartDate DATETIMEOFFSET = NULL,
  @ProjectEndDate DATETIMEOFFSET = NULL,
  @IsArchived BIT = NULL,
  @ProjectStatusColor NVARCHAR(20) = NULL,
  @ProjectTypeId UNIQUEIDENTIFIER = NULL,
  @IsDateTimeConfiguration BIT = NULL,
  @IsSprintsConfiguration BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                    
        IF (@HavePermission = '1')
        BEGIN
            
			DECLARE @IsLatest BIT = (CASE WHEN @ProjectId IS NULL THEN 1 ELSE 
                                 CASE WHEN (SELECT [TimeStamp] FROM Project WHERE Id = @ProjectId) = @TimeStamp THEN 1 ELSE 0 END END)
             
			 IF(@IsLatest = 1)
             BEGIN
			          DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
					   SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                       DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)    
                       
                       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                       
                       DECLARE @UniqueNumber INT

					   DECLARE @IsDateTimeConfigurationOld BIT = ISNULL((SELECT IsDateTimeConfiguration FROM Project WHERE Id = @ProjectId),0)
                       
                       SELECT @UniqueNumber = MAX(CAST(SUBSTRING(ProjectUniqueName,CHARINDEX('-',ProjectUniqueName) + 1 ,LEN(ProjectUniqueName)) AS INT)) FROM Project WHERE CompanyId = @CompanyId
                       
                       DECLARE @ProjectIdCount INT = (SELECT COUNT(1) FROM Project WHERE Id = @ProjectId AND CompanyId = @CompanyId)
                       
                       DECLARE @ProjectNameCount INT = (SELECT COUNT(1) FROM Project WHERE ProjectName = @ProjectName AND CompanyId = @CompanyId AND (Id <> @ProjectId OR @ProjectId IS NULL) AND InActiveDateTime IS NULL)

					   DECLARE @OldProjectName NVARCHAR(50) = (SELECT ProjectName FROM Project WHERE Id = @ProjectId and InActiveDateTime IS NULL)
                      
					   DECLARE @BoardTypeId UNIQUEIDENTIFIER = (SELECT Id FROM BoardType WHERE BoardTypeName = 'SuperAgile' AND InActiveDateTime IS NULL AND IsDefault = 1 AND CompanyId = @CompanyId)
                       
					   IF(@ProjectIdCount = 0 AND @ProjectId IS NOT NULL)
                       BEGIN
                        
                         RAISERROR(50002,16, 1,'Project')

                       END
                       ELSE IF(@BoardTypeId IS NULL)
                       BEGIN
                        
                         RAISERROR('AtLeastOneBoardWithTheNameSuperAgileAndIsdefault',11, 1)

                       END
                       ELSE IF(@ProjectName = 'Adhoc Project')
					   BEGIN
							
							RAISERROR('CreatingAdhocProjectIsNotPermitted',11,1)

					   END
                       ELSE IF(@ProjectNameCount > 0)
                       BEGIN
                       
                            RAISERROR(50001,16,1,'Project')
                       
                       END
                       ELSE
                       BEGIN
                       
							IF(@ProjectId IS NULL)
							BEGIN

							SET @ProjectId = NEWID()

                                INSERT INTO [dbo].[Project](
                                            [Id],
                                            [ProjectName],
                                            [ProjectResponsiblePersonId],
                                            [ProjectStatusColor],
                                            [CompanyId],
                                            [ProjectTypeId],
                                            [CreatedDateTime],
											[CreatedDateTimeZone],
                                            [CreatedByUserId],
                                            ProjectUniqueName,
                                            [IsDateTimeConfiguration],
											[IsSprintsConfiguration],
											[InactiveDateTime],
											[ProjectStartDate],
											[ProjectStartDateTimeZoneId],
											[ProjectEndDateTimeZoneId],
											[ProjectEndDate]
                                            )
                                    SELECT @ProjectId,
                                           @ProjectName,
                                           @ProjectResponsiblePersonId,
                                           @ProjectStatusColor,
                                           @CompanyId,
                                           @ProjectTypeId,
                                           @Currentdate,
										   @TimeZoneId,
                                           @OperationsPerformedBy,
                                           'P - ' + CAST(@UniqueNumber + 1 AS NVARCHAR(100)),
                                           ISNULL(@IsDateTimeConfiguration,0),
										   ISNULL(@IsSprintsConfiguration,0),
										   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
										   @ProjectStartDate,
										   CASE WHEN @ProjectStartDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
										   CASE WHEN @ProjectEndDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
										   @ProjectEndDate

                                           INSERT INTO Workspace(Id,WorkspaceName,IsHidden,CreatedDateTime,CreatedByUserId,CompanyId,IsCustomizedFor)
                                           SELECT @ProjectId, N'Customized_AuditAnalytics',0, GETDATE(), @OperationsPerformedBy, @CompanyId, 'AuditAnalytics'
                          
						  EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = '', @NewValue = @ProjectName, @FieldName = 'ProjectAdded',
		                                                @Description = 'ProjectAdded', @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId

						  EXEC [dbo].[USP_UpsertGoal]@GoalName = 'Backlog',@GoalShortName = 'Backlog',
						                              @ProjectId = @ProjectId,@BoardTypeId = @BoardTypeId,
													  @OperationsPerformedBy = @OperationsPerformedBy,@TimeZone = @TimeZone

													   

								END
								ELSE
								BEGIN

									EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
                                                                         @ProjectName = @ProjectName,
                                                                         @ProjectResponsiblePersonId = @ProjectResponsiblePersonId,
																		 @ProjectTypeId = @ProjectTypeId,
																		 @IsDateTimeConfiguration = @IsDateTimeConfiguration,
                                                                         @IsSprintsConfiguration = @IsSprintsConfiguration,
																		 @IsArchived = @IsArchived,
                                                                         @OperationsPerformedBy = @OperationsPerformedBy,
																		 @ProjectStartDate = @ProjectStartDate,
																		 @ProjectEndDate = @ProjectEndDate,
																		 @TimeZoneId = @TimeZoneId


								     UPDATE [dbo].[Project]
                                      SET   [ProjectName] = @ProjectName,
                                            [ProjectResponsiblePersonId] = @ProjectResponsiblePersonId,
                                            [ProjectStatusColor] = @ProjectStatusColor,
                                            [CompanyId] = @CompanyId,
                                            [ProjectTypeId] = @ProjectTypeId,
                                            [UpdatedDateTime] = @Currentdate,
                                            [UpdatedByUserId] = @OperationsPerformedBy,
											[UpdatedDateTimeZone] = @TimeZoneId,
                                            [IsDateTimeConfiguration] = ISNULL(@IsDateTimeConfiguration,0),
											[IsSprintsConfiguration] = ISNULL(@IsSprintsConfiguration,0),
                                            ProjectUniqueName = 'P - ' + CAST(@UniqueNumber + 1 AS NVARCHAR(100)),
											[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
											[ProjectStartDate] = @ProjectStartDate,
											[ProjectStartDateTimeZoneId] =  CASE WHEN @ProjectStartDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
											[ProjectEndDateTimeZoneId] =  CASE WHEN @ProjectEndDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,
											
											[ProjectEndDate] = @ProjectEndDate
											WHERE Id = @ProjectId

									IF(@OldProjectName <> @ProjectName)
									BEGIN

										UPDATE Folder SET FolderName = @ProjectName,
														  UpdatedDateTime = @Currentdate,
														  UpdatedByUserId = @OperationsPerformedBy
														  WHERE Id = @ProjectId AND InActiveDateTime IS NULL

									END

								END
                            
                              DECLARE @ProjectResponsiblePersonIdCreated  UNIQUEIDENTIFIER = NEWID()
                              
                              DECLARE @UserProjectId  UNIQUEIDENTIFIER = NEWID()

                              DECLARE @UserCountForProject INT = (SELECT COUNT(1) FROM UserProject WHERE ProjectId = @ProjectId AND UserId = @ProjectResponsiblePersonId)
                             
                              IF(@ProjectResponsiblePersonId IS NOT NULL AND @UserCountForProject = 0)
                              BEGIN
                                     INSERT INTO [dbo].[UserProject](
                                             [Id],
                                             [ProjectId],
                                             [EntityRoleId],
                                             [UserId],
                                             [CreatedDateTime],
											 [CreatedDateTimeZoneId],
                                             [CreatedByUserId]
                                             )
                                      SELECT @ProjectResponsiblePersonIdCreated,
                                             @ProjectId,
                                             (SELECT Id FROM [dbo].[EntityRole] WHERE EntityRoleName = 'Project manager' AND CompanyId = @CompanyId),
                                             @ProjectResponsiblePersonId,
                                             @Currentdate,
											 @TimeZoneId,
                                             @OperationsPerformedBy
                                 
                              END
                              
                              DECLARE @UserCountForProjectwithOperationsPerformedBy INT = (SELECT COUNT(1) FROM UserProject WHERE ProjectId = @ProjectId AND UserId = @OperationsPerformedBy)
                              
							  IF(@OperationsPerformedBy <> @ProjectResponsiblePersonId AND @UserCountForProjectwithOperationsPerformedBy = 0)
                              BEGIN

                                  INSERT INTO [dbo].[UserProject](
                                                 [Id],
                                                 [ProjectId],
                                                 [EntityRoleId],
                                                 [UserId],
                                                 [CreatedDateTime],
												 [CreatedDateTimeZoneId],
                                                 [CreatedByUserId]
                                                 
                                                 )
                                          SELECT @UserProjectId,
                                                 @ProjectId,
                                                 (SELECT Id FROM [dbo].[EntityRole] WHERE EntityRoleName = 'Project manager' AND CompanyId = @CompanyId),
                                                 @OperationsPerformedBy,
                                                 @Currentdate,
												 @TimeZoneId,
                                                 @OperationsPerformedBy
                             END
                                
						 IF(ISNULL(@IsDateTimeConfiguration,0)  <> ISNULL(@IsDateTimeConfigurationOld,0))
						 BEGIN

                          UPDATE Goal SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour](G.Id)) FROM Goal G WHERE ProjectId = @ProjectId AND InActiveDateTime IS NULL AND ParkedDateTime IS NULL

						END

                        SELECT Id FROM [dbo].[Project] WHERE Id = @ProjectId
            END           
        END
        ELSE
           
           RAISERROR(50008,11,1)
       -- END
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